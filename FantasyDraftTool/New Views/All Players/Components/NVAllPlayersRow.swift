//
//  NVAllPlayersRow.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/14/23.
//

import SwiftUI

// MARK: - NVAllPlayersRow

struct NVAllPlayersRow<T>: View where T: ParsedPlayer {
    @EnvironmentObject private var model: MainModel

    let player: T
    let draft: Draft

    var positionRank: Int? {
        if let batter = player as? ParsedBatter {
            guard let position = batter.positions.first else { return nil }
            let otherPlayers = draft.playerPool.storedBatters.batters(for: batter.projectionType, at: position)
            guard let firstIndex = otherPlayers.firstIndex(of: batter) else {
                return nil
            }
            return firstIndex + 1
        } else if let pitcher = player as? ParsedPitcher {
            let otherPitchers = draft.playerPool.storedPitchers.pitchers(for: pitcher.projectionType, at: pitcher.type)
            guard let firstIndex = otherPitchers.firstIndex(of: pitcher) else { return 0 }
            return firstIndex + 1
        }
        return nil
    }

    var pitcherRank: Int? {
        guard let pitcher = player as? ParsedPitcher else {
            return nil
        }

        let otherPitchers: [ParsedPitcher] = draft.playerPool.storedPitchers.pitchers(for: pitcher.projectionType, at: pitcher.type)
        guard let firstIndex = otherPitchers.firstIndex(of: pitcher) else {
            return nil
        }
        return firstIndex + 1
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    HStack {
                        Text(player.name + ", " + player.team)
                            .font(Font.body)
                            .fontWeight(.bold)
                        Spacer()
                    }
                }

                HStack {
                    if let batter = player as? ParsedBatter {
                        if let position = batter.positions.first,
                           let rank = positionRank {
                            HStack(spacing: 0) {
                                Text("#" + rank.str)
                                Text(" \(batter.projectionType.title) \(position.str.uppercased())")
                            }.padding(5)
                            //                                .overlay {
                            //                                    RoundedRectangle(cornerRadius: 10)
                            //                                        .stroke(lineWidth: 1)
                            //                                }
                        }
                        if let adp = batter.adp {
                            HStack(spacing: 2) {
                                Text("\(adp.roundTo(places: 1).str())")
                                Text("ADP")

                            }.padding(5)
                            //                                .overlay {
                            //                                    RoundedRectangle(cornerRadius: 10)
                            //                                        .stroke(lineWidth: 1)
                            //                                }
                        }

                        HStack(spacing: 2) {
                            Text("\(batter.zScore(draft: model.draft).roundTo(places: 1).str)")
                            Text("Pos Score")
                        }.padding(5)
                        //                        .overlay {
                        //                            RoundedRectangle(cornerRadius: 10)
                        //                                .stroke(lineWidth: 1)
                        //                        }

                        //                    Spacer()
                    }

                    if let pitcher = player as? ParsedPitcher {
                        if let rank = pitcherRank {
                            HStack(spacing: 0) {
                                Text("#" + rank.str)
                                Text(" \(pitcher.projectionType.title) \(pitcher.type.str)")
                            }.padding(5)
                        }

                        if let adp = pitcher.adp {
                            HStack(spacing: 2) {
                                Text("\(adp.roundTo(places: 1).str())")
                                Text("ADP")

                            }.padding(5)
                        }

                        HStack(spacing: 2) {
                            Text("\(pitcher.zScore(draft: model.draft).roundTo(places: 1).str)")
                            Text("Score")
                        }.padding(5)
                        //                        .overlay {
                        //                            RoundedRectangle(cornerRadius: 10)
                        //                                .stroke(lineWidth: 1)
                        //                        }

                        //                    Spacer()
                    }

                    //                    if let pitcher = player as? ParsedPitcher {
                    //                        Text(pitcher.ip.str + " IP")
                    //                        Text(pitcher.w.str + " W")
                    //                        Text(pitcher.l.str + " L")
                    //                        Text(pitcher.so.str + " SO")
                    //                        Spacer()
                    //                        VStack {
                    //                            Text("score: \(pitcher.zScore(draft: model.draft).roundTo(places: 1).str)")
                    //                            if let adp = pitcher.adp {
                    //                                Text("ADP: \(adp)")
                    //                            }
                    //                            if let batter = player as? ParsedBatter {
                    //                                Text("Weighted" + batter.weightedFantasyPoints(draft: model.draft, limit: 50).roundTo(places: 2).str)
                    //                                Text("Position average " + batter.averageForPosition(limit: 50, draft: model.draft).roundTo(places: 1).str)
                    //                            }
                    //
                    //                            if let pitcher = player as? ParsedPitcher {
                    //                                Text("Weighted" + pitcher.weightedFantasyPoints(draft: model.draft, limit: 100).roundTo(places: 2).str)
                    //                                Text("Position average " + pitcher.averageForPosition(limit: 50, draft: model.draft).roundTo(places: 1).str)
                    //                            }
                    //                        }.font(.caption)
                }
            }

            VStack {
                Text(player.fantasyPoints(model.draft.settings.scoringSystem).str)
                Text("proj. pts")
            }

            .padding(.vertical)
        }
        .font(.caption)
    }
}

// MARK: - NVAllPlayersRow_Previews

struct NVAllPlayersRow_Previews: PreviewProvider {
    static var previews: some View {
        NVAllPlayersRow(player: AllExtendedBatters.batters(for: .atc, at: .first, limit: UserDefaults.positionLimit)[0], draft: MainModel.shared.draft)
            .previewLayout(.sizeThatFits)
            .environmentObject(MainModel.shared)
    }
}
