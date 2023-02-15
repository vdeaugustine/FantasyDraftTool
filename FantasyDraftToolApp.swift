//
//  FantasyDraftToolApp.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/11/23.
//

import SwiftUI

@main
struct FantasyDraftToolApp: App {
    @StateObject private var model: MainModel = MainModel.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
    }
}
