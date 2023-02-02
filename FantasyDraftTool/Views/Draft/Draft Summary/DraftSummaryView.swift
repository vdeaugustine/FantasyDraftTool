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
        return draft.pickStack.getArray()
    }

    @State private var selectedPositions: Set<Position> = []

    var body: some View {
        VStack {
            Picker("Team", selection: $showingTeam) {
                ForEach(draft.teams, id: \.self) { team in
                    Text(team.name)
                        .tag(team.name)
                }
            }

            SelectPositionsHScroll(selectedPositions: $selectedPositions)

            List {
                Section {
                    ForEach(showingPlayers, id: \.self) { player in
                        Text(player.player.name)
                    }
                }

                Section {
                    ForEach(draft.pickStack.getArray(), id: \.self) { player in
                        Text(player.team.name + ":" + player.player.name)
                    }
                }
            }
        }
        .onAppear {
            showingTeam = draft.teams[0]
        }
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
