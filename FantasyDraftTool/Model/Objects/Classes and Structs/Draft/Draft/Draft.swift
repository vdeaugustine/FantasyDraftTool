//
//  Draft.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/28/23.
//

import Foundation
import SwiftUI

// MARK: - Draft

struct Draft: Codable, Hashable, Equatable {
    // MARK: - Stored Properties

    var teams: [DraftTeam]
    var settings: DraftSettings
    var currentTeam: DraftTeam
    var currentPickNumber: Int
    var totalPickNumber: Int
    var playerPool: PlayerPool = PlayerPool()
    var pickStack: Stack<DraftPlayer> = .init()
    var currentIndex: Int = 0
    var previousIndex: Int = 0
    var bestPicksStack: Stack<BestPick> = .init()
    var totalPicksMade: Int = 1
    var projectedStack: Stack<DraftPlayer> = .init()

    var shouldEnd: Bool = false

    var myStarPlayers: Set<ParsedBatter> = []

    var projectionCurrentlyUsing: ProjectionTypes = .steamer

    var previousTeam: DraftTeam? {
        pickStack.getArray().first?.draftedTeam
    }

    var draftOver: Bool {
        let pickLimit = settings.numberOfRounds * settings.numberOfTeams
        return currentPickNumber >= pickLimit
    }

    /// This should be = teamPickOrder - 1
    var myTeamIndex: Int

    var myTeam: DraftTeam? {
        guard myTeamIndex < teams.count,
              myTeamIndex >= 0 else {
            return nil
        }
        return teams[myTeamIndex]
    }

    // MARK: - Mutating functions

    /// This is a mutating function that removes a player from the playerPool object based on their positions.
    mutating func removeFromPool(player: DraftPlayer) {
        // Loop through each position the player has.
        for position in player.player.positions {
            // Check if there is an array of batters in the playerPool dictionary for the current position.
            if var previousArray = playerPool.battersDict[position] {
                // Save a copy of the previous array for later comparison.
                let prevArrCheck = previousArray

                // Remove the player from the previous array, if present.
                previousArray.removeAll(where: { $0.name == player.player.name })

                // If the previous and updated arrays are the same, the player was not found in the array and we can exit early.
                guard prevArrCheck != previousArray else {
                    return
                }

                // Update the playerPool dictionary with the updated array of batters.
                playerPool.battersDict[position] = previousArray
            }
        }

        // Update the playerPool dictionaries with the updated list of players for each position.
        playerPool.updateDicts(for: player.player.positions)
    }

    mutating func changeCurrentTeam(to team: DraftTeam) {
        currentTeam = team
    }

    mutating func changeCurrentPick(to pickNumber: Int) {
        currentPickNumber = pickNumber
    }

    mutating func changeTotalPick(to pickNumber: Int) {
        totalPickNumber = pickNumber
    }

    mutating func changeCurrentIndex() {
        // Set the currentIndex to the total number of picks made minus 1.
        currentIndex = totalPicksMade - 1

        // Calculate the current round number based on the total number of picks made and the number of teams.
        let roundNumber: Int = Int(floor(Double(totalPicksMade) / Double(teams.count)) + 1)

        // Determine whether the draft is currently going up or down the list of teams.
        let goingUp: Bool = roundNumber % 2 != 0

        // Get the total number of teams.
        let numberOfTeams: Int = teams.count

        // Calculate the pick number for the current round.
        let pickNumber = goingUp ? totalPicksMade % numberOfTeams + 1 : numberOfTeams - totalPicksMade % numberOfTeams

        // Print the total number of picks made, the current round number, and the current pick number.
        print("total pick:", totalPicksMade, "round: ", roundNumber, "pick", pickNumber)

        // Set the currentIndex to the index of the team that is currently picking.
        currentIndex = pickNumber - 1

        // Print the name of the team that is currently picking.
//        print("team: ", teams[pickNumber - 1])
    }

    mutating func makePick(_ player: DraftPlayer) {
        removeFromPool(player: player)
        pickStack.push(player)
        totalPickNumber += 1
        totalPicksMade = pickStack.getArray().count
        teams[currentIndex].draftedPlayers.append(player)
        setNextTeam()
        playerPool.setPositionsOrder()
    }

    mutating func makePick(_ player: ParsedBatter) {
        makePick(.init(player: player, draft: self))
    }

    mutating func undoPick() {
        guard let lastPick = pickStack.popFirst() else { return }
        insertIntoPool(player: lastPick)
        totalPickNumber -= 1
        teams[currentIndex].draftedPlayers.removeAll(where: { $0 == lastPick })
        changeCurrentIndex()
        guard currentIndex > 0 && currentIndex < teams.count else { return }
        currentTeam = teams[currentIndex]
        playerPool.setPositionsOrder()
    }

    mutating func insertIntoPool(player: DraftPlayer) {
        for position in player.player.positions {
            playerPool.battersDict[position]?.append(player.player)
            playerPool.updateDicts(for: [position])
        }
    }

