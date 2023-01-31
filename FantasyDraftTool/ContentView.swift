//
//  ContentView.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/28/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        TabView {
            
            NavigationView {
                AllBattersListView()
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tag(0)
            .tabItem {
                Label("List", systemImage: "list")
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
