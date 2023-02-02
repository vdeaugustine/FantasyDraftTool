//
//  ContentView.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/28/23.
//

import SwiftUI

// MARK: - ContentView

struct ContentView: View {
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

            NavigationView {
                SetupDraftView()
                    .navigationBarTitleDisplayMode(.inline)
            }
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
    }
}
