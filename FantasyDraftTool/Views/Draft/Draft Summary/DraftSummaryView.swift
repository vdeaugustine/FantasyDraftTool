//
//  DraftSummaryView.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/29/23.
//

import SwiftUI

struct DraftSummaryView: View {
    
    let players: Stack<DraftPlayer>
    let draft: Draft
    @State private var showingTeam: DraftTeam = .init(name: "NULL", draftPosition: 0)
    
    var showingPlayers: [DraftPlayer] {
        return draft.pickStack.array
//        var showing: [DraftPlayer] = players.array.filter({ $0.team == showingTeam })
//        if selectedPositions.isEmpty {
//            return showing
//        }
//
//        return showing.filter({
//            for position in selectedPositions {
//                if $0.player.positions.contains(position) {
//                    return true
//                }
//            }
//            return false
//        })
        
        
    }
    @State private var selectedPositions: Set<Positions> = []
    
    var body: some View {
        VStack {
            Picker("Team", selection: $showingTeam) {
                ForEach(draft.teams, id: \.self) { team in
                    Text(team.name)
                        .tag(team.name)
                }
            }
            
            SelectPositionsHScroll(selectedPositions: $selectedPositions)
            
            List {
                
                
                
                Section {
                    ForEach(showingPlayers, id: \.self) { player in
                        Text(player.player.name)
                    }
                }
                
                Section {
                    ForEach(players.array, id: \.self) { player in
                        Text(player.team.name + ":" + player.player.name)
                        
                    }
                }
            }
        }
        .onAppear {
            showingTeam = draft.teams[0]
        }
    }
}

struct DraftSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        DraftSummaryView(players: .init(), draft: .init(teams: (0 ..< 10).map {
            DraftTeam(name: "Team \($0 + 1)",
                      draftPosition: $0)
        }, currentPickNumber: 1, settings: .init(numberOfTeams: 10,
                                                 snakeDraft: true,
                                                 numberOfRounds: 25,
                                                 scoringSystem: .defaultPoints)))
    }
}
