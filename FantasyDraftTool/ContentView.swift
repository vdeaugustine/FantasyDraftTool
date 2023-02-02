//
//  ContentView.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/28/23.
//

import SwiftUI

// MARK: - DraftPath

enum DraftPath: Hashable {
    case setUpGeneral
    case setUpTeams
    case main
}

// MARK: - ContentView

struct ContentView: View {
    @EnvironmentObject private var model: MainModel

    var body: some View {
        TabView {
            NavigationView {
                AllBattersListView()
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tag(0)
            .tabItem {
                Label("List", systemImage: "list.bullet")
            }

            NavigationStack(path: $model.navPathForDrafting) {
                SetupDraftView()
                    .onAppear {
                        
                        if UserDefaults.isCurrentlyInDraft {
                        model.navPathForDrafting = [.setUpGeneral, .setUpTeams, .main]
                        }
                    }

                    .navigationDestination(for: DraftPath.self) { thisView in
                        switch thisView {
                            case .setUpGeneral, .setUpTeams:
                                SetUpDraftTeamsView()
                            case .main:
                                DraftView()
                        }
                    }
            }
            .navigationBarTitleDisplayMode(.inline)
            .tag(1)
            .tabItem {
                Label("Draft", systemImage: "square.and.arrow.down")
            }
        }
    }
}

// MARK: - ContentView_Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(MainModel.shared)
    }
}
