//
//  SetUpDraftTeamsView.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/28/23.
//

import SwiftUI

// MARK: - SetUpDraftTeamsView

struct SetUpDraftTeamsView: View {
    let snakeDraft: Bool
    let numberOfRounds: Int
    let scoringSystem: ScoringSettings

    @Binding var numberOfTeams: Int
    @State private var teams: [DraftTeam] = []
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        Form {
            ForEach(teams.indices, id: \.self) { teamIndex in
                TextField(teams[teamIndex].name, text: $teams[teamIndex].name)
            }

            Section {
                NavigationLink {
                    DraftView(
                        draft: Draft(teams: teams,
                                     currentPickNumber: 1,
                                     settings: DraftSettings(numberOfTeams: numberOfTeams,
                                                             snakeDraft: snakeDraft,
                                                             numberOfRounds: numberOfRounds,
                                                             scoringSystem: scoringSystem))
                    )
                } label: {
                    Text("Start Draft")
                        .foregroundColor(.blue)
                }
            }
        }
        .onAppear {
            teams = (0 ..< numberOfTeams)
                .map {
                    DraftTeam(name: "Team \($0 + 1)", draftPosition: $0)
                }
        }
        .toolbarButton("Done") {
            dismiss()
        }
        .navigationTitle("Edit Team Names")
    }
}

// MARK: - SetUpDraftTeamsView_Previews

struct SetUpDraftTeamsView_Previews: PreviewProvider {
    static var previews: some View {
        SetUpDraftTeamsView(snakeDraft: true,
                            numberOfRounds: 25,
                            scoringSystem: .defaultPoints,
                            numberOfTeams: .constant(10))
            .putInNavView(displayMode: .inline)
    }
}
