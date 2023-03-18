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

    @State private var testBool = false

    var verticalDivider: some View {
        RoundedRectangle(cornerRadius: 7)
            .frame(width: 1)
            .foregroundColor(MainModel.shared.specificColor.lighter)
    }

    var starImage: String {
        testBool ? "star.fill" : "star"
    }

    var starColor: Color {
        testBool ? .pointsGold : .lighterGray
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(player.name)
                        .lineLimit(2)
                        .font(size: 16, color: .white, weight: .bold)
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
                    .background(color: MainModel.shared.specificColor.nice, padding: 6)

                Text([player.fantasyPoints(.defaultPoints).simpleStr(), "PTS"])
                    .font(size: 14, color: .white)
                    .background(color: .pointsGold, padding: 6)
            }
            .layoutPriority(1)

            Button {
                withAnimation(.easeInOut(duration: 0.5)) {
                    testBool.toggle()
                    model.addOrRemoveStar(player)
                }
            } label: {
                Label("Toggle Favorite", systemImage: starImage)
                    .labelStyle(.iconOnly)
                    .rotationEffect(Angle(degrees: testBool ? 360 * 3 : 0))
                    .foregroundColor(starColor)
            }
//            .padding(.leading, 5)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background {
            MainModel.shared.specificColor.rect
//                MainModel.shared.specificColor.rect
                .cornerRadius(7)
                .shadow(radius: 1)
        }
        .onAppear {
            testBool = model.isStar(player)
        }
    }
}

// MARK: - DVAllPlayersRow_Previews

struct DVAllPlayersRow_Previews: PreviewProvider {
    static var previews: some View {
        DVAllPlayersRow(player: ParsedBatter.TroutOrNull)
            .environmentObject(MainModel.shared)
            .background {
                SpecificColors.firstOne.background
                    .ignoresSafeArea()
            }
    }
}
