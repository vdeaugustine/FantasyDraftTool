//
//  ScoringSettingsView.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/24/23.
//

import SwiftUI

// MARK: - ScoringSettingsView

struct ScoringSettingsView: View {
    @State private var newSettings = ScoringSettings.defaultPoints
    @State private var statToEdit: Naming = .tb
    @State private var showAlert = false
    @State private var newValue = ""
    @Environment (\.dismiss) private var dismiss
    var body: some View {
        List {
            ForEach(Naming.cases, id: \.self) { statName in

                if let stat = newSettings.dict[statName.rawValue] {
                    Button {
                        statToEdit = statName
                        showAlert.toggle()
                    } label: {
                        HStack {
                            Text(statName.str)
                                .spacedOut(text: stat.str)
                        }
                        .allPartsTappable()
                    }
                    .buttonStyle(.plain)
                }
            }
        }

        .alert("Change value for \(statToEdit.str)", isPresented: $showAlert) {
            TextField(newSettings.dict[statToEdit.rawValue]?.str ?? "", text: $newValue)
                .keyboardType(.decimalPad)

            Button("Done", role: .cancel) {
                guard let dub = Double(newValue) else { return }
                newSettings.changeValue(to: dub, for: statToEdit)
                newValue = ""
            }
        }
        .navigationTitle("Scoring settings")
        .toolbarSave {
            dismiss()
        }
    }
}

// MARK: - ScoringSettingsView_Previews

struct ScoringSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ScoringSettingsView()
            .putInNavView()
    }
}
