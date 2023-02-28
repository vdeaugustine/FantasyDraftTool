//
//  SettingsView.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/10/23.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject private var model: MainModel
    
    var body: some View {
        Form {
            Picker("My Projections Default to", selection: $model.defaultProjectionSystem) {
                ForEach(ProjectionTypes.batterArr, id: \.self) { proj in
                    Text(proj.title)
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(MainModel.shared)
            .putInNavView()
    }
}
