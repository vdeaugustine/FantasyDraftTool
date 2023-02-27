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
    case teamSummary
}

// MARK: - ContentView

struct ContentView: View {
    @EnvironmentObject private var model: MainModel
    @State private var selectedTab: Int = 0
    @State private var batters: [ExtendedBatter] = []
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                NVAllPlayers()
            }
            .tag(0)
            .tabItem {
                Label("List", systemImage: "list.bullet")
            }
            .navigationBarTitleDisplayMode(.inline)

            NavigationStack(path: $model.navPathForDrafting) {
                NVDraft()
                    .onAppear {
                        model.draftLoadProgress = 0
                    }
            }
            .tag(1)
            .tabItem {
                Label("Draft", systemImage: "list.bullet")
            }
            .navigationBarTitleDisplayMode(.inline)
            
            NavigationView {
                NVSettings()
                    
            }
            .tag(2)
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
            .navigationBarTitleDisplayMode(.inline)
            
            

//
//            NavigationView {
//                AllBattersListView()
//                    .navigationBarTitleDisplayMode(.inline)
//            }
//            .tag(0)
//            .tabItem {
//                Label("List", systemImage: "list.bullet")
//            }
//
//            NavigationStack(path: $model.navPathForDrafting) {
//                SetupDraftView()
//                    .onAppear {
//
//                        if UserDefaults.isCurrentlyInDraft {
//                            model.navPathForDrafting = [.setUpGeneral, .setUpTeams, .main]
//                        }
//                    }
//
//                    .navigationDestination(for: DraftPath.self) { thisView in
//                        switch thisView {
//                            case .setUpGeneral, .setUpTeams:
//                                SetUpDraftTeamsView()
//                            case .main:
//                                DraftView()
//                        case .teamSummary:
//                            DraftSummaryView()
//                        }
//                    }
//            }
//            .navigationBarTitleDisplayMode(.inline)
//            .tag(1)
//            .tabItem {
//                Label("Draft", systemImage: "square.and.arrow.down")
//            }
//
//
//            NavigationView {
//                SettingsView()
//            }
//            .navigationBarTitleDisplayMode(.inline)
//            .tag(2)
//            .tabItem {
//                Label("Settings", systemImage: "gear")
//            }
        }
        .onAppear {
//            print(batters)
            for starter in AllExtendedPitchers.starters(for: .depthCharts, limit: 2) {
                print(starter)
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
