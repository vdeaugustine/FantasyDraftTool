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
    @State private var draft: Draft? = .loadExample()
    @State private var progress: Double = 0
//    var body: some View {
//        NVDraftPlayerDetail(batter: MainModel.shared.draft.playerPool.batters(for: [.of], projection: .steamer).first!)
//    }
    var body: some View {
        VStack {
            ProgressView("Draft", value: progress, total: 1)

            if let draft = draft {
                LazyVStack {
                    ForEach(draft.pickStack.getArray(), id: \.self) {
                        Text($0)
                    }
                }
                
                if draft.pickStack.getArray().count < 1 {
                    Text("NULL DRAFT")
                }
            }
            
            
        }
        .onAppear {
            if draft == nil {
                DispatchQueue.global().async {
                    Draft.asyncExampleDraft(picksMade: 200, proj: .atc, progress: &progress) { completedDraft in

                        draft = completedDraft

                        draft!.save()
                        
                    }
                }
            }
        }

//        BoxForPastPicksDVDraft(draftPlayer: .TroutOrNull)

//        TabView(selection: $selectedTab) {
//            NavigationView {
//                NVAllPlayers()
//            }
//            .tag(0)
//            .tabItem {
//                Label("List", systemImage: "list.bullet")
//            }
//            .navigationBarTitleDisplayMode(.inline)
//
//            NavigationStack(path: $model.navPathForDrafting) {
//                DVDraft()
//                    .onAppear {
//                        model.draftLoadProgress = 0
//                    }
//            }
//            .tag(1)
//            .tabItem {
//                Label("Draft", systemImage: "list.bullet")
//            }
//            .navigationBarTitleDisplayMode(.inline)
//
//            NavigationView {
//                NVSettings()
//            }
//            .tag(2)
//            .tabItem {
//                Label("Settings", systemImage: "gear")
//            }
//            .navigationBarTitleDisplayMode(.inline)
//
        ////
        ////            NavigationView {
        ////                AllBattersListView()
        ////                    .navigationBarTitleDisplayMode(.inline)
        ////            }
        ////            .tag(0)
        ////            .tabItem {
        ////                Label("List", systemImage: "list.bullet")
        ////            }
        ////
        ////            NavigationStack(path: $model.navPathForDrafting) {
        ////                SetupDraftView()
        ////                    .onAppear {
        ////
        ////                        if UserDefaults.isCurrentlyInDraft {
        ////                            model.navPathForDrafting = [.setUpGeneral, .setUpTeams, .main]
        ////                        }
        ////                    }
        ////
        ////                    .navigationDestination(for: DraftPath.self) { thisView in
        ////                        switch thisView {
        ////                            case .setUpGeneral, .setUpTeams:
        ////                                SetUpDraftTeamsView()
        ////                            case .main:
        ////                                DraftView()
        ////                        case .teamSummary:
        ////                            DraftSummaryView()
        ////                        }
        ////                    }
        ////            }
        ////            .navigationBarTitleDisplayMode(.inline)
        ////            .tag(1)
        ////            .tabItem {
        ////                Label("Draft", systemImage: "square.and.arrow.down")
        ////            }
        ////
        ////
        ////            NavigationView {
        ////                SettingsView()
        ////            }
        ////            .navigationBarTitleDisplayMode(.inline)
        ////            .tag(2)
        ////            .tabItem {
        ////                Label("Settings", systemImage: "gear")
        ////            }
//        }
    }
}

// MARK: - ContentView_Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(MainModel.shared)
    }
}
