//
//  DVTradeAnalysisSetup.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/16/23.
//

import SwiftUI

// MARK: - PlayerBasicStatRow

struct PlayerBasicStatRow: View {
    let player: ParsedPlayer

    var hDivider: some View {
        Rectangle()
            .frame(width: 1, height: 20)
    }

    var body: some View {
        HStack {
            Text(player.name)
                .font(size: 16, color: .white, weight: .medium)
            Spacer()

            Text([player.fantasyPoints(.defaultPoints).simpleStr(), "pts"])
                .font(size: 12, color: .white, weight: .light)

            hDivider

            // Batter
            if let batter = player as? ParsedBatter {
                HStack {
                    Text([batter.avg.formatForBaseball(), "AVG"])
                    hDivider
                    Text([batter.hr.str, "HR"])
                    hDivider
                    Text([batter.rbi.str, "RBI"])
                }
                .font(size: 12, color: .white, weight: .light)
            }

            // Pitcher
        }
        .background(color: .niceGray, padding: 15)
    }
}

// MARK: - DVTradeAnalysisSetup

struct DVTradeAnalysisSetup: View {
    @State private var team1Sends: [ParsedPlayer] = []
    @State private var team2Sends: [ParsedPlayer] = []
    @State private var showSearchForTeam1 = false
    @State private var showSearchForTeam2 = true
    @State private var searchTextForTeam1 = ""
    @State private var searchTextForTeam2 = ""
    @State private var team1FilteredPlayers: [ParsedPlayer] = []
    @State private var team2FilteredPlayers: [ParsedPlayer] = []
    @State private var isSearching = false

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Text("Set Up Trade")
                    .font(size: 28, color: .white, weight: .bold)
                    .pushLeft()

                VStack {
                    Text("Team 1 Sends")
                        .font(size: 16, color: .lighterGray, weight: .medium)
                        .pushLeft()

                    PlayerBasicStatRow(player: ParsedBatter.TroutOrNull)

                    addPlayerButton
                }

                VStack {
                    Text("Team 2 Sends")
                        .font(size: 16, color: .lighterGray, weight: .medium)
                        .pushLeft()

                    PlayerBasicStatRow(player: ParsedBatter.TroutOrNull)

                    if showSearchForTeam2 {
                        VStack {
                            List {
                                Text("\(team2FilteredPlayers.count) players found")
                                    .foregroundColor(.white)

                                ForEach(team2FilteredPlayers.indices, id: \.self) { playerInd in

                                    if let batter = team2FilteredPlayers.safeGet(at: playerInd) as? ParsedBatter {
                                        Text([batter.name,
                                              batter.team, batter.posStr()].joined(separator: " • "))
                                    }

                                    if let pitcher = team2FilteredPlayers.safeGet(at: playerInd) as? ParsedPitcher {
                                        Text([pitcher.name, pitcher.team, pitcher.posStr()].joined(separator: " • "))
                                    }
                                }
                                .listRowBackground(Color.niceGray)
                            }
                            .cornerRadius(7)
                            .scrollContentBackground(.hidden)
                            .height(200)

                            TextField("Player Name", text: $searchTextForTeam2)
                                .padding(.horizontal)

                            if isSearching {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(2)
                            }
                        }
                    }

                    addPlayerButton
                }

                Spacer()
            }
            .padding(.horizontal)
        }
        .background {
            Color.backgroundBlue.ignoresSafeArea().frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onChange(of: searchTextForTeam2) { searchText in
            self.isSearching = true
            DispatchQueue.global(qos: .userInitiated).async {
                let batters = AllParsedBatters.batters(for: .steamer).filter {
                    $0.name.lowercased().removingWhiteSpaces().contains(searchText.lowercased().removingWhiteSpaces())
                }

                let pitchers = AllExtendedPitchers.steamer.all.filter {
                    $0.name.lowercased().removingWhiteSpaces().contains(searchText.lowercased().removingWhiteSpaces())
                }

                let filteredPlayers: [ParsedPlayer] = (batters + pitchers).prefixArray(4)

                DispatchQueue.main.async {
                    self.team2FilteredPlayers = filteredPlayers
                    self.isSearching = false
                }
            }
        }
    }
}

var addPlayerButton: some View {
    Button {
        // Add player logic here
    } label: {
        Label("Add Player", systemImage: "plus")
            .font(size: 16, color: .white, weight: .semibold)
            .frame(maxWidth: .infinity)
            .height(44)
            .background(color: .niceGray, padding: 0)
    }
}

// MARK: - DVTradeAnalysisSetup_Previews

struct DVTradeAnalysisSetup_Previews: PreviewProvider {
    static var previews: some View {
        DVTradeAnalysisSetup()
    }
}
