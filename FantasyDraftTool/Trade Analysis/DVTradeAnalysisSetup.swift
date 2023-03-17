//
//  DVTradeAnalysisSetup.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/16/23.
//

import SwiftUI


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


struct DVTradeAnalysisSetup: View {
    
    @State private var team1Sends: [ParsedPlayer] = []
    @State private var team2Sends: [ParsedPlayer] = []
    @State private var showSearchForTeam1 = false
    @State private var showSearchForTeam2 = true
    @State private var searchTextForTeam1 = ""
    @State private var searchTextForTeam2 = ""
//    @State private var AllPlayers =
    
    
    
    var team1FilteredPlayers: [ParsedPlayer] {
        let batters = AllParsedBatters.batters(for: .steamer).filter {
            $0.name.lowercased().removingWhiteSpaces().contains(searchTextForTeam1)
        }
        let pitchers = AllExtendedPitchers.steamer.all.filter {
            $0.name.lowercased().removingWhiteSpaces().contains(searchTextForTeam1)
        }
        return batters + pitchers
    }
    
    var team2FilteredPlayers: [ParsedPlayer] {
        let batters = AllParsedBatters.batters(for: .steamer).filter {
            $0.name.lowercased().removingWhiteSpaces().contains(searchTextForTeam2.lowercased().removingWhiteSpaces())
        }
        let pitchers = AllExtendedPitchers.steamer.all.filter {
            $0.name.lowercased().removingWhiteSpaces().contains(searchTextForTeam2.lowercased().removingWhiteSpaces())
        }
        return (batters + pitchers).prefixArray(4)
    }
    
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
                    Text("Team 1 Sends")
                        .font(size: 16, color: .lighterGray, weight: .medium)
                        .pushLeft()
                    
                    
                    PlayerBasicStatRow(player: ParsedBatter.TroutOrNull)
                    
                    if showSearchForTeam2 {
                        VStack {
                            List {
                                Text(team2FilteredPlayers.count.str)
                                Text(searchTextForTeam2.lowercased().removingWhiteSpaces())
                                ForEach(team2FilteredPlayers.indices, id: \.self) { playerInd in
                                    
                                    if let batter = team2FilteredPlayers.safeGet(at: playerInd) as? ParsedBatter {
                                        Text([batter.name,
                                              batter.team, batter.posStr()].joinString(" • "))
                                    }
                                    
                                    if let pitcher = team2FilteredPlayers.safeGet(at: playerInd) as? ParsedPitcher {
                                        Text([pitcher.name, pitcher.team, pitcher.posStr()].joinString(" • "))
                                    }
                                    
                                    
                                    
                                }

                                .listRowBackground(Color.niceGray)
                            }
                            .cornerRadius(7)
                            .scrollContentBackground(.hidden)
                            .height(200)
                            
                            TextField("Player Name", text: $searchTextForTeam2)
                            
                        }
                        
                        
                    }
                    
                    
                    addPlayerButton
                        
                    
                    
                }
                
                
                
                Spacer()
            }
            .padding(.horizontal)
        }
//        .maxSize()
        .background {
            Color.backgroundBlue.ignoresSafeArea().frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    
    var addPlayerButton: some View {
        
        Button {
            
        } label: {
            Label("Add Player", systemImage: "plus")
                .font(size: 16, color: .white, weight: .semibold)
                .frame(maxWidth: .infinity)
                .height(44)
                .background(color: .niceGray, padding: 0)
        }
         
        
    }
    
    
}

struct DVTradeAnalysisSetup_Previews: PreviewProvider {
    static var previews: some View {
        DVTradeAnalysisSetup()
    }
}
