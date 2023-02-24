//
//  NVPicksSection.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/24/23.
//

import SwiftUI

// MARK: - NVPicksSection

struct NVPicksSection: View {
    let draft = Draft.exampleDraft(picksMade: 25, model: MainModel.shared, projection: .atc)

    @State private var pickOne = DraftPlayer(player: AllParsedBatters.steamer.of.sortedByPoints[3], pickNumber: 1, team: .init(name: "Vinnie", draftPosition: 1), weightedScore: 2.5)

    @State private var pickTwo = DraftPlayer(player: AllParsedBatters.steamer.of.sortedByPoints[2], pickNumber: 2, team: .init(name: "Brian", draftPosition: 2), weightedScore: 2.1)

    @State var projection: ProjectionTypes = .steamer
    let pastColor = Color.red.opacity(0.1)
    let predictionColor = Color.blue.opacity(0.1)
    @State private var previousViewingIndex: Int = 0

    @State var thirdPick: DraftPlayer? = nil

    var body: some View {
        GeometryReader { geo in
            VStack {
                // MARK: - Legend

                HStack {
                    HStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(pastColor)
                            .frame(width: 10)
                        Text("Previous")
                    }
                    HStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(predictionColor)
                            .frame(width: 10)
                        Text("Predictions")
                    }
                }.height(10).font(.caption2)

                HStack(spacing: 0) {
                    // MARK: - Past Section

                    ZStack {
                        pastColor
                        VStack(alignment: .leading) {
                            VStack(alignment: .leading) {
                                ScrollViewReader { value in
                                    HStack {
                                        ScrollView(.horizontal) {
                                            LazyHStack {
                                                ForEach(draft.pickStack.getArray().reversed(), id: \.self) { pick in
                                                    NVPreviousPickRect(player: pick)
                                                        .id(pick)
                                                }
                                            }
                                        }
                                    }
                                    .onAppear {
                                        if let last = draft.pickStack.getArray().reversed().last {
                                            value.scrollTo(last, anchor: .trailing)
                                        }
                                    }
                                }

                            }.padding(.horizontal)

                            NavigationLink {
                            } label: {
                                Text("Draft Summary")
                                    .font(.caption2)
                            }
                            .padding(.leading)
                        }
                    }

                    .frame(width: geo.size.width / 10 * 4)

                    // MARK: - Predictions Section

                    ZStack {
                        predictionColor

                        HStack {
                            NVPreviousPickRect(player: pickTwo)
                            if let pickThree = thirdPick {
                                NVPreviousPickRect(player: pickThree)
                            }

                            NavigationLink {
                            } label: {
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                            }
                        }

                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .height(170)
        .onAppear {
            if let first = draft.pickStack.getArray().first {
                pickOne = first
            }

            if let recommended = draft.currentTeam.recommendedPlayer(draft: draft, projection: .steamer) {
                pickTwo = DraftPlayer(player: recommended, pickNumber: draft.totalPickNumber, team: draft.currentTeam, weightedScore: recommended.zScore(draft: draft))
            }

            previousViewingIndex = draft.currentPickNumber

            previousViewingIndex = draft.pickStack.getArray().count - 1

            DispatchQueue.global().async {
                draft.simulatePicks(1, projection: projection) { retDraft in
                    thirdPick = retDraft.pickStack.getArray().first
                }
            }
        }
    }
}

// MARK: - NVPicksSection_Previews

struct NVPicksSection_Previews: PreviewProvider {
    static var previews: some View {
        NVPicksSection()
    }
}
