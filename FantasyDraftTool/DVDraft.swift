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
    @State private var projectionSelected: ProjectionTypes = .steamer
    @State private var positionSelected: Position? = nil
    @State private var sortOptionSelected: NVSortByDropDown.Options = .score

    @State private var amountShowingAvailable: Int = 10

    var draft: Draft { model.draft }

    func availableBatters() -> [ParsedBatter] {
        draft.playerPool.storedBatters.batters(for: projectionSelected)
    }

    var body: some View {
        ScrollView {
            VStack {
                Text(["Round", model.draft.roundNumber.str + ", ", "Pick", model.draft.roundPickNumber.str])
                    .font(size: 28, color: .white, weight: .bold)

                VStack(alignment: .leading) {
                    Text("Available Players")
                        .font(size: 20, color: .white, weight: .medium)
                        .padding(.leading, 7)
                    HStack {
                        NVDropDownProjection(selection: $projectionSelected)
                        NVDropDownPosition(selection: $positionSelected)
                        NVSortByDropDown(selection: $sortOptionSelected)
                    }
                    .padding([.leading])
                    
                    LazyVStack {
                        ForEach(availableBatters(), id: \.self) { batter in

                            Button {
                                model.navPathForDrafting.append(batter)

                            } label: {
                                DVAllPlayersRow(player: batter)
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal)
                        }
                    }

                }
                
                .frame(maxWidth: .infinity)

                
            }
            
        }
        .frame(maxWidth: .infinity)
        .navigationBarTitleDisplayMode(.inline)
        .background {
            Color.hexStringToColor(hex: "33434F")
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
