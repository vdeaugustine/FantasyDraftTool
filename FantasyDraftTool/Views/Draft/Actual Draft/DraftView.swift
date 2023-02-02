//
//  DraftView.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/28/23.
//

import SwiftUI

// MARK: - model.draftView

struct DraftView: View {
    @EnvironmentObject private var model: MainModel

    var sortedBatters: [ParsedBatter] {
        model.draft.playerPool.batters.sorted {
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
                                Text("\(pick.team.name): \(pick.player.name),")
                            }
                        }
                    }
                }

                NavigationLink("Show all") {
                    DraftSummaryView()
                }
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
        
    }

    func makePick(player: ParsedBatter) {
        
        let draftPlayer = DraftPlayer(player: player,
                                      pickNumber: model.draft.totalPickNumber,
                                      team: model.draft.currentTeam, weightedScore: player.weightedFantasyPoints(dict: model.draft.playerPool.positionAveragesDict))
        model.draft.removeFromPool(player: draftPlayer)
        model.draft.pickStack.push(draftPlayer)
        model.draft.totalPickNumber += 1

        print(draftPlayer.id)
        print("Pool contains: \(model.draft.playerPool.batters.count) players")

        setNextTeam()
        model.save()
        
        
    }

    func setNextTeam() {
        let currentTeamIndex: Int = model.draft.roundNumber.isEven ? model.draft.settings.numberOfTeams - model.draft.roundPickNumber : model.draft.roundPickNumber - 1
        model.draft.currentTeam = model.draft.teams[currentTeamIndex]
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
