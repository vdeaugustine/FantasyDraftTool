//
//  DVSetUpRosterStructureView.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/14/23.
//

import SwiftUI

// MARK: - DVSetUpRosterStructureView

struct DVSetUpRosterStructureView: View {
    @State private var statKeyToChange: Position? = nil
    @State private var enteredNewValue: String = ""
    @State private var showAlert = false
    @Binding var draft: Draft
    @Environment(\.dismiss) private var dismiss
    @State private var workingCopyDraft: Draft = .nullDraft
    @State private var keyEditing: String = ""
    @State private var valueEditing: Int = 0
    @State private var totalRosterSize: Int = 25

    var body: some View {
        VStack {
            Text("Setup Roster")
                .font(size: 28, color: .white, weight: .bold)
                .pushLeft()
                .padding([.top, .leading])
                .padding([.top, .leading])
            Form {
                Section {
                    Stepper(totalRosterSize.str, value: $totalRosterSize)
                } header: {
                    Text("Total Players Per Team")
                        .font(size: 16, color: MainModel.shared.specificColor.lighter, weight: .medium)
                }

                .listRowBackground(MainModel.shared.specificColor.rect)

                Section {
                    ForEach(workingCopyDraft.rosterConstruction.keysArr, id: \.self) { key in

                        if let minForKey = workingCopyDraft.rosterConstruction.minForPositions[key] {
                            HStack {
                                HStack {
                                    Text(key.str.uppercased())
                                        .fontWeight(.bold)
                                    Text(minForKey.str)
                                        .fontWeight(.light)
                                }

                                Spacer()

                                Stepper("") {
                                    if minForKey < 10 {
                                        workingCopyDraft.rosterConstruction.minForPositions[key] = (minForKey + 1) > 10 ? 0 : (minForKey + 1)
                                    }
                                    
                                    

                                } onDecrement: {
                                    if minForKey > 0 {
                                        workingCopyDraft.rosterConstruction.minForPositions[key] = (minForKey - 1) < 0 ? 0 : (minForKey - 1)
                                    }
                                }
                            }
                        }
                    }

                } header: {
                    Text("Minimum for Each Position")
                        .font(size: 16, color: MainModel.shared.specificColor.lighter, weight: .medium)
                }

                .listRowBackground(MainModel.shared.specificColor.rect)

                Section {
                    Button {
                        draft = workingCopyDraft
                        dismiss()
                    } label: {
                        Label("Save", systemImage: "")
                            .labelStyle(.titleOnly)
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .listRowBackground(MainModel.shared.specificColor.nice)
                }
                
                Section {
                    Button {
                        dismiss()
                    } label: {
                        Label("Cancel", systemImage: "")
                            .labelStyle(.titleOnly)
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .listRowBackground(MainModel.shared.specificColor.rect)
                }
            }
            .scrollContentBackground(.hidden)
        }
        .background {
            MainModel.shared.specificColor.background.ignoresSafeArea()
        }
        .navigationBarTitleDisplayMode(.inline)
        .presentationDetents([.fraction(0.9999)])
        .onAppear {
            workingCopyDraft = draft
            totalRosterSize = draft.rosterConstruction.totalPlayers
        }
    }
}

// MARK: - DVSetUpRosterStructureView_Previews

struct DVSetUpRosterStructureView_Previews: PreviewProvider {
    static var previews: some View {
        DVSetUpRosterStructureView(draft: .constant(Draft(teams: DraftTeam.someDefaultTeams(amount: 10), settings: .defaultSettings)))
    }
}
