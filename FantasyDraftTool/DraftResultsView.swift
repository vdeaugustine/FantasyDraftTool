//
//  DraftResultsView.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/19/23.
//

import SwiftUI

// MARK: - DraftResultsView

struct DraftResultsView: View {
    @EnvironmentObject private var model: MainModel

    let draftResults: DraftResults

    @State private var isLoading = true
    @State private var reachedPlayers: [DraftPlayer] = []

    func rect(@ViewBuilder content: () -> some View) -> some View {
        content()
            .frame(height: 215)
            .background(color: model.specificColor.rect, padding: 10)
    }

    @State private var roundToShow: Int = 1

    private var currentRound: [DraftPlayer] {
        draftResults.pickStack.getArray().filter {
            draftResults.getRoundNumber(for: $0.pickNumber) == roundToShow
        }
    }
    
    var range: Range<Int> {
        (1 ..< draftResults.numberOfRounds + 1)
    }
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    Text("Picks")
                        .font(size: 20, color: .white, weight: .medium)
                        .spacedOut {
                            Picker("Round", selection: $roundToShow) {
                                ForEach(range, id: \.self) { round in
                                    Text("Round \(round)")
                                        .tag(round)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                    rect {
                        List {
                            ForEach(currentRound) { player in
                                VStack(alignment: .leading, spacing: 7) {
                                    if let team = draftResults.team(for: player) {
                                        Text(team.name)
                                            .font(size: 14, color: .white, weight: .semibold)
                                    }
                                    Text(player.player.name)
                                        .font(size: 12, color: .white, weight: .light)

                                    HStack {
                                        HStack(spacing: 2) {
                                            Text("ADP: ")
                                                .font(size: 12, color: .white, weight: .semibold)
                                            Text(player.player.getSomeADP().simpleStr())
                                                .font(size: 12, color: .white, weight: .regular)
                                        }
                                        HStack(spacing: 2) {
                                            Text("Pick: ")
                                                .font(size: 12, color: .white, weight: .semibold)
                                            Text(player.pickNumber.str)
                                                .font(size: 12, color: .white, weight: .regular)
                                        }
                                        HStack(spacing: 2) {
                                            Text("Reach: ")
                                                .font(size: 12, color: .white, weight: .semibold)
                                            Text(player.reach.simpleStr())
                                                .font(size: 12, color: .white, weight: .regular)
                                        }
                                    }
                                }
                                .listRowBackground(MainModel.shared.specificColor.rect)
                            }
                        }
                        .listStyle(.plain)
                    }
                }

                VStack {
                    Text("Biggest Reaches")
                        .font(size: 20, color: .white, weight: .medium)
                        .pushLeft()
                    rect {
                        if isLoading {
                            ProgressView()
                        } else {
                            List {
                                ForEach(reachedPlayers.prefixArray(20)) { player in
                                    VStack(alignment: .leading, spacing: 7) {
                                        if let team = draftResults.team(for: player) {
                                            Text(team.name)
                                                .font(size: 14, color: .white, weight: .semibold)
                                        }
                                        Text(player.player.name)
                                            .font(size: 12, color: .white, weight: .light)

                                        HStack {
                                            HStack(spacing: 2) {
                                                Text("ADP: ")
                                                    .font(size: 12, color: .white, weight: .semibold)
                                                Text(player.player.getSomeADP().simpleStr())
                                                    .font(size: 12, color: .white, weight: .regular)
                                            }
                                            HStack(spacing: 2) {
                                                Text("Pick: ")
                                                    .font(size: 12, color: .white, weight: .semibold)
                                                Text(player.pickNumber.str)
                                                    .font(size: 12, color: .white, weight: .regular)
                                            }
                                            HStack(spacing: 2) {
                                                Text("Reach: ")
                                                    .font(size: 12, color: .white, weight: .semibold)
                                                Text(player.reach.simpleStr())
                                                    .font(size: 12, color: .white, weight: .regular)
                                            }
                                        }
                                    }
                                    .listRowBackground(MainModel.shared.specificColor.rect)
                                }
                            }
                            .listStyle(.plain)
                        }
                    }
                }

                VStack {
                    Text("Best Value")
                        .font(size: 20, color: .white, weight: .medium)
                        .pushLeft()
                    rect {
                        if isLoading {
                            ProgressView()
                        } else {
                            List {
                                ForEach(reachedPlayers.reversed().prefixArray(20)) { player in
                                    VStack(alignment: .leading, spacing: 7) {
                                        if let team = draftResults.team(for: player) {
                                            Text(team.name)
                                                .font(size: 14, color: .white, weight: .semibold)
                                        }
                                        Text(player.player.name)
                                            .font(size: 12, color: .white, weight: .light)

                                        HStack {
                                            HStack(spacing: 2) {
                                                Text("ADP: ")
                                                    .font(size: 12, color: .white, weight: .semibold)
                                                Text(player.player.getSomeADP().simpleStr())
                                                    .font(size: 12, color: .white, weight: .regular)
                                            }
                                            HStack(spacing: 2) {
                                                Text("Pick: ")
                                                    .font(size: 12, color: .white, weight: .semibold)
                                                Text(player.pickNumber.str)
                                                    .font(size: 12, color: .white, weight: .regular)
                                            }
                                            HStack(spacing: 2) {
                                                Text("Reach: ")
                                                    .font(size: 12, color: .white, weight: .semibold)
                                                Text(player.reach.simpleStr())
                                                    .font(size: 12, color: .white, weight: .regular)
                                            }
                                        }
                                    }
                                    .listRowBackground(MainModel.shared.specificColor.rect)
                                }
                            }
                            .listStyle(.plain)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .background {
            MainModel.shared.specificColor.background.ignoresSafeArea()
        }
        .navigationTitle("Draft Results")
        .onAppear {
            isLoading = true
            DraftAnalysis.reachesRanked(draftResults) { sortedArr in
                reachedPlayers = sortedArr
                isLoading = false
            }
        }
    }
}

// MARK: - DraftResultsView_Previews

struct DraftResultsView_Previews: PreviewProvider {
    static var previews: some View {
        DraftResultsView(draftResults: DraftResults(draft: .loadDraft()!))
            .environmentObject(MainModel.shared)
            .putInNavView()
            .onAppear {
                #if DEBUG
                    RunLoop.current.run(until: Date(timeIntervalSinceNow: 25))
                #endif
            }
    }
}
