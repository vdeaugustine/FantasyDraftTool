//
//  SetUpScoringView.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/14/23.
//

import SwiftUI

// MARK: - SetUpScoringView

struct SetUpScoringView: View {
    @State private var statKeyToChange: String = ""
    @State private var enteredNewValue: String = ""
    @State private var showAlert = false
    @Binding var scoringToSave: ScoringSettings
    @State private var scoringSettings: ScoringSettings = .defaultPoints
    @Environment (\.dismiss) private var dismiss
    

    var body: some View {
        VStack {
            Text("Set Up Scoring")
                .font(size: 28, color: .white, weight: .bold)
                .pushLeft()
                .padding([.top, .leading])
            List {
                Section {
                    ForEach(ScoringSettings.batterStatKey, id: \.self) { statKey in

                        if let pointValue = scoringSettings.getValue(for: statKey) {
                            Text(statKey)
                                .spacedOut(text: pointValue.simpleStr())
                                .allPartsTappable(alignment: .leading)
                                .onTapGesture {
                                    statKeyToChange = statKey
                                    enteredNewValue = ""
                                    showAlert = true
                                }
                        }
                    }
                    .listRowBackground(Color.niceGray)
                    .listRowSeparatorTint(Color.white)
                } header: {
                    HStack {
                        Text("Batter Stats")
                            .font(size: 16, color: .lighterGray, weight: .medium)
                    }
                }

                Section {
                    ForEach(ScoringSettings.pitcherStatKey, id: \.self) { statKey in

                        if let pointValue = scoringSettings.getValue(for: statKey) {
                            Text(statKey)
                                .spacedOut(text: pointValue.simpleStr())
                                .allPartsTappable(alignment: .leading)
                                .onTapGesture {
                                    statKeyToChange = statKey
                                    enteredNewValue = ""
                                    showAlert = true
                                }
                        }
                    }
                    .listRowBackground(Color.niceGray)
                    .listRowSeparatorTint(Color.white)
                } header: {
                    HStack {
                        Text("Pitcher Stats")
                            .font(size: 16, color: .lighterGray, weight: .medium)
                    }
                }
                
                Button {
                    
                    scoringToSave = scoringSettings
                    dismiss()
                } label: {
                    Label("Save", systemImage: "")
                        .labelStyle(.titleOnly)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        
                }
                .frame(maxWidth: .infinity)
                .listRowBackground(Color.niceBlue)
            }
            .scrollContentBackground(.hidden)
        }
        .background {
            Color.backgroundBlue
        }
        .alert("Edit value for \(statKeyToChange)", isPresented: $showAlert) {
            TextField(scoringSettings.getValue(for: statKeyToChange)?.simpleStr() ?? statKeyToChange, text: $enteredNewValue)
                .keyboardType(.decimalPad)

            Button("Cancel", role: .cancel) {
                statKeyToChange = ""
                enteredNewValue = ""
                showAlert = false
            }
            Button("SAVE", role: .destructive) {
                guard let dub = Double(enteredNewValue) else {
                    return
                }

                scoringSettings.changeValue(for: statKeyToChange, to: dub)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .presentationDetents([.fraction(0.9999)])
        
    }
}

// MARK: - SetUpScoringView_Previews

struct SetUpScoringView_Previews: PreviewProvider {
    static var previews: some View {
        SetUpScoringView(scoringToSave: .constant(.defaultPoints))
    }
}
