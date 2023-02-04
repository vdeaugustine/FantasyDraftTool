//
//  Draft.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/28/23.
//

import Foundation

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
        let lastIndex = teams.count - 1
        let nextToLast = teams.count - 1 - 1
        
        // We are on the last index
        if currentIndex >= lastIndex {
            // The previous pick was also at the last index
            if previousIndex >= lastIndex {
                // Move down one from count to get index number of last item, then move down one from there since we are going down
                currentIndex = nextToLast
                // Since we are going down, make previous index the last index in the array
                previousIndex = lastIndex
            }
            // Need to repeat last pick
            else {
                previousIndex = lastIndex
                currentIndex = lastIndex
            }
        }
        // We are on the first index
        else if currentIndex <= 0 {
            // The previous pick was also at the first index
            if previousIndex <= 0 {
                // Move up one to get index number of first item, then move up one from there since we are going up
                currentIndex = 1
                // Since we are going down, make previous index the last index in the array
                previousIndex = 0
            } else {
                previousIndex = currentIndex
            }
        }
        // We are neither on the first or last index
        else {
            // We are going up
            if previousIndex < currentIndex {
                currentIndex += 1
                previousIndex += 1
            }
            
            // We are going down
            if previousIndex > currentIndex {
                previousIndex -= 1
                currentIndex -= 1
            }
            
        }
        
        if currentIndex >= teams.count {
            currentIndex = teams.count - 1
        }
        if currentIndex < 0 {
            currentIndex = 0
        }
        
    }
    mutating func makePick(_ player: DraftPlayer) {
        removeFromPool(player: player)
        pickStack.push(player)
        totalPickNumber += 1
//        let currentTeamIndex: Int = roundNumber.isEven ? settings.numberOfTeams - roundPickNumber : roundPickNumber - 1
        teams[currentIndex].draftedPlayers.append(player)
        setNextTeam()
    }

    mutating func setNextTeam() {
//        let currentTeamIndex: Int = roundNumber.isEven ? settings.numberOfTeams - roundPickNumber : roundPickNumber - 1
        changeCurrentIndex()
        currentTeam = teams[currentIndex]
    }

    // MARK: - Computed Properties

    var roundNumber: Int {
        guard settings.numberOfTeams > 0 else { return 0 }
        return (totalPickNumber - 1) / settings.numberOfTeams + 1
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

    // MARK: - Mutating Methods

    mutating func removeFromPool(player: DraftPlayer) {
        for position in player.player.positions {
            if var previousArray = playerPool.battersDict[position] {
                let prevArrCheck = previousArray
                previousArray.removeAll(where: { $0 == player.player })
                guard prevArrCheck != previousArray else {
                    return
                }

                playerPool.battersDict[position] = previousArray
            }
        }
        playerPool.recalculateDict(for: player.player.positions)
    }

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

        let sum: Double = batters.reduce(0) { $0 + $1.player.fantasyPoints(.defaultPoints) }
        return (sum / Double(batters.count)).roundTo(places: 1)
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
