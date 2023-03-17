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
//    @State private var draft: Draft? = .loadExample()
    @State private var progress: Double = 0
    @State private var showDropDown = false
//    var body: some View {
//        NVDraftPlayerDetail(batter: MainModel.shared.draft.playerPool.batters(for: [.of], projection: .steamer).first!)
//    }
    var body: some View {
        




        TabView(selection: $selectedTab) {
//            NavigationView {
//                NVAllPlayers()
//            }
//            .tag(0)
//            .tabItem {
//                Label("List", systemImage: "list.bullet")
//            }
//            .navigationBarTitleDisplayMode(.inline)

            NavigationStack(path: $model.navPathForDrafting) {
                
                DVSetUpLeagueView()
                    .navigationDestination(for: ParsedBatter.self) { batter in
                        DVBatterDetailDraft(draftPlayer: .init(player: batter, draft: model.draft))
                    }
//                DVDraft()
//                    .onAppear {
//                        model.draftLoadProgress = 0
//                    }
            }
            .navigationDestination(for: ParsedBatter.self) { batter in
                DVBatterDetailDraft(draftPlayer: .init(player: batter, draft: model.draft))
            }
            .tag(1)
            .tabItem {
                Label("Draft", systemImage: "list.bullet")
            }
            .navigationBarTitleDisplayMode(.inline)

            NavigationView {
                DVTradeAnalysisSetup()
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
    }
}

// MARK: - ContentView_Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(MainModel.shared)
    }
}
