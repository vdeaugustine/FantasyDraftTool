//
//  NVDraft.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/14/23.
//

import SwiftUI

// MARK: - NVDraft

struct NVDraft: View {
    @EnvironmentObject private var model: MainModel
    @State private var projection: ProjectionTypes = .steamer
    @State private var sortOptionSelected: NVSortByDropDown.Options = .score
    var body: some View {
        List {
            HStack {
                if let prevPick = model.draft.pickStack.top() {
                    NVPreviousPickRect(player: prevPick)
                }
                NVCurrentPickRect(draft: model.draft)
                
                NavigationLink("All Picks") {
                    List {
                        ForEach (model.draft.pickStack.getArray(), id: \.self) { pick in
                            Text(pick)
                        }
                    }
                }
            }
            .listRowSeparator(.hidden)
            .listSectionSeparator(.hidden)
            .frame(maxWidth: .infinity)
            
            
            // MARK: - Available Players
            
            Section("Available Players") {
                HStack {
                    NVDropDownProjection(selection: $projection)
                    NVSortByDropDown(selection: $sortOptionSelected)
                }
                
                if let recommended = model.draft.myTeam?.recommendedPlayer(draft: model.draft) {
                    VStack {
                        Text("Recommended")
                        
                        GroupBox(recommended.name) {
                            
                        }
                        
                        
                    }
                }
            }
            
            // MARK: - FOR TESTING
//            Section("Std Dev for remaining by position") {
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack {
//                        ForEach(model.draft.playerPool.positionsOrder, id: \.self) { position in
//                            if let positionAverage = model.draft.playerPool.standardDeviationDict[position] {
//                                StatRect(stat: position.str.uppercased(), value: positionAverage)
//                                    .frame(width: 50)
//                            }
//                        }
//                    }
//                }
//            }
//
//            Section {
//                ForEach(model.draft.pickStack.getArray(), id: \.self) { pick in
//                    Text("\(pick.pickNumber): \(pick.player.name) - \(pick.weightedScoreWhenDrafted)")
//                }
//            }
        }
        .listStyle(.plain)
        .navigationTitle("Round \(model.draft.roundNumber)")
        .onAppear {
            model.draft = .exampleDraft()
        }
    }
}

// MARK: - NVDraft_Previews

struct NVDraft_Previews: PreviewProvider {
    static var previews: some View {
        NVDraft()
            .putInNavView(displayMode: .inline)
            .environmentObject(MainModel.shared)
            
    }
}
