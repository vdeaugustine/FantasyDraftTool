//
//  DraftView.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/28/23.
//

import SwiftUI
import Charts

// MARK: - DraftView

struct DraftView: View {
    @EnvironmentObject private var model: MainModel

    var sortedBatters: [ParsedBatter] {
        model.draft.playerPool.batters.removingDuplicates().sorted {
            $0.weightedFantasyPoints(dict: model.draft.playerPool.positionAveragesDict) > $1.weightedFantasyPoints(dict: model.draft.playerPool.positionAveragesDict)
        }
        
    }

    var body: some View {
        List {
            Text("Current team: \(model.draft.currentTeam.name)")
            Text("Round \(model.draft.roundNumber), Pick \(model.draft.roundPickNumber)")

            Section("Recent picks") {
                if model.draft.pickStack.isEmpty() == false {
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(model.draft.pickStack.getArray(), id: \.self) { pick in
                                Text("\(pick.draftedTeam?.name ?? ""): \(pick.player.name),")
                            }
                        }
                    }
                }

                NavigationLink("Show all") {
                    DraftSummaryView()
                }
            }
            
            Section {
                TeamsChart(label: "Team Points", data: $model.draft.teams)
            }

            Section("Averages for remaining by position") {
                LazyVGrid(columns: (0 ... 2).map { _ in
                    GridItem(.flexible())
                }) {
                    ForEach(Position.batters, id: \.self) { position in
                        if let positionAverage = model.draft.playerPool.positionAveragesDict[position] {
                            StatRect(stat: position.str.uppercased(), value: positionAverage)
                        }
                    }
                }
            }

            Section {
                ForEach(sortedBatters,
                        id: \.self) { batter in
                    Button {
                        makePick(player: batter)
                    } label: {
                        Text(batter.name)
                            .spacedOut(text: batter.weightedFantasyPoints(dict: model.draft.playerPool.positionAveragesDict).str)
                    }
                }
            }
        }
        .onAppear {
            UserDefaults.isCurrentlyInDraft = true
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                    } label: {
                        HStack {
                            Image(systemName: "arrow.uturn.backward")
                            Text("Undo last pick")
                        }
                    }

                    Button(role: .destructive) {
                        model.resetDraft()
                    } label: {
                        Label("Restart draft", systemImage: "restart")
                    }
                    
                    Button {
                        
                    } label: {
                        Label("Sort", systemImage: "line.3.horizontal.decrease")
                    }

                } label: {
                    Label("more", systemImage: "ellipsis")
                }
            }
        }
    }

    func makePick(player: ParsedBatter) {
        let draftPlayer = DraftPlayer(player: player,
                                      pickNumber: model.draft.totalPickNumber,
                                      team: model.draft.currentTeam, weightedScore: player.weightedFantasyPoints(dict: model.draft.playerPool.positionAveragesDict))
        
        model.draft.makePick(draftPlayer)        
        model.save()
        
        print(draftPlayer.id)
        print("Pool contains: \(model.draft.playerPool.batters.count) players")

        
    }

    
    
}

struct TeamsChart: View {
    var label: String? = nil
    @Binding var data: [DraftTeam]
    var body: some View {
        Chart {
            ForEach(data, id: \.self) { thisTeam in
                BarMark(x: .value("Points", thisTeam.averagePoints()), y: .value("Team Name", thisTeam.name))
                
                    
            }
        }
    }
    
    
}

// MARK: - DraftView_Previews

struct DraftView_Previews: PreviewProvider {
    static var previews: some View {
        DraftView()
            .environmentObject(MainModel.shared)
            .putInNavView()
    }
}
