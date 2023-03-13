//
//  DVAllPlayersRow.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/9/23.
//

import SwiftUI

// MARK: - DVAllPlayersRow

struct DVAllPlayersRow: View {
    @EnvironmentObject private var model: MainModel

    let player: ParsedPlayer

    var verticalDivider: some View {
        RoundedRectangle(cornerRadius: 7)
            .frame(width: 1)
            .foregroundColor(.hexStringToColor(hex: "BEBEBE"))
    }

    var starImage: String {
        model.isStar(player) ? "star.fill" : "star"
    }

    var starColor: String {
        model.isStar(player) ? "8B7500" : "BEBEBE"
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(player.name).font(size: 16, color: .white, weight: .bold)
                }

                HStack {
                    Text(player.posStr()).font(size: 13, color: .white, weight: .regular)
                    verticalDivider.height(10)
                    Text(player.team).font(size: 13, color: .white, weight: .regular)
                }

//                HStack {
//                    VStack {
//                        Text(player.fantasyPoints(.defaultPoints).simpleStr())
//                        Text("pts".uppercased())
//                    }
//                    verticalDivider.height(35)
//
//                    ForEach(["AVG", "HR", "RBI", "R"], id: \.self) { stat in
//
//                        if let dub = player.dict[stat] as? Double {
//                            VStack {
//                                Text(dub.simpleStr(3, true))
//                                Text(stat)
//                            }
                ////                            .background(color: "305294", padding: 7, radius: 10, shadow: 0)
//                        } else if let int = player.dict[stat] as? Int {
//                            VStack {
//                                Text(int.str)
//                                Text(stat)
//                            }
                ////                            .background(color: "305294", padding: 7, radius: 10, shadow: 0)
//                        }
//                        verticalDivider.height(20)
//                    }
//
//
//                    Text("#3 OF")
//
//
//                }
//                .font(size: 12, color: .white, weight: .light)
//                .background(color: "305294", padding: 7, radius: 10, shadow: 0)
//                .frame(maxWidth: .infinity)
            }

            Spacer()

            HStack {
                Text([player.wPointsZScore(draft: model.draft).simpleStr(), "wPTS"])
                    .font(size: 14, color: .white)
                    .background(color: .niceBlue, padding: 6)

                Text([player.fantasyPoints(.defaultPoints).simpleStr(), "PTS"])
                    .font(size: 14, color: .white)
                    .background(color: .pointsGold, padding: 6)
            }

            Button {
                withAnimation(.easeInOut(duration: 0.5)) {
                    model.addOrRemoveStar(player)
                }
            } label: {
                Label("Toggle Favorite", systemImage: starImage)
                    .labelStyle(.iconOnly)
                    .rotationEffect(Angle(degrees: model.isStar(player) ? 360 * 3 : 0))
                    .foregroundColor(Color.hexStringToColor(hex: starColor))
            }.padding(.leading)

        }.frame(maxWidth: .infinity)
            .padding()
            .background {
                Color.hexStringToColor(hex: "4A555E")
                    .cornerRadius(7)
                    .shadow(radius: 1)
            }
    }
}

// MARK: - DVAllPlayersRow_Previews

struct DVAllPlayersRow_Previews: PreviewProvider {
    static var previews: some View {
        DVAllPlayersRow(player: ParsedBatter.TroutOrNull)
            .environmentObject(MainModel.shared)
            .background {
                Color.hexStringToColor(hex: "33434F")
                    .ignoresSafeArea()
            }
    }
}
