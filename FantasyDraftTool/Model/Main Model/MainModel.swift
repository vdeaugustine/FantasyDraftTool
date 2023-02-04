//
//  MainModel.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/1/23.
//

import Foundation

// MARK: - MainModel

class MainModel: ObservableObject, Codable, Hashable, Equatable {
    // MARK: - Published Properties

    @Published var scoringSettings: ScoringSettings = .defaultPoints

    @Published var draft: Draft = Draft(teams: DraftTeam.someDefaultTeams(amount: 10),
                                        currentPickNumber: 1,
                                        settings: .init(numberOfTeams: 10,
                                                        snakeDraft: true,
                                                        numberOfRounds: 25,
                                                        scoringSystem: .defaultPoints),
                                        myTeamIndex: 10)

    @Published var navPathForDrafting: [DraftPath] = []

    @Published var myStatsPlayers: MyStatsPlayers = .init()

    // MARK: - Stored Properties

    // MARK: - Computed Properties

    // MARK: - Static Properties

    static var shared: MainModel = { MainModel.load() ?? MainModel() }()

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

    // MARK: - Initializers

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.scoringSettings = try values.decode(ScoringSettings.self, forKey: .scoringSettings)
        self.draft = try values.decode(Draft.self, forKey: .draft)
        self.myStatsPlayers = try values.decode(MyStatsPlayers.self, forKey: .myStatsPlayers)
    }

    init() { }
}

// MARK: - Codable, Hashable, Equatable

extension MainModel {
    enum CodingKeys: CodingKey {
        case scoringSettings, draft, myStatsPlayers
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(scoringSettings, forKey: .scoringSettings)
        try container.encode(draft, forKey: .draft)
        try container.encode(myStatsPlayers, forKey: .myStatsPlayers)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(scoringSettings)
        hasher.combine(draft)
        hasher.combine(myStatsPlayers)
    }

    static func == (lhs: MainModel, rhs: MainModel) -> Bool {
        return lhs.scoringSettings == rhs.scoringSettings &&
            lhs.draft == rhs.draft &&
            lhs.myStatsPlayers == rhs.myStatsPlayers
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
