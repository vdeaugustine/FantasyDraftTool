//
//  DVTradeAnalysisSetup.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/16/23.
//

import SwiftUI

// MARK: - PlayerBasicStatRow

var hDivider: some View {
    Rectangle()
        .frame(width: 1, height: 20)
}

// MARK: - PlayerBasicStatRow

struct PlayerBasicStatRow: View {
    let player: ParsedPlayer
    var padding: CGFloat = 15

    var body: some View {
        HStack {
            Text(player.name)
                .font(size: 16, color: .white, weight: .medium)
            Spacer()

            Text([player.fantasyPoints(.defaultPoints).simpleStr(), "pts"])
                .font(size: 12, color: .white, weight: .light)

            HStack {
                if let batter = player as? ParsedBatter {
                    hDivider
                    Text([batter.avg.formatForBaseball(), "AVG"])
                    hDivider
                    Text([batter.hr.str, "HR"])
                    hDivider
                    Text([batter.rbi.str, "RBI"])
                }
                
                if let pitcher = player as? ParsedPitcher {
                    hDivider
                    Text([pitcher.era.roundTo(places:2).str, "ERA"])
                    hDivider
                    Text([pitcher.ip.str, "IP"])
                    hDivider
                    Text([pitcher.so.str, "SO"])
                }
            }
            .font(size: 12, color: .white, weight: .light)
        }
        .contentShape(Rectangle())
        .background(color: MainModel.shared.specificColor.rect, padding: padding)
    }
}

// MARK: - PlayerBasicStatRowButton

struct PlayerBasicStatRowButton: View {
    let player: ParsedPlayer
    var padding: CGFloat = 15

    let action: () -> Void

//    @Binding var teamSends: [ParsedPlayer]

