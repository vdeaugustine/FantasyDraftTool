//
//  SwiftUIView.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/16/23.
//

import SwiftUI

// MARK: - TradeAnalysisView

struct TradeAnalysisView: View {
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("Team 1")
                        .font(size: 20, color: .white, weight: .medium)
                    Spacer()
                    HStack {
                        Text("HR")
                        Spacer()
                        Image(systemName: "baseball.diamond.bases")
                    }
                    .padding(.horizontal, 5)
                    .background(color: MainModel.shared.specificColor.nice, padding: 5, radius: 7, shadow: 1)
                    .frame(width: 90, height: 25)
                }

                VStack {
                    HStack {
                        statBox(str: "HR", differential: 3)
                        statBox(str: "RBI", differential: -3)
                        statBox(str: "HR", differential: 3)
                        statBox(str: "RBI", differential: -3)
                    }
                    HStack {
                        statBox(str: "HR", differential: 3)
                        statBox(str: "RBI", differential: -3)
                        statBox(str: "HR", differential: 3)
                        statBox(str: "RBI", differential: -3)
                    }
                }
                .padding(.top)

                VStack {
                    Text("Free Agent POS")
                        .font(size: 16, color: MainModel.shared.specificColor.lighter, weight: .medium)
                        .pushLeft()
                    
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            statPlayers(statKey: "PTS")
                            statPlayers(statKey: "HR")
                            statPlayers(statKey: "RBI")
                            statPlayers(statKey: "R")
                            statPlayers(statKey: "AVG")
                            statPlayers(statKey: "SB")
                        }
                    }
                    
                    
                }
                .padding(.top)
            }
            .padding()
        }
        .background {
            MainModel.shared.specificColor.background
        }
        .navigationTitle("Trade Analysis")
        .navigationBarTitleDisplayMode(.large)
    }
    
    func statPlayers(statKey: String) -> some View {
        VStack(spacing: 7) {
            Text(statKey)
                .font(size: 12, color: MainModel.shared.specificColor.lighter, weight: .regular)
            
            playerBox(batter: .TroutOrNull, statKey: statKey)
        }
    }

    func playerBox(batter: ParsedBatter, statKey: String) -> some View {
        HStack {
            Text(batter.name)
                .lineLimit(1)
                .minimumScaleFactor(0.9)
            Rectangle()
                .frame(width: 1, height: 18)
            
            if statKey == "PTS" {
                Text(batter.fantasyPoints(.defaultPoints).simpleStr())
            }
            
            if let stat = batter.dict[statKey] as? Double {
                Text(stat.formatForBaseball())
            } else if let stat = batter.dict[statKey] as? Int {
                Text(stat.str)
            }
        }
        .frame(maxWidth: 110)
        .font(size: 12, color: MainModel.shared.specificColor.lighter, weight: .regular)
        .background(color: MainModel.shared.specificColor.rect, padding: 8, radius: 7, shadow: 1)
    }

    func statBox(str: String, differential: Int) -> some View {
        var color: Color {
            if differential > 0 {
                return .labelGreen
            } else if differential == 0 {
                return MainModel.shared.specificColor.lighter
            } else {
                return .labelRed
            }
        }
        var sign: String {
            if differential > 0 {
                return "+"
            } else if differential == 0 {
                return ""
            } else {
                return "-"
            }
        }
        return VStack {
            Text(str)
                .font(size: 16, color: .white, weight: .bold)
                .pushLeft()
                .padding(.leading, 3)
            Text([sign, abs(differential).str])
                .font(size: 16, color: .white, weight: .regular)
                .padding(.horizontal, 5)
                .background(color: color, padding: 5, radius: 7, shadow: 1)
        }
        .frame(width: 70, height: 70)
        .background(color: MainModel.shared.specificColor.rect, padding: 5, radius: 7, shadow: 1)
    }
}

// MARK: - TradeAnalysisView_Previews

struct TradeAnalysisView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TradeAnalysisView()
        }
    }
}