    mutating func setNextTeam() {
        changeCurrentIndex()
        currentTeam = teams[currentIndex]
    }

    // MARK: - Computed Properties

    var roundNumber: Int {
        guard settings.numberOfTeams > 0 else { return 0 }
        var number = (totalPickNumber - 1) / settings.numberOfTeams + 1
        if number > settings.numberOfRounds {
            number = settings.numberOfRounds
        }
        return number
    }

    var roundPickNumber: Int {
        guard settings.numberOfTeams > 0 else { return 0 }
        return (totalPickNumber - 1) % settings.numberOfTeams + 1
    }

    // MARK: - Static Properties

    static var live: Draft = Draft(teams: DraftTeam.someDefaultTeams(amount: 10),
                                   currentPickNumber: 1,
                                   settings: .init(numberOfTeams: 10,
                                                   snakeDraft: true,
                                                   numberOfRounds: 25,
                                                   scoringSystem: .defaultPoints),
                                   myTeamIndex: 0)

    // MARK: - Calculating Methods / Calculations

    func strongestTeam(for position: Position) -> DraftTeam {
        let unsortedTeams = teams
        let sortedTeams = unsortedTeams.sorted(by: { $0.points(for: position) > $1.points(for: position) })
        return sortedTeams.first!
    }

    func leagueAverage(for position: Position, excludeTopTeam: Bool = false) -> Double {
        let teamsToUse: [DraftTeam]
        if excludeTopTeam {
            let topTeam = strongestTeam(for: position)
            teamsToUse = teams.filter { $0 != topTeam }
        } else {
            teamsToUse = teams
        }

        let batters: [DraftPlayer] = teamsToUse.reduce([DraftPlayer]()) {
            $0 + $1.draftedPlayers.filter { $0.player.positions.contains(position) }
        }

        let sum: Double = batters.reduce(0) { $0 + $1.player.fantasyPoints(MainModel.shared.getScoringSettings()) }
        return (sum / Double(batters.count)).roundTo(places: 1)
    }

    func isStar(_ player: ParsedBatter) -> Bool {
        myStarPlayers.contains(where: { $0.name == player.name })
    }

    mutating func addOrRemoveStar(_ player: ParsedBatter) {
        if isStar(player) {
            removeStar(player)
        } else {
            myStarPlayers.insert(player)
        }
    }

    mutating func removeStar(_ player: ParsedBatter) {
        myStarPlayers.remove(player)
    }

    // MARK: - Initializers

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.teams = try values.decode([DraftTeam].self, forKey: .teams)
        self.settings = try values.decode(DraftSettings.self, forKey: .settings)
        self.currentTeam = try values.decode(DraftTeam.self, forKey: .currentTeam)
        self.currentPickNumber = try values.decode(Int.self, forKey: .currentPickNumber)
        self.totalPickNumber = try values.decode(Int.self, forKey: .totalPickNumber)
        self.playerPool = try values.decode(PlayerPool.self, forKey: .playerPool)
        self.pickStack = try values.decode(Stack<DraftPlayer>.self, forKey: .pickStack)
        self.myTeamIndex = try values.decode(Int.self, forKey: .myTeamIndex)
        self.myStarPlayers = try values.decode(Set<ParsedBatter>.self, forKey: .myStarPlayers)
    }

    init(teams: [DraftTeam], currentPickNumber: Int = 0, settings: DraftSettings, myTeamIndex: Int = 0) {
        self.teams = teams
        self.currentPickNumber = currentPickNumber
        self.totalPickNumber = 1
        self.settings = settings
        self.currentTeam = teams.first ?? DraftTeam(name: "", draftPosition: 0)
        self.myTeamIndex = myTeamIndex
    }
}

// MARK: - Codable, Equatable, Hashable

extension Draft {
    private enum CodingKeys: String, CodingKey {
        case teams
        case settings
        case currentTeam
        case currentPickNumber
        case totalPickNumber
        case playerPool
        case pickStack
        case myTeamIndex
        case myStarPlayers
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(teams, forKey: .teams)
        try container.encode(settings, forKey: .settings)
        try container.encode(currentTeam, forKey: .currentTeam)
        try container.encode(currentPickNumber, forKey: .currentPickNumber)
        try container.encode(totalPickNumber, forKey: .totalPickNumber)
        try container.encode(playerPool, forKey: .playerPool)
        try container.encode(pickStack, forKey: .pickStack)
        try container.encode(myTeamIndex, forKey: .myTeamIndex)
        try container.encode(myStarPlayers, forKey: .myStarPlayers)
    }

    static func == (lhs: Draft, rhs: Draft) -> Bool {
        return lhs.teams == rhs.teams && lhs.settings == rhs.settings && lhs.currentTeam == rhs.currentTeam && lhs.currentPickNumber == rhs.currentPickNumber && lhs.totalPickNumber == rhs.totalPickNumber && lhs.playerPool == rhs.playerPool && lhs.pickStack == rhs.pickStack
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(teams)
        hasher.combine(settings)
        hasher.combine(currentTeam)
        hasher.combine(currentPickNumber)
        hasher.combine(totalPickNumber)
        hasher.combine(playerPool)
        hasher.combine(pickStack)
    }
}

