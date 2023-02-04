//
//  SetUpDraftTeamsView.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/28/23.
//

import SwiftUI

// MARK: - SetUpDraftTeamsView

struct SetUpDraftTeamsView: View {
    @EnvironmentObject private var model: MainModel

    @Environment(\.editMode) private var editMode

    @State private var teams: [DraftTeam] = DraftTeam.someDefaultTeams(amount: 10)
    @Environment(\.dismiss) private var dismiss

    @State private var myTeamIndex: Int = 0

    @State private var selectedIndex: Int = 0

    @State private var showAlertToChangeName: Bool = false

    @State private var newTeamName: String = ""

    func move(from source: IndexSet, to destination: Int) {
        // move the data here
        model.draft.teams.move(fromOffsets: source, toOffset: destination)
    }

    var body: some View {
        Form {
            Section {
                ForEach(model.draft.teams.indices, id: \.self) { teamIndex in
                    HStack {
                        HStack(alignment: .bottom) {
                            Text((teamIndex + 1).str + ".")
                            Text(model.draft.teams[teamIndex].name)
                        }
                        Spacer()
                    }
                    .allPartsTappable()
                    .onTapGesture {
                        selectedIndex = teamIndex
                        showAlertToChangeName.toggle()
                    }
                }
                .onMove(perform: move)
            } header: {
                Text("Draft Order")
            } footer: {
                Text("Tap on row to edit team name")
            }

            Section {
                Picker("My team", selection: $model.draft.myTeamIndex) {
                    ForEach(model.draft.teams.indices, id: \.self) { index in
                        Text(model.draft.teams[index].name)
                            .tag(index)
                    }
                }
                Text("My team index: \(model.draft.myTeamIndex)")
            }

            Section {
                Button {
                    model.navPathForDrafting.append(.main)
                } label: {
                    Text("Start Draft")
                        .foregroundColor(.blue)
                }
            }
        }

        .toolbar {
            EditButton()
        }

        .alert("Edit team name", isPresented: $showAlertToChangeName) {
            TextField(teams[selectedIndex].name, text: $newTeamName)
            Button("Save") {
                model.draft.teams[selectedIndex].name = newTeamName
                newTeamName = ""
            }
            Button("Cancel", role: .cancel) {}
        }

        .navigationTitle("Edit Team Names")
    }
}

// MARK: - SetUpDraftTeamsView_Previews

struct SetUpDraftTeamsView_Previews: PreviewProvider {
    static var previews: some View {
        SetUpDraftTeamsView()
            .putInNavView(displayMode: .inline)
            .environmentObject(MainModel.shared)
    }
}
