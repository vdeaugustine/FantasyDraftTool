//
//  SetupDraftView.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/28/23.
//

import SwiftUI

// MARK: - SetupDraftView

struct SetupDraftView: View {
    @EnvironmentObject private var model: MainModel

    @State private var numberOfTeams: Int = 10
    @State private var snakeDraft: Bool = true
    @State private var numberOfRounds: Int = 25
    @State private var scoringSystem: ScoringSettings = .defaultPoints
    var body: some View {
        Form {
            Picker("Number of teams", selection: $model.draft.settings.numberOfTeams) {
                ForEach([8, 10, 12, 15], id: \.self) { num in
                    Text(num.str)
                        .tag(num)
                }
            }
            Picker("Snake Draft", selection: $model.draft.settings.snakeDraft) {
                Text("Yes").tag(true)
                Text("No").tag(false)
            }
            Picker("Roster Size", selection: $model.draft.settings.numberOfRounds) {
                ForEach(10 ... 30, id: \.self) { num in
                    Text(num.str).tag(num)
                }
            }
            NavigationLink {
            } label: {
                Text("Scoring Settings")
            }

            Section {
                Button("Save custom settings") {
                }
            } footer: {
                Text("Save for future use")
            }

            Section {
                Button {
                    model.navPathForDrafting.append(.setUpTeams)
                } label: {
                    Text("Proceed to set up teams")
                        .foregroundColor(.blue)
                }
                
            }
        }
        .navigationTitle("Set up Draft")
    }
}

// MARK: - SetupDraftView_Previews

struct SetupDraftView_Previews: PreviewProvider {
    static var previews: some View {
        SetupDraftView()
            .putInNavView(displayMode: .inline)
            .environmentObject(MainModel.shared)
    }
}
