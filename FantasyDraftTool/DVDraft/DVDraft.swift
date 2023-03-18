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
    @State private var doneLoading = false
    @State private var startLoadingDraft = false
    @State private var startUpdatePlayers = Date.now
    @State private var psuedoLoadProgress: Double = 0
    
    @State private var showDraftConfirmation = false
    
    @State private var playerForCard: ParsedPlayer? = nil

    var draft: Draft { model.draft }

//    func availableBatters() -> [ParsedBatter] {
//        draft.playerPool.storedBatters.batters(for: projectionSelected)
//    }

    func availablePlayers(completion: @escaping ([ParsedPlayer]) -> Void) {
        DispatchQueue.global().async {
            print("Start AVailable Players")

            let x = Date.now
            draft.playerPool.allStoredPlayers(projection: projectionSelected,
                                              scoring: draft.settings.scoringSystem,
                                              batterLimit: viewModel.amountOfAvailablePlayersToShow,
                                              pitcherLimit: viewModel.amountOfAvailablePlayersToShow,
                                              sort: false) { returnedPlayers in

                print("Start sorting")
                let sorted = returnedPlayers.sorted(by: { $0.wPointsZScore(draft: draft) > $1.wPointsZScore(draft: draft) })

                let trimmed = sorted.prefixArray(viewModel.amountOfAvailablePlayersToShow)

                psuedoLoadProgress += 0.2
                DispatchQueue.main.async {
                    viewModel.showSpinnerForPlayers = false
                    viewModel.availablePlayers = trimmed
                    psuedoLoadProgress += 0.9
                }

                print("Done with available players", Date.now - x)

                completion(trimmed)
//                print("Update players done", Date.now - startUpdatePlayers)
            }
        }
    }

    func updatePlayers() {
        startUpdatePlayers = .now
        availablePlayers { returnedPlayers in
            DispatchQueue.main.async {
                viewModel.availablePlayers = returnedPlayers
                viewModel.showSpinnerForPlayers = false
                doneLoading = true
            }
        }
    }

    var body: some View {
        ZStack {
            if doneLoading {
                ZStack {
                    ScrollView {
                        VStack {
                            Text(["Round", model.draft.roundNumber.str + ", ", "Pick", model.draft.roundPickNumber.str])
                                .font(size: 28, color: .white, weight: .bold)

                            HStack {
                                if let firstPick = draft.pickStack.getArray().first {
                                    BoxForPastPicksDVDraft(draftPlayer: firstPick)
                                }

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
//                                                        if let batter = player as? ParsedBatter {
//                                                            model.navPathForDrafting.append(batter)
//                                                        }
                                                        playerForCard = player

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
                                            .background(color: MainModel.shared.specificColor.nice, padding: 10)
                                    }
                                }
                            }

                            .frame(maxWidth: .infinity)
                        }
                    }
                    .blur(radius: playerForCard == nil ? 0 : 10 )
                    .disabled(playerForCard != nil)
                    
                    if let playerForCard = playerForCard {
                        DVSmallPlayerCard(playerForCard: $playerForCard, player: playerForCard, showDraftConfirmation: $showDraftConfirmation)
                            .padding(.horizontal)
                    }
                }
                .onAppear {
                    print("Showing draft: ", Date.now - startUpdatePlayers)
                }
            }

            if doneLoading == false {
                ZStack {
                    MainModel.shared.specificColor.background

                    VStack(spacing: 10) {
                        ProgressView("Loading Draft")
                        Text("This should take about 5-10 seconds")
                    }
                }
                .onAppear {
                    DispatchQueue.global().async {
                        updatePlayers()
                    }
                }
            }
        }
        .environmentObject(viewModel)
        .frame(maxWidth: .infinity)
        .navigationBarTitleDisplayMode(.inline)
        .background {
            MainModel.shared.specificColor.background
                .ignoresSafeArea()
        }
        .navigationDestination(for: ParsedBatter.self) { batter in
            DVBatterDetailDraft(draftPlayer: .init(player: batter, draft: model.draft))
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
