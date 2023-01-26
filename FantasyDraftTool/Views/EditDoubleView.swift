//
//  EditValueView.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/15/23.
//

import SwiftUI

struct EditDoubleView: View {
    @Binding var initialValue: Double
    @State private var newValue: String = ""
    @State private var showNotDoubleAlert = false
    @Environment (\.dismiss) private var dismiss
    
    var body: some View {
        List {
            Text("Change")
                .spacedOut(text: initialValue.str)
            Text("To")
                .spacedOut {
                    TextField("New Value", text: $newValue)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                }
            
            if !newValue.isEmpty,
               let double = Double(newValue),
               double != initialValue {
                Section {
                    Button("Save") {
                        initialValue = double
                        dismiss()
                    }
                }
            }
               
            
            
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    hideKeyboard()
                }
            }
        }
        .alert("Please enter a valid number", isPresented: $showNotDoubleAlert) {
            Button("OK") {
                
            }
            Button("Cancel", role: .cancel) {
                dismiss()
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
    
    
}

struct EditValueView_Previews: PreviewProvider {
    static var previews: some View {
        EditDoubleView(initialValue: .constant(20))
    }
}
