//
//  LoadingScreen.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/3/23.
//

import SwiftUI

struct LoadingScreen: View {
    @EnvironmentObject private var lm: LoadingManager
    
    var body: some View {
        VStack {
            Text("Loading...")
            ProgressView(value: lm.taskPercentage)
            Text(lm.displayString)
        }
        .padding()
    }
}

struct LoadingScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoadingScreen()
            .environmentObject(LoadingManager.shared)
    }
}