    var body: some View {
        PlayerBasicStatRow(player: player)
        .onTapGesture {
            action()
        }
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
        .background(MainModel.shared.specificColor.rect)
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
            .background(MainModel.shared.specificColor.rect)
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

// MARK: - DVTradeAnalysisSetup

struct DVTradeAnalysisSetup: View {
    @State private var team1Sends: [ParsedPlayer] = []
    @State private var team2Sends: [ParsedPlayer] = []
    @State private var showSearchForTeam1 = false
    @State private var showSearchForTeam2 = false
    @State private var searchTextForTeam1 = ""
    @State private var searchTextForTeam2 = ""
    @State private var team1FilteredPlayers: [ParsedPlayer] = []
    @State private var team2FilteredPlayers: [ParsedPlayer] = []
    @State private var team2IsSearching = false
    @State private var team1IsSearching = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
//                Text("Set Up Trade")
//                    .font(size: 28, color: .white, weight: .bold)
//                    .pushLeft()

                TeamSendView(teamSends: $team1Sends, showSearch: $showSearchForTeam1, searchText: $searchTextForTeam1, filteredPlayers: $team1FilteredPlayers, isSearching: $team2IsSearching, teamName: "Team 1")

                TeamSendView(teamSends: $team2Sends, showSearch: $showSearchForTeam2, searchText: $searchTextForTeam2, filteredPlayers: $team2FilteredPlayers, isSearching: $team2IsSearching, teamName: "Team 2")
//                VStack(spacing: 15) {
//                    Text("Team 2 Sends")
//                        .font(size: 20, color: .white, weight: .medium)
//                        .pushLeft()
//
//                    ForEach(team2Sends.indices, id: \.self) { playerInd in
//                        if let player = team2Sends.safeGet(at: playerInd) {
//                            PlayerBasicStatRow(player: player)
//                        }
//                    }
//
//                    if showSearchForTeam2 {
//                        VStack {
//                            Text("Add Players")
//                                .font(size: 16, color: MainModel.shared.specificColor.lighter, weight: .medium)
//                                .pushLeft()
//                                .padding(.leading)
//                            SearchTextField(searchText: $searchTextForTeam2, placeholder: "Player Name")
//                                .foregroundColor(.white)
//                                .padding(.horizontal, 16)
//                            if team2FilteredPlayers.isEmpty == false {
//                                ZStack {
//                                    ScrollView {
//                                        LazyVStack {
//                                            ForEach(team2FilteredPlayers.indices, id: \.self) { playerInd in
//
//                                                if let batter = team2FilteredPlayers.safeGet(at: playerInd) as? ParsedBatter {
//                                                    PlayerBasicStatRowButton(player: batter) {
//                                                        if !team2Sends.contains(batter) {
//                                                            team2Sends.append(batter)
//                                                        }
//                                                        searchTextForTeam2 = ""
//                                                    }
//                                                }
//
//                                                if let pitcher = team2FilteredPlayers.safeGet(at: playerInd) as? ParsedPitcher {
//                                                    PlayerBasicStatRowButton(player: pitcher) {
//                                                        if !team2Sends.contains(pitcher) {
//                                                            team2Sends.append(pitcher)
//                                                        }
//                                                        searchTextForTeam2 = ""
//                                                    }
//                                                }
//                                            }
//                                            .listRowBackground(Color.clear)
//                                            Spacer()
//                                        }
//                                    }
//                                    .height(200)
//                                    .listStyle(.plain)
//                                    .cornerRadius(7)
//
//                                    if isSearching {
//                                        ProgressView()
//                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
//                                            .scaleEffect(2)
//                                    }
//                                }
//                            } else {
//                                Spacer()
//                            }
//                        }
//                    }
//
//                    if showSearchForTeam2 {
//                        doneButton(2)
//                    } else {
//                        addPlayerButton(2)
//                    }
//                }

                Spacer()
            }
            .padding()
        }
        .navigationBarTitle("Set Up Trade")
        .safeAreaInset(edge: .bottom) {
            NavigationLink {
                
            } label: {
                Label("Analyze", systemImage: "chart.bar.fill")
                    .font(size: 16, color: .white, weight: .semibold)
                    .frame(maxWidth: .infinity)
                    .height(44)
                    .background(color: MainModel.shared.specificColor.nice, padding: 0)
                    .padding()
            }
        }
        .background {
            MainModel.shared.specificColor.background.ignoresSafeArea().frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onChange(of: searchTextForTeam2) { searchText in
            self.team2IsSearching = true
            DispatchQueue.global(qos: .userInitiated).async {
                let batters = AllParsedBatters.batters(for: .steamer).filter { batterElement in

                    let isInSending = self.team1Sends.contains(batterElement) || self.team2Sends.contains(batterElement)

                    let isInSearch = batterElement.name.lowercased().removingWhiteSpaces().contains(searchText.lowercased().removingWhiteSpaces())

                    return !isInSending && isInSearch
                }

                let pitchers = AllExtendedPitchers.steamer.all.filter { pitcherElement in

                    let isInSending = self.team1Sends.contains(pitcherElement) || self.team2Sends.contains(pitcherElement)

                    let isInSearch = pitcherElement.name.lowercased().removingWhiteSpaces().contains(searchText.lowercased().removingWhiteSpaces())

                    return !isInSending && isInSearch
                }

                let filteredPlayers: [ParsedPlayer] = (batters + pitchers).prefixArray(4)

                DispatchQueue.main.async {
                    self.team2FilteredPlayers = filteredPlayers
                    self.team2IsSearching = false
                }
            }
        }
        .onChange(of: searchTextForTeam1) { searchText in
            self.team1IsSearching = true
            DispatchQueue.global(qos: .userInitiated).async {
                let batters = AllParsedBatters.batters(for: .steamer).filter { batterElement in
                    
                    let isInSending = self.team1Sends.contains(batterElement) || self.team2Sends.contains(batterElement)
                    
                    let isInSearch = batterElement.name.lowercased().removingWhiteSpaces().contains(searchText.lowercased().removingWhiteSpaces())
                    
                    return !isInSending && isInSearch
                }
                
                let pitchers = AllExtendedPitchers.steamer.all.filter { pitcherElement in
                    
                    let isInSending = self.team1Sends.contains(pitcherElement) || self.team2Sends.contains(pitcherElement)

                    let isInSearch = pitcherElement.name.lowercased().removingWhiteSpaces().contains(searchText.lowercased().removingWhiteSpaces())

                    return !isInSending && isInSearch
                }

                let filteredPlayers: [ParsedPlayer] = (batters + pitchers).prefixArray(4)

                DispatchQueue.main.async {
                    self.team1FilteredPlayers = filteredPlayers
                    self.team1IsSearching = false
                }
            }
        }
    }
    
    func addPlayerButton(_ num: Int) -> some View {
        Button {
            if num == 1 {
                showSearchForTeam1 = true
            } else {
                showSearchForTeam2 = true
            }
            
        } label: {
            Label("Add Player", systemImage: "plus")
                .font(size: 16, color: .white, weight: .semibold)
                .frame(maxWidth: .infinity)
                .height(44)
                .background(color: MainModel.shared.specificColor.rect, padding: 0)
        }
    }


    
    func doneButton(_ num: Int) -> some View {
        Button {
            if num == 1 {
                showSearchForTeam1 = false
            } else {
                showSearchForTeam2 = false
            }
            
        } label: {
            Label("Done", systemImage: "checkmark.circle.fill")
                .font(size: 16, color: .white, weight: .semibold)
                .frame(maxWidth: .infinity)
                .height(44)
                .background(color: MainModel.shared.specificColor.nice, padding: 0)
        }
    }
    
}

// MARK: - DVTradeAnalysisSetup_Previews

struct DVTradeAnalysisSetup_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DVTradeAnalysisSetup()
        }
        
    }
}
