//
//  DVAlreadyDraftedPlayerRow.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/9/23.
//

import SwiftUI

// MARK: - DVAlreadyDraftedPlayerRow

struct DVAlreadyDraftedPlayerRow: View {
    @EnvironmentObject private var model: MainModel

    let player: DraftPlayer
    var body: some View {
        HStack {
            row(player)
        }
        .height(75)
    }

    var verticalDivider: some View {
        RoundedRectangle(cornerRadius: 7)
            .frame(width: 1)
            .foregroundColor(.hexStringToColor(hex: "BEBEBE"))
//            .padding(.vertical, 10)
    }

    func row(_ player: DraftPlayer) -> some View {
        VStack(alignment: .leading) {
            if let batter = player.player as? ParsedBatter {
                HStack {
                    VStack(spacing: 7) {
                        HStack(spacing: 15) {
                            HStack(alignment: .bottom) {
                                Text(player.player.name)
                                    .font(.system(size: 20))
                                    .fontWeight(.medium)

                                Text([batter.posStr(), batter.team].joinString(" • "))
                                    .font(.system(size: 14))
                                    .fontWeight(.light)
                            }
                            .foregroundColor(.white)
                            Spacer()
                        }

                        HStack {
                           

                            HStack {
                                if let team = player.draftedTeam {
                                    Text(team.name)
//                                        .background(color: "A54700", padding: 7, radius: 10, shadow: 0)
                                }
                                verticalDivider
                                Text(["Round", player.roundNumber.str])
                                    
                                    verticalDivider
                                Text(["Pick", player.pickInRound.str])
                                    
                            }
                            .padding(.horizontal, 5)
                            .background(color: "305294", padding: 7, radius: 10, shadow: 0)

//                            .font(size: 12, color: .white, weight: .light)

                            Spacer()
                        }
                        .font(size: 12, color: .white)
                        

                        //                    HStack {
                        //                        HStack {
                        //                            Text([batter.avg.simpleStr(3, true), "AVG"])
                        //                            verticalDivider.padding(.vertical, 6)
                        //                            Text([batter.hr.str, "HR"])
                        //                            verticalDivider.padding(.vertical, 6)
                        //                            Text([batter.rbi.str, "RBI"])
                        //                            verticalDivider.padding(.vertical, 6)
                        //                            Text([batter.r.str, "R"])
                        //                            verticalDivider.padding(.vertical, 6)
                        //                            Text([batter.sb.str, "SB"])
                        //                        }
                        //                        Spacer()
                        //                        Text([batter.fantasyPoints(model.draft.settings.scoringSystem).simpleStr(), "pts"])
                        //                            .padding(3)
                        //                            .background {
                        //                                Color.hexStringToColor(hex: "4A555E")
                        //                                    .cornerRadius(7)
                        //                            }
                        //                    }
                        //                    .font(size: 15, color: .white, weight: .light)

                        //                statWithColorBox(player.fantasyPoints(.defaultPoints).str, label: "pts", plusMinus: 82)

                        //                statWithColorBox(20.9.str(), label: "ADP", plusMinus: -32)

                        //                statWithColorBox("#10", label: "OF", plusMinus: 32)
                    }

                    Spacer()

                    Text([batter.fantasyPoints(model.draft.settings.scoringSystem).simpleStr(), "pts"])
                        .font(size: 14, color: .white)
                        .background(color: "8B7500", padding: 6)
                }

                .frame(maxWidth: .infinity)
                //                .pushLeft()
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background {
                    Color.hexStringToColor(hex: "4A555E")
                        .cornerRadius(7)
                        .shadow(radius: 1.5)
                }
            }
        }
    }
}

// MARK: - DVAlreadyDraftedPlayerRow_Previews

struct DVAlreadyDraftedPlayerRow_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.hexStringToColor(hex: "33434F")
            DVAlreadyDraftedPlayerRow(player: .TroutOrNull)
                .environmentObject(MainModel.shared)

                .padding()
        }
    }
}
