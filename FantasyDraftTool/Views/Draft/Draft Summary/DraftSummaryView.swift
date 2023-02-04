//
//  DraftSummaryView.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/29/23.
//

import SwiftUI

// MARK: - DraftSummaryView

struct DraftSummaryView: View {
    @EnvironmentObject private var model: MainModel
    @State private var showingTeam: DraftTeam = .init(name: "NULL", draftPosition: 0)

    var draft: Draft { model.draft }

    var showingPlayers: [DraftPlayer] {
        let filteredByTeam = draft.pickStack.getArray()
            .filter({$0.draftedTeam! == showingTeam})
        
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

            Picker("Team", selection: $showingTeam) {
                ForEach(draft.teams, id: \.self) { team in
                    Text(team.name)
                        .tag(team)
                }
            }

            SelectPositionsHScroll(selectedPositions: $selectedPositions)

                Section("Filtered") {
                    ForEach(showingPlayers, id: \.self) { player in
                        Text(player.player.name + " \(player.player.posStr())")
                    }
                }

                Section("All drafted") {
                    ForEach(draft.pickStack.getArray(), id: \.self) { player in
                        Text("#\(player.pickNumber) " + " \(player.draftedTeam?.name ?? ""): " + player.player.name)
                    }
                }
            
        }
        .listStyle(.plain)
        .onAppear {
            showingTeam = draft.teams[0]
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - DraftSummaryView_Previews

struct DraftSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        DraftSummaryView()
            .environmentObject(MainModel.shared)
            .putInNavView()
    }
}
