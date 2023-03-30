//
//  DraftResults.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/19/23.
//

import Foundation

// MARK: - DraftResults

struct DraftResults: Codable, Hashable, Identifiable {
    var leagueName: String
    var teams: [DraftTeam]
    var pickStack: Stack<DraftPlayer>
    var dateCompleted: Date
    var id: String { [leagueName, dateCompleted.getFormattedDate(format: .all)].joinString("-") }

    var numberOfRounds: Int {
        let picksPerRound = teams.count
        let numRounds = Int(ceil(Double(picksPerRound) / 2.0)) * 2 // ceil(numTeams / 2) rounds, rounded up to the nearest even number
        return pickStack.getArray().count / picksPerRound + (picksPerRound % picksPerRound == 0 ? 0 : 1)
    }

    func team(for player: DraftPlayer) -> DraftTeam? {
        for team in teams {
            if team.draftedPlayers.contains(player) {
                return team
            }
        }

        return nil
    }
    
    func getRoundNumber(for pickNumber: Int) -> Int {
        let picksPerRound = self.teams.count
        let numTeams = picksPerRound
        let numRounds = Int(ceil(Double(picksPerRound) / 2.0)) * 2 // ceil(numTeams / 2) rounds, rounded up to the nearest even number
        let adjustedPickNumber = true ? (pickNumber % (2 * picksPerRound) == 0 ? 2 * picksPerRound : pickNumber % (2 * picksPerRound)) : pickNumber
        let roundNumber = (adjustedPickNumber - 1) / picksPerRound + 1
        let isLastRound = roundNumber == numRounds
        let pickNumberInRound = isLastRound ? (numTeams - (adjustedPickNumber - (numRounds - 1) * picksPerRound)) + 1 : (adjustedPickNumber - (roundNumber - 1) * picksPerRound)
        return roundNumber
    }

    @discardableResult init(draft: Draft) {
        self.leagueName = draft.leagueName
        self.teams = draft.teams
        self.pickStack = draft.pickStack
        self.dateCompleted = .now
        DraftResults.save(self)
    }

    static func save(_ results: DraftResults) {
        var existing = loadResultsArray()
        existing.append(results)
        encodeDraftResultsArray(existing)
    }

    enum CodingKeys: String, CodingKey {
        case leagueName
        case teams
        case pickStack
        case dateCompleted
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(leagueName, forKey: .leagueName)
        try container.encode(teams, forKey: .teams)
        try container.encode(pickStack, forKey: .pickStack)
        try container.encode(dateCompleted, forKey: .dateCompleted)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.leagueName = try container.decode(String.self, forKey: .leagueName)
        self.teams = try container.decode([DraftTeam].self, forKey: .teams)
        self.pickStack = try container.decode(Stack<DraftPlayer>.self, forKey: .pickStack)
        self.dateCompleted = try container.decode(Date.self, forKey: .dateCompleted)
    }

    static let draftResultsArrayKey: String = "draftResultsArray"

    static func encodeDraftResultsArray(_ draftResultsArray: [DraftResults]) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try encoder.encode(draftResultsArray)
            UserDefaults.standard.set(jsonData, forKey: draftResultsArrayKey)
        } catch {
            print("Error encoding data: \(error)")
        }
    }

    static func decodeDraftResultsArray(from data: Data) throws -> [DraftResults] {
        let decoder = JSONDecoder()
        return try decoder.decode([DraftResults].self, from: data)
    }

    static func loadResultsArray() -> [DraftResults] {
        guard let jsonData: Data = UserDefaults.standard.data(forKey: draftResultsArrayKey) else {
            return []
        }
        var retArr: [DraftResults] = []
        do {
            let draftResultsArray = try decodeDraftResultsArray(from: jsonData)
            retArr = draftResultsArray
        } catch {
            print("Error decoding data: \(error)")
        }
        return retArr
    }
}

// MARK: - DraftAnalysis

// struct DraftAnalysis {
//    /// A bigger reach value would be a lesser pickNumber - ADP
//    static func reachesRanked(_ results: DraftResults) -> [DraftPlayer] {
//        let sortedArr = results.pickStack.getArray().sorted { firstPlayer, secondPlayer in
//            return firstPlayer.reach < secondPlayer.reach
//        }
//        return sortedArr
//    }
// }

struct DraftAnalysis {
    static func reachesRanked(_ results: DraftResults, completion: @escaping ([DraftPlayer]) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let sortedArr = results.pickStack.getArray().sorted { firstPlayer, secondPlayer in
                firstPlayer.reach < secondPlayer.reach
            }
            DispatchQueue.main.async {
                completion(sortedArr)
            }
        }
    }
}
