//
//  NVDraftSummary.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/19/23.
//

import SwiftUI

struct NVDraftSummaryView: View {
    @EnvironmentObject private var model: MainModel
    @State private var showingTeam: DraftTeam = .init(name: "NULL", draftPosition: 0)
    @State private var filterTeam: Bool = false


    var showingPlayers: [DraftPlayer] {
        let filteredByTeam: [DraftPlayer] = {
            if filterTeam {
                return model.draft.pickStack.getArray().filter { draftPlayer in
                    guard let draftedTeam = draftPlayer.draftedTeam else {
                        return false
                    }
                    return draftedTeam == showingTeam
                }
            } else {
                return model.draft.pickStack.getArray()
            }

        }()

        let filteredByTeamAndPositions = filteredByTeam.filter {
            Set($0.player.positions).intersection(selectedPositions).count != 0
        }

        return selectedPositions.isEmpty ? filteredByTeam : filteredByTeamAndPositions
    }

    @State private var selectedPositions: Set<Position> = []

    var body: some View {
        List {
            StrongestAtEachPositionView()
                .height(350)
                .padding(3)

            Section {
                Toggle("Filter by team", isOn: $filterTeam)

                if filterTeam {
                    Picker("Team", selection: $showingTeam) {
                        ForEach(model.draft.teams, id: \.self) { team in
                            Text(team.name)
                                .tag(team)
                        }
                    }
                }
            }

            Section("Team average points per position") {
                TeamsChart(label: "Team Points", data: $model.draft.teams)
            }

            SelectPositionsHScroll(selectedPositions: $selectedPositions)

            Section("Filtered") {
                ForEach(showingPlayers, id: \.self) { player in
                    Text(player.player.name + " \(player.player.posStr())")
                }
            }

            Section("All drafted") {
                ForEach(model.draft.pickStack.getArray(), id: \.self) { player in
                    if let draftTeam = player.draftedTeam {
                        Text("#\(player.pickNumber) " + " \(draftTeam.name): " + player.player.name)
                    }
                    
                }
            }
        }
        .listStyle(.plain)
        .onAppear {
            if model.draft.teams.count > 0 {
                showingTeam = model.draft.teams[0]
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - DraftSummaryView_Previews

struct NVDraftSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        DraftSummaryView()
            .environmentObject(MainModel.shared)
            .putInNavView()
    }
}
