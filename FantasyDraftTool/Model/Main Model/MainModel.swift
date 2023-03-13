//
//  MainModel.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/1/23.
//

import Foundation
import SwiftUI

// MARK: - MainModel

class MainModel: ObservableObject, Codable, Hashable, Equatable {
    // MARK: - Published Properties

    @Published var scoringSettings: ScoringSettings = .defaultPoints

    @Published var draft: Draft = {
        #if DEBUG
            Draft.loadExample() ?? Draft.exampleDraft(picksMade: 0, projection: .atc)
//        Draft.exampleDraft(model: 100, projection: .atc)
        #else
                .nullDraft
        #endif
    }()

    @Published var navPathForDrafting: NavigationPath = .init()

    @Published var myStatsPlayers: MyStatsPlayers = .init()

    @Published var myModifiedBatters: Set<ParsedBatter> = []

    @Published var defaultProjectionSystem: ProjectionTypes = .atc

    @Published var draftLoadProgress: Double = 0

    @Published var limitForEachPosition: Int = 50

    @Published var mainSettings: MainSettings = MainSettings()

    @Published var myStarBatters: Set<ParsedBatter> = []
    @Published var myStarPitchers: Set<ParsedPitcher> = []

    var myStarPlayers: [any ParsedPlayer] { Array(myStarBatters) + Array(myStarPitchers) }

    func isStar(_ player: ParsedPlayer) -> Bool {
        myStarPlayers.contains(where: { $0.name == player.name })
    }

    func addOrRemoveStar(_ player: ParsedPlayer) {
        if isStar(player) {
            removeStar(player)
        } else {
            if let batter = player as? ParsedBatter {
                print("inserting ", batter.name)
                myStarBatters.insert(batter)
                print(myStarBatters)
            }
            if let pitcher = player as? ParsedPitcher {
                print("inserting ", pitcher.name)
                myStarPitchers.insert(pitcher)
                print(myStarPitchers)
            }
        }

        save()
    }

    func removeStar(_ player: ParsedPlayer) {
        if let batter = player as? ParsedBatter {
            myStarBatters.remove(batter)
        }
        if let pitcher = player as? ParsedPitcher {
            myStarPitchers.remove(pitcher)
        }

        save()
    }

//    @Published var positionLimit: Int = 50
//    @Published var outfieldLimit: Int = 150

    // MARK: - Stored Properties

    // MARK: - Computed Properties

    // MARK: - Static Properties

    static var shared: MainModel = {
        if let loaded = MainModel.load() {
            print("loaded", loaded)
            return loaded
        } else {
            print("new")
            return MainModel()
        }
    }()

    static let key = "mainModelKey"

    // MARK: - Static functions

    // MARK: - Methods

    func resetDraft() {
        let teams = draft.teams
        let myTeamIndex = draft.myTeamIndex
        let settings = draft.settings

        draft = Draft(teams: teams.map { DraftTeam(name: $0.name, draftPosition: $0.draftPosition) },
                      settings: settings,
                      myTeamIndex: myTeamIndex)
    }

    // MARK: - Getter methods

    func getScoringSettings() -> ScoringSettings {
        scoringSettings
    }

    // MARK: - Initializers

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.scoringSettings = try values.decode(ScoringSettings.self, forKey: .scoringSettings)
        self.draft = try values.decode(Draft.self, forKey: .draft)
        self.myStatsPlayers = try values.decode(MyStatsPlayers.self, forKey: .myStatsPlayers)
        self.myModifiedBatters = try values.decode(Set<ParsedBatter>.self, forKey: .myModifiedBatters)
        self.mainSettings = try values.decode(MainSettings.self, forKey: .mainSettings)
    }

    init() { }
}

// MARK: - Codable, Hashable, Equatable

extension MainModel {
    enum CodingKeys: CodingKey {
        case scoringSettings, draft, myStatsPlayers, defaultProjectionSystem, myModifiedBatters, mainSettings
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(scoringSettings, forKey: .scoringSettings)
        try container.encode(draft, forKey: .draft)
        try container.encode(myStatsPlayers, forKey: .myStatsPlayers)
        try container.encode(defaultProjectionSystem, forKey: .defaultProjectionSystem)
        try container.encode(myModifiedBatters, forKey: .myModifiedBatters)
        try container.encode(mainSettings, forKey: .mainSettings)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(scoringSettings)
        hasher.combine(draft)
        hasher.combine(myStatsPlayers)
        hasher.combine(defaultProjectionSystem)
        hasher.combine(myModifiedBatters)
        hasher.combine(mainSettings)
    }

    static func == (lhs: MainModel, rhs: MainModel) -> Bool {
        return lhs.scoringSettings == rhs.scoringSettings &&
            lhs.draft == rhs.draft &&
            lhs.myStatsPlayers == rhs.myStatsPlayers &&
            lhs.defaultProjectionSystem == rhs.defaultProjectionSystem
    }

    static func load() -> MainModel? {
        if let existing = UserDefaults.standard.data(forKey: "\(Self.key)") {
            do {
                let decoder = JSONDecoder()
                let model = try decoder.decode(MainModel.self, from: existing)
                return model
            } catch {
                print(error)
            }
        }
        return nil
    }

    func save() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            UserDefaults.standard.set(data, forKey: Self.key)

        } catch {
            print(error)
        }
    }
}
