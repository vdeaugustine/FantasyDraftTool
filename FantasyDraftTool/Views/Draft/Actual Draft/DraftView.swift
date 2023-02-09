//
//  DraftView.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/28/23.
//

import Charts
import SwiftUI

// MARK: - DraftView

struct DraftView: View {
    @EnvironmentObject private var model: MainModel

    var sortedBatters: [ParsedBatter] {
        model.draft.playerPool.batters.removingDuplicates().sorted {
            $0.weightedFantasyPoints(dict: model.draft.playerPool.positionAveragesDict) > $1.weightedFantasyPoints(dict: model.draft.playerPool.positionAveragesDict)
        }
    }

    var allPicksDone: Bool {
        model.draft.roundNumber >= model.draft.settings.numberOfRounds
    }


    var body: some View {
        List {
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

            if let myTeam = model.draft.myTeam {
                Section("My team") {
                    ForEach(Position.batters, id: \.self) { position in
                        VStack {
                            Text(position.str.uppercased())
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(myTeam.players(for: position), id: \.self) { batter in
                                        Text(batter.player.name)
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Section {
                Text("Current pick index \(model.draft.currentIndex)")
                Text("Previous team index: \(model.draft.previousIndex)")
                Text("My Team index: \(model.draft.myTeamIndex)")
                Text("My Team name: \(model.draft.myTeam?.name ?? "")")
                Text("Current team: \(model.draft.currentTeam.name)")
                Text("Round \(model.draft.roundNumber), Pick \(model.draft.roundPickNumber)")
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
        .conditionalModifier(model.draft.totalPickNumber >= (model.draft.settings.numberOfTeams * model.draft.settings.numberOfRounds)) { selfView in
            selfView
                .disabled(true)
                .blur(radius: 10)
                .overlay {
                    Button("Restart draft") {
                        model.resetDraft()
                    }
                }
                
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        model.draft.undoPick()
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

// MARK: - TeamsChart

struct TeamsChart: View {
    var label: String? = nil
    @Binding var data: [DraftTeam]
    var body: some View {
        Chart {
            ForEach(data, id: \.self) { thisTeam in
                BarMark(x: .value("Points", thisTeam.averagePoints()), y: .value("Team Name", thisTeam.name))
            }
        }
        .chartXAxis {
            AxisMarks(position: .bottom) { _ in
                // AxisGridLine().foregroundStyle(.clear)
                AxisTick().foregroundStyle(.clear)
                AxisValueLabel()
            }
        }
        .chartYAxis {
            AxisMarks(position: .automatic) { _ in
                // AxisGridLine().foregroundStyle(.clear)
                AxisTick().foregroundStyle(.clear)
                AxisValueLabel()
            }
        }
        .height(250)
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
