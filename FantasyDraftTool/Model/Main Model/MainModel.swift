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

    @Published var draft: Draft = .init(teams: DraftTeam.someDefaultTeams(amount: 10), settings: .defaultSettings)

    @Published var navPathForDrafting: [DraftPath] = []

    @Published var myStatsPlayers: MyStatsPlayers = .init()

    @Published var myModifiedBatters: Set<ParsedBatter> = []

    @Published var defaultProjectionSystem: ProjectionTypes = .atc

    var storedPoints: [String: Double] = [:]

    // MARK: - Stored Properties

    // MARK: - Computed Properties

    // MARK: - Static Properties

    static var shared: MainModel = { MainModel.load() ?? MainModel() }()

    static let key = "mainModelKey"

    // MARK: - Static functions

    static func keyFor(player: ParsedBatter, scoringSettings: ScoringSettings) -> String {
        "\(player.projectionType.str)-\(player)-\(scoringSettings.defaultsKey)"
    }

    // MARK: - Methods

    func points(for player: ParsedBatter, scoring: ScoringSettings? = nil) -> Double {
        let useScoring = scoring ?? self.scoringSettings
        let key = MainModel.keyFor(player: player, scoringSettings: useScoring)
        if let foundValue = storedPoints[key] {
            print("For \(player.name), Found value: ", foundValue)
            return foundValue
        }
        let points = player.fantasyPoints(useScoring)
        print("For \(player.name), Generated value: ", points)
        storedPoints[key] = points
        return points
    }

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
        self.storedPoints = try values.decode([String: Double].self, forKey: .storedPoints)
    }

    init() { }
}

// MARK: - Codable, Hashable, Equatable

extension MainModel {
    enum CodingKeys: CodingKey {
        case scoringSettings, draft, myStatsPlayers, defaultProjectionSystem, myModifiedBatters, storedPoints
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(scoringSettings, forKey: .scoringSettings)
        try container.encode(draft, forKey: .draft)
        try container.encode(myStatsPlayers, forKey: .myStatsPlayers)
        try container.encode(defaultProjectionSystem, forKey: .defaultProjectionSystem)
        try container.encode(myModifiedBatters, forKey: .myModifiedBatters)
        try container.encode(storedPoints, forKey: .storedPoints)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(scoringSettings)
        hasher.combine(draft)
        hasher.combine(myStatsPlayers)
        hasher.combine(defaultProjectionSystem)
        hasher.combine(myModifiedBatters)
        hasher.combine(storedPoints)
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
