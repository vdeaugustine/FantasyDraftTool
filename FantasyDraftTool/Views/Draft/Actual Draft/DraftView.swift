//
//  DraftView.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/28/23.
//

import SwiftUI

// MARK: - DraftView

struct DraftView: View {
    @StateObject var draft: Draft
    
//    @State private var currentTeam: DraftTeam = DraftTeam(name: "", draftPosition: 1)

//    var remainingC: [ParsedBatter] { playerPool.filter { $0.positions.contains(.c) }
//    }
//
//    var remaining1B: [ParsedBatter] { playerPool.filter { $0.positions.contains(.first) }
//    }
//
//    var remaining2B: [ParsedBatter] { playerPool.filter { $0.positions.contains(.second) }
//    }
//
//    var remaining3B: [ParsedBatter] { playerPool.filter { $0.positions.contains(.third) }
//    }
//
//    var remainingSS: [ParsedBatter] { playerPool.filter { $0.positions.contains(.ss) }
//    }
//
//    var remainingOF: [ParsedBatter] { playerPool.filter { $0.positions.contains(.of) }
//    }

//    var dict: [Positions: [ParsedBatter]] {
//        var retDict: [Positions: [ParsedBatter]] = [:]
//        for position in Positions.batters {
//            let values: [ParsedBatter]
//            switch position {
//                case .c:
//                    values = remainingC
//                case .first:
//                    values = remaining1B
//                case .second:
//                    values = remaining2B
//                case .third:
//                    values = remaining3B
//                case .ss:
//                    values = remainingSS
//                case .of:
//                    values = remainingOF
//                default:
//                    values = []
//            }
//            retDict[position] = values
//        }
//        return retDict
//    }

    var sortedBatters: [ParsedBatter] {
        draft.playerPool.batters.sorted {
            $0.weightedFantasyPoints(dict: draft.playerPool.positionAveragesDict) > $1.weightedFantasyPoints(dict: draft.playerPool.positionAveragesDict)
        }

//        draft.playerPool.batters.sorted(by: { $0.weightedFantasyPoints(positionAverage: draft.playerPool.positionAveragesDict[$0.positions.first!]!) >
//                $1.weightedFantasyPoints(positionAverage: draft.playerPool.positionAveragesDict[$1.positions.first!]!)
//        })
    }

    var body: some View {
        List {
            Text("Current team: \(draft.currentTeam.name)")
            Text("Round \(draft.roundNumber), Pick \(draft.roundPickNumber)")

            Section("Recent picks") {
                if draft.pickStack.isEmpty() == false {
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(draft.pickStack.array, id: \.self) { pick in
                                Text("\(pick.team.name): \(pick.player.name),")
                            }
                        }
                    }
                }

                NavigationLink("Show all") {
                    DraftSummaryView(players: draft.pickStack, draft: draft)
                }
            }

            Section("Averages for remaining by position") {
                LazyVGrid(columns: (0 ... 2).map { _ in
                    GridItem(.flexible())
                }) {
                    ForEach(Positions.batters, id: \.self) { position in
                        if let positionAverage = draft.playerPool.positionAveragesDict[position] {
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
                            .spacedOut(text: batter.weightedFantasyPoints(dict: draft.playerPool.positionAveragesDict).str)
                    }
                }
            }
        }
        .onAppear {
            draft.currentTeam = draft.teams.first!
        }
    }

    func makePick(player: ParsedBatter) {
        let draftPlayer = DraftPlayer(player: player,
                                      pickNumber: draft.totalPickNumber,
                                      team: draft.currentTeam)
        draft.removeFromPool(player: draftPlayer)
        draft.pickStack.push(draftPlayer)
        draft.totalPickNumber += 1
        setNextTeam()
    }

    func setNextTeam() {
        let numberOfTeams = draft.settings.numberOfTeams

        let currentTeamIndex: Int = draft.roundNumber.isEven ? draft.settings.numberOfTeams - draft.roundPickNumber : draft.roundPickNumber - 1
        draft.currentTeam = draft.teams[currentTeamIndex]
    }
}

// MARK: - DraftView_Previews

struct DraftView_Previews: PreviewProvider {
    static var previews: some View {
        DraftView(draft: .init(teams: (0 ..< 10).map {
            DraftTeam(name: "Team \($0 + 1)",
                      draftPosition: $0)
        }, currentPickNumber: 1, settings: .init(numberOfTeams: 10,
                                                 snakeDraft: true,
                                                 numberOfRounds: 25,
                                                 scoringSystem: .defaultPoints))
        )
        .putInNavView()
    }
}
