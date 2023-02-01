//
//  Draft.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/28/23.
//

import Foundation

// MARK: - Draft

class Draft: ObservableObject {
    let teams: [DraftTeam]
    @Published var currentTeam: DraftTeam
    @Published var currentPickNumber: Int
    @Published var totalPickNumber: Int
    let settings: DraftSettings
    @Published var playerPool: PlayerPool = PlayerPool()
    @Published var pickStack: Stack<DraftPlayer> = .init()

    var roundNumber: Int {
        (totalPickNumber - 1) / settings.numberOfTeams + 1
    }

    var roundPickNumber: Int {
        (totalPickNumber - 1) % settings.numberOfTeams + 1
    }

    func removeFromPool(player: DraftPlayer) {
        for position in player.player.positions {
            if var previousArray = playerPool.battersDict[position] {
                previousArray.removeAll(where: { $0 == player.player })

                playerPool.battersDict[position] = previousArray
//                playerPool.batters = playerPool.battersDict.keys.reduce([ParsedBatter](), { partialResult, redPos in
//                    if let thisArr = playerPool.battersDict[redPos] {
//                        return partialResult + thisArr
//                    }
//                    return
//                }).sorted(by: {$0.fantasyPoints(.defaultPoints) > $1.fantasyPoints(.defaultPoints)})
            }
        }
        playerPool.recalculateDict(for: player.player.positions)
    }

    static var live: Draft = Draft(teams: [],
                                   currentPickNumber: 0,
                                   settings: .init(numberOfTeams: 0,
                                                   snakeDraft: true,
                                                   numberOfRounds: 25,
                                                   scoringSystem: .defaultPoints))

    init(teams: [DraftTeam], currentPickNumber: Int, settings: DraftSettings) {
        self.teams = teams
        self.currentPickNumber = currentPickNumber
        self.totalPickNumber = currentPickNumber
        self.settings = settings
        self.currentTeam = teams.first ?? DraftTeam(name: "", draftPosition: 0)
    }
}

// MARK: - PlayerPool

class PlayerPool {
//    var batters: [ParsedBatter] = AllParsedBatters.batters(for: .steamer)

    var batters: [ParsedBatter] {
        var retArr: [ParsedBatter] = []
        for position in Positions.batters {
            if let battersAtPosition = battersDict[position] {
                retArr += battersAtPosition
            }
        }
        return retArr
//        return retArr.sorted { firstBatter, secondBatter in
//            guard let firstBatterPosition = firstBatter.positions.first,
//                  let secondBatterPosition = secondBatter.positions.first,
//                  let firstAverage = positionAveragesDict[firstBatterPosition],
//                  let secondAverage = positionAveragesDict[secondBatterPosition] else {
//                return firstBatter.fantasyPoints(.defaultPoints) > secondBatter.fantasyPoints(.defaultPoints)
//            }
//
//            return firstBatter.weightedFantasyPoints(positionAverage: firstAverage) > secondBatter.weightedFantasyPoints(positionAverage: secondAverage)
//        }
    }

    var battersDict: [Positions: [ParsedBatter]] = {
        var retDict: [Positions: [ParsedBatter]] = [:]

        for position in Positions.batters {
            let battersForThisPoistion = AllParsedBatters.batters(for: .steamer, at: position)
            retDict[position] = battersForThisPoistion
        }

        return retDict
    }()

    lazy var positionAveragesDict: [Positions: Double] = {
        var retDict: [Positions: Double] = [:]
        for position in Positions.batters {
            let positionBatters = batters.filter { $0.positions.contains(position) }
            retDict[position] = ParsedBatter.averagePoints(forThese: positionBatters)
        }
        return retDict
    }()

    func recalculateDict() {
        for pos in battersDict.keys {
            if let posBatters = battersDict[pos] {
                positionAveragesDict[pos] = ParsedBatter.averagePoints(forThese: posBatters)
            }
        }
    }

    func recalculateDict(for positions: [Positions]) {
        
        for pos in positions {
            if let posBatters = battersDict[pos] {
                positionAveragesDict[pos] = ParsedBatter.averagePoints(forThese: posBatters)
            }
        }
        
//        for position in positions {
//            let positionBatters = batters.filter { $0.positions.contains(position) }
//            positionAveragesDict[position] = ParsedBatter.averagePoints(forThese: positionBatters)
//        }
    }
}