extension Draft {
    func simulateRemainingDraft() -> Stack<DraftPlayer> {
        var workingDraft: Draft = self

        while workingDraft.totalPicksMade <= workingDraft.settings.numberOfRounds * workingDraft.settings.numberOfTeams {
            let sortedBatters = workingDraft.playerPool.batters.removingDuplicates().sorted(by: { $0.zScore(draft: workingDraft) > $1.zScore(draft: workingDraft) })

            guard let chosenPlayer: ParsedBatter = sortedBatters.first else {
                break
            }

            let draftPlayer = DraftPlayer(player: chosenPlayer,
                                          pickNumber: workingDraft.totalPickNumber,
                                          team: workingDraft.currentTeam,
                                          weightedScore: chosenPlayer.zScore(draft: workingDraft))
            workingDraft.makePick(draftPlayer)
        }

        return workingDraft.pickStack
    }

    func simulatePicks(_ numPicks: Int, projection: ProjectionTypes, completion: @escaping (Draft) -> Void ) {
        var draft = self
        var picksMade: Int = 0

        while picksMade <= numPicks {
            if draft.draftOver { break }

            let availableBatters = draft.currentTeam.recommendedBattersDesc(draft: draft, projection: projection)

            if availableBatters.count == 1 {
                draft.makePick(.init(player: availableBatters[0], draft: draft))
            } else if availableBatters.count < 1 {
                break
            }

            guard let chosenPlayer: ParsedBatter = availableBatters.first else {
                break
            }

            draft.makePick(.init(player: chosenPlayer, draft: draft))
            picksMade += 1
        }
        
        completion(draft)
    }

    func simulatePicks(_ numPicks: Int, projection: ProjectionTypes, progress: Binding<Double>) -> Draft {
        var draft = self
        var picksMade: Int = 0

        while picksMade <= numPicks {
            if draft.draftOver { break }
//            print(draft.currentTeam.name + " is up. Their team looks like this")
//            for position in draft.currentTeam.minForPositions.keys {
//                print("\(position.str): \(draft.currentTeam.draftedPlayers.filter { $0.has(position: position) })")
//            }

            let availableBatters = draft.currentTeam.recommendedBattersDesc(draft: draft, projection: projection)

//            print("Next available: ", availableBatters.prefixArray(5))

            if availableBatters.count == 1 {
                draft.makePick(.init(player: availableBatters[0], draft: draft))
            } else if availableBatters.count < 1 {
                break
            }

            guard let chosenPlayer: ParsedBatter = availableBatters.first else {
                break
            }

//            print("Chosen player is \(chosenPlayer)")

            draft.makePick(.init(player: chosenPlayer, draft: draft))
            picksMade += 1

            let progressMade = Double(picksMade) / Double(numPicks)

            progress.wrappedValue = progressMade < 1 ? progressMade : 1
//            print("Progress", progress.wrappedValue)
        }

        return draft
    }

    static func exampleDraft(picksMade: Int = 30, model: MainModel, projection: ProjectionTypes) -> Draft {
        let testStart: Date = .now

        var draft = Draft(teams: DraftTeam.someDefaultTeams(amount: 10), settings: .defaultSettings)

        while draft.totalPicksMade <= picksMade {
//            print(draft.currentTeam.name + " is up. Their team looks like this")
//            for position in draft.currentTeam.minForPositions.keys {
//                print("\(position.str): \(draft.currentTeam.draftedPlayers.filter { $0.has(position: position) })")
//            }

//            let availableBatters = draft.currentTeam.recommendedBattersDesc(draft: draft)

//            print("Next available: ", availableBatters.prefixArray(5))

            guard let chosenPlayer: ParsedBatter = draft.currentTeam.recommendedPlayer(draft: draft, projection: projection) else {
                break
            }

//            print("Chosen player is \(chosenPlayer)")

            let draftPlayer = DraftPlayer(player: chosenPlayer,
                                          pickNumber: draft.totalPickNumber,
                                          team: draft.currentTeam,
                                          weightedScore: chosenPlayer.zScore(draft: draft))
            draft.makePick(draftPlayer)
            DispatchQueue.global().async {
//                print("changing load progress from: ", model.draftLoadProgress)

                model.draftLoadProgress = Double(draft.totalPicksMade) / Double(picksMade)
//                print("changing load progress to: ", model.draftLoadProgress)
            }
        }

        DispatchQueue.global().async {
//            print("changing load progress from: ", model.draftLoadProgress)

            model.draftLoadProgress = 1
//            print("changing load progress to: ", model.draftLoadProgress)
        }

        print("time for draft simulation: \(Date.now - testStart)")
        return draft
    }

    static let nullDraft: Draft = Draft(teams: DraftTeam.someDefaultTeams(amount: 10), settings: .defaultSettings)
}
