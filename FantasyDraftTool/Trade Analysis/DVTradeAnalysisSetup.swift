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

    var padding: CGFloat = 15
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
        .background(color: .niceGray, padding: padding)
    }
}

// MARK: - SearchTextField

struct SearchTextField: View {
    var searchText: Binding<String>
    var placeholder: String = "Search"

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.white)

            TextField(placeholder, text: searchText)
                .foregroundColor(.white)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.niceGray)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

// MARK: - SearchTextFieldStyle

struct SearchTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.niceGray)
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
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
                    
                    if showSearchForTeam2 {
                        Group {
                            PlayerBasicStatRow(player: ParsedBatter.TroutOrNull)

                            if team2FilteredPlayers.isEmpty == false {
                                ZStack {
                                    ScrollView {
                                        LazyVStack {
                                            ForEach(team2FilteredPlayers.indices, id: \.self) { playerInd in
                                                
                                                if let batter = team2FilteredPlayers.safeGet(at: playerInd) as? ParsedBatter {
                                                    PlayerBasicStatRow(player: batter)
                                                }
                                                
                                                if let pitcher = team2FilteredPlayers.safeGet(at: playerInd) as? ParsedPitcher {
                                                    PlayerBasicStatRow(player: pitcher)
                                                }
                                            }
                                            .listRowBackground(Color.clear)
                                            Spacer()
                                        }
                                    }
                                    .height(200)
                                    .listStyle(.plain)
                                    .cornerRadius(7)
                                    
                                    if isSearching {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                            .scaleEffect(2)
                                    }
                                }
                            }
                            
                            else {
                                Spacer()
                            }
                        }
                    }

                    Spacer()
                }
                .padding(.leading)

                if showSearchForTeam2 {
                    VStack {
                        SearchTextField(searchText: $searchTextForTeam2, placeholder: "Player Name")
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 16)
                        addPlayerButton
                    }
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

var doneButton: some View {
    Button {
        // Add player logic here
    } label: {
        Label("Done", systemImage: "checkmark.circle.fill")
            .font(size: 16, color: .white, weight: .semibold)
            .frame(maxWidth: .infinity)
            .height(44)
            .background(color: .niceBlue, padding: 0)
    }
}

// MARK: - DVTradeAnalysisSetup_Previews

struct DVTradeAnalysisSetup_Previews: PreviewProvider {
    static var previews: some View {
        DVTradeAnalysisSetup()
    }
}
