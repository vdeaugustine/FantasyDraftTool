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
    @State private var projection: ProjectionTypes = .atc
    @State private var sortOptionSelected: NVSortByDropDown.Options = .score
    @State private var positionSelected: Position? = nil
    @State private var showMyTeamQuickView = false
    @State private var showPlayerSheet = false
    @State private var batterForDetail: ParsedBatter? = nil
    @State private var numPicksToSim: Int = 50
    @State private var draftProgress: Double = -1
    @State private var loadingDone: Bool = true

    var filteredPlayers: [ParsedBatter] {
        // TODO: When switching
//        loadingDone = false
        if let positionSelected = positionSelected {
            return model.draft.playerPool.batters(for: [positionSelected], projection: projection, draft: model.draft)
        }

        return model.draft.playerPool.batters(for: Position.batters, projection: projection)
    }

    var sortedPlayers: [ParsedBatter] {
        let retArr: [ParsedBatter]
        switch sortOptionSelected {
            case .points:
                retArr = filteredPlayers.sorted { $0.fantasyPoints(model.scoringSettings) > $1.fantasyPoints(model.scoringSettings) }
            case .score:
                retArr = filteredPlayers.sorted { $0.zScore(draft: model.draft) > $1.zScore(draft: model.draft) }
            case .hr:
                retArr = filteredPlayers.sorted { $0.hr > $1.hr }
            case .rbi:
                retArr = filteredPlayers.sorted { $0.rbi > $1.rbi }
            case .r:
                retArr = filteredPlayers.sorted { $0.r > $1.r }
            case .sb:
                retArr = filteredPlayers.sorted { $0.sb > $1.sb }
        }

        return retArr
    }

    var body: some View {
        if draftProgress < 1,
           draftProgress >= 0 {
            LoadingDraft(progress: $draftProgress)
                .padding()
        } else if !loadingDone {
            Text("Loading")
        } else {
            if let myTeam = model.draft.myTeam {
                ScrollView {
                    VStack {
                        NVPicksSection()

                            HStack {
                                ForEach(Position.batters, id: \.self) { pos in

                                    LabelAndValueRect(label: pos.str.uppercased(), value: myTeam.players(for: pos).count.str, color: .white)
                                        
                                }
                            }
                            .height(60)
                            
                        

                        if let recommended = myTeam.recommendedPlayer(draft: model.draft, projection: projection) {
                            VStack {
                                VStack(alignment: .leading) {
                                    ForEach(myTeam.positionsNotMetMinimum().corOrder, id: \.self) { pos in

                                        HStack {
                                            Text(pos.str.uppercased())

                                            if let first = myTeam.recommendedBattersDesc(draft: model.draft, projection: projection).filter(for: pos).first {
                                                Text(first.name)
                                                Text(first.zScore(draft: model.draft).roundTo(places: 2).str)
                                                Text(first.fantasyPoints(model.draft.settings.scoringSystem))
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }
                        }

                        Button("My team") {
                            showMyTeamQuickView.toggle()
                        }
                        
                        

                        // MARK: - Available Players

                        HStack {
                            NVDropDownProjection(selection: $projection)
                            NVSortByDropDown(selection: $sortOptionSelected)
                            NVDropDownPosition(selection: $positionSelected)
                        }

                        LazyVStack {
                            ForEach(sortedPlayers, id: \.self) { batter in

                                Button {
                                    model.navPathForDrafting.append(batter)
                                } label: {
                                    NVAllPlayersRow(batter: batter)
                                        .padding(.horizontal)
                                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                            Button("Draft") {
                                                model.draft.makePick(batter)
                                            }
                                        }
                                }
                                .buttonStyle(.plain)

                                .background {
                                    Color.listBackground
                                        .cornerRadius(8)
                                        .shadow(radius: 0.7)
                                }
                                
                            }
                        }
                    }.padding()
                }

                // MARK: - Start of main modifiers

                .listStyle(.plain)
                .navigationTitle("Round \(model.draft.roundNumber)")
                .sheet(isPresented: $showMyTeamQuickView) {
                    NVMyTeamQuickView()
                        .putInNavView(displayMode: .inline)
                }
                .alert("Draft is over", isPresented: $model.draft.shouldEnd) {
                    Button("OK") {
                    }
                }
                .navigationDestination(for: ParsedBatter.self) { batter in
                    NVDraftPlayerDetail(batter: batter)
                }
            }
        }
    }
}

// MARK: - NVDraft_Previews

struct NVDraft_Previews: PreviewProvider {
    static var previews: some View {
        NVDraft()
            .environmentObject(MainModel.shared)
            .putInNavView(displayMode: .inline)
    }
}
