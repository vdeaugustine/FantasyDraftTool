//
//  DVDraft.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/9/23.
//

import SwiftUI

// MARK: - DVDraft

struct DVDraft: View {
    @EnvironmentObject private var model: MainModel
    @StateObject private var viewModel: DVDraftViewModel = .init()
    @State private var projectionSelected: ProjectionTypes = .steamer
    @State private var positionSelected: Position? = nil
    @State private var sortOptionSelected: NVSortByDropDown.Options = .score

    var draft: Draft { model.draft }

    func availableBatters() -> [ParsedBatter] {
        draft.playerPool.storedBatters.batters(for: projectionSelected)
    }
    
    func availablePlayers(completion: @escaping ([ParsedPlayer]) -> ()) {
        DispatchQueue.global().async {
//            let batters = draft.playerPool.storedBatters.batters(for: projectionSelected)
//            let pitchers = draft.playerPool.storedPitchers.pitchers(for: projectionSelected)
            draft.playerPool.allStoredPlayers(projection: projectionSelected, scoring: draft.settings.scoringSystem, batterLimit: viewModel.amountOfAvailablePlayersToShow, pitcherLimit: viewModel.amountOfAvailablePlayersToShow, sort: false) { returnedPlayers in
                
                
                let sorted = returnedPlayers.sorted(by: {$0.wPointsZScore(draft: draft) > $1.wPointsZScore(draft: draft)})
                
                let trimmed = sorted.prefixArray(viewModel.amountOfAvailablePlayersToShow)
                
                
                DispatchQueue.main.async {
                    viewModel.showSpinnerForPlayers = false
                    viewModel.availablePlayers = trimmed
                }
                
                completion(trimmed)
                
                
            }
        }
    }
    
    func updatePlayers() {
        availablePlayers { returnedPlayers in
            DispatchQueue.main.async {
                viewModel.availablePlayers = returnedPlayers
                viewModel.showSpinnerForPlayers = false
            }
        }
    }

    var body: some View {
        ScrollView {
            VStack {
                Text(["Round", model.draft.roundNumber.str + ", ", "Pick", model.draft.roundPickNumber.str])
                    .font(size: 28, color: .white, weight: .bold)

                HStack {
                    BoxForPastPicksDVDraft(draftPlayer: draft.pickStack.getArray().first!)
                    BoxForCurrentPickDVDraft()
                }.padding(.vertical)

                DVDraftRankings(projection: $model.draft.projectionCurrentlyUsing)
                    .padding(.horizontal, 7)

                
                if let myTeam = draft.myTeam {
                    PositionsFilledSection(myTeam: myTeam)
                        .padding(.vertical)
                        .padding(.horizontal, 7)
                }
                
                
                VStack(alignment: .leading) {
                    Text("Available Players")
                        .font(size: 20, color: .white, weight: .medium)
                        .padding(.leading, 7)
                    HStack {
                        NVDropDownProjection(selection: $projectionSelected, font: viewModel.dropDownFont)
                            .onChange(of: projectionSelected) { newValue in
                                updatePlayers()
                                model.draft.projectionCurrentlyUsing = newValue
                            }
                        NVDropDownPosition(selection: $positionSelected, font: viewModel.dropDownFont)
                        NVSortByDropDown(selection: $sortOptionSelected, font: viewModel.dropDownFont)
                    }
                    .padding([.leading])

                    
                    
                    
                    // MARK: - Available Players
                    VStack {
                        ZStack {
                            LazyVStack {
                                ForEach(viewModel.availablePlayers.indices, id: \.self) { playerInd in

                                    if let player = viewModel.availablePlayers.safeGet(at: playerInd) {
                                     
                                            Button {
                                                if let batter = player as? ParsedBatter {
                                                    model.navPathForDrafting.append(batter)
                                                }
                                                

                                            } label: {
                                                DVAllPlayersRow(player: player)
                                            }
                                            .buttonStyle(.plain)
                                            .padding(.horizontal)
                                     }
                                    
                                }
                            }
                            
                            if viewModel.showSpinnerForPlayers {
                                ProgressView()
                            }
                        }
                        
                        Button {
                            viewModel.showSpinnerForPlayers = true
                            viewModel.amountOfAvailablePlayersToShow += 10
                            updatePlayers()
                        } label: {
                            Label("Show more", systemImage: "plus")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                                .background(color: .niceBlue, padding: 10)
                        }
                        
                    }
                }

                .frame(maxWidth: .infinity)
            }
        }
        .environmentObject(viewModel)
        .frame(maxWidth: .infinity)
        .navigationBarTitleDisplayMode(.inline)
        .background {
            Color.hexStringToColor(hex: "33434F")
                .ignoresSafeArea()
        }
        .navigationDestination(for: ParsedBatter.self) { batter in
            DVBatterDetailDraft(draftPlayer: .init(player: batter, draft: model.draft))
        }
        .onAppear {
            updatePlayers()
        }
        
        
    }
}

// MARK: - DVDraft_Previews

struct DVDraft_Previews: PreviewProvider {
    static var previews: some View {
        DVDraft()
            .environmentObject(MainModel.shared)
    }
}
