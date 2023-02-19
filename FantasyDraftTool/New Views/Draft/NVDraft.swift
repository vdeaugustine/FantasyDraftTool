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
    @State private var positionSelected: Position? = nil

    @State private var showMyTeamQuickView = false

    @State private var showPlayerSheet = false

    @State private var batterForDetail: ParsedBatter? = nil
    
    @State private var numPicksToSim: Int = 5

    var filteredPlayers: [ParsedBatter] {
        if let positionSelected = positionSelected {
            return model.draft.playerPool.batters(for: [positionSelected])
                .filter {
                    $0.positions.contains(positionSelected)
                }
        }

        return model.draft.playerPool.batters
    }

    var sortedPlayers: [ParsedBatter] {
        switch sortOptionSelected {
            case .points:
                return filteredPlayers.sorted { $0.fantasyPoints(model.scoringSettings) > $1.fantasyPoints(model.scoringSettings) }
            case .score:
                return filteredPlayers.sorted { $0.zScore(draft: model.draft) > $1.zScore(draft: model.draft) }
            case .hr:
                return filteredPlayers.sorted { $0.hr > $1.hr }
            case .rbi:
                return filteredPlayers.sorted { $0.rbi > $1.rbi }
            case .r:
                return filteredPlayers.sorted { $0.r > $1.r }
            case .sb:
                return filteredPlayers.sorted { $0.sb > $1.sb }
        }
    }

    var body: some View {
        List {
            HStack {
                if let prevPick = model.draft.pickStack.top() {
                    NVPreviousPickRect(player: prevPick)
                }
                NVCurrentPickRect(draft: model.draft)

                NavigationLink("All Picks") {
                    List {
                        ForEach(model.draft.pickStack.getArray(), id: \.self) { pick in
                            Text(pick)
                        }
                    }
                }
            }
            .listRowSeparator(.hidden)
            .listSectionSeparator(.hidden)
            .frame(maxWidth: .infinity)
            
            
            Section("Sim picks") {
                Stepper("Num picks \(numPicksToSim)", value: $numPicksToSim)
                Button("Sim") {
                    model.draft.simulatePicks(numPicksToSim)
                }
            }
            

            if let myTeam = model.draft.myTeam,
               let recommended = myTeam.recommendedPlayer(draft: model.draft) {
                VStack {
                    Text("Recommended")

                    GroupBox(recommended.name) {
                        VStack(alignment: .leading) {
                            ForEach(myTeam.positionsNotMetMinimum().corOrder, id: \.self) { pos in

                                HStack {
                                    Text(pos.str.uppercased())

                                    if let first = myTeam.recommendedBattersDesc(draft: model.draft).filter(for: pos).first {
                                        Text(first.name)
                                        Text(first.zScore(draft: model.draft).roundTo(places: 2).str)
                                        Text(first.fantasyPoints(model.draft.settings.scoringSystem))
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Button("My team") {
                showMyTeamQuickView.toggle()
            }

            // MARK: - Available Players

            Section("Available Players") {
                HStack {
                    NVDropDownProjection(selection: $model.draft.projectionCurrentlyUsing)
                    NVSortByDropDown(selection: $sortOptionSelected)
                    NVDropDownPosition(selection: $positionSelected)
                }
            }

            ForEach(sortedPlayers, id: \.self) { batter in

                NavigationLink {
                    NVDraftPlayerDetail(batter: batter)

                } label: {
                    NVAllPlayersRow(batter: batter)
                }
                .buttonStyle(.plain)
                .onTapGesture(count: 2) {
                    model.draft.makePick(batter)
                }
            }
        }

        // MARK: - Start of main modifiers

        .listStyle(.plain)
        .navigationTitle("Round \(model.draft.roundNumber)")
//        .onAppear {
//            model.draft = .exampleDraft()
//        }
        .sheet(isPresented: $showMyTeamQuickView) {
            NVMyTeamQuickView()
                .putInNavView(displayMode: .inline)
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
