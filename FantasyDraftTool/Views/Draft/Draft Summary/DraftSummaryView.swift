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
        players.array.filter({ $0.team == showingTeam })
    }
    
    var body: some View {
        VStack {
            Picker("Team", selection: $showingTeam) {
                ForEach(draft.teams, id: \.self) { team in
                    Text(team.name)
                        .tag(team.name)
                }
            }
            
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
