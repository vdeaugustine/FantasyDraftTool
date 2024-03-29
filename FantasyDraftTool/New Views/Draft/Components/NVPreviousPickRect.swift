//
//  NVSidePickCircles.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/14/23.
//

import SwiftUI

// MARK: - NVPreviousPickRect

struct NVPreviousPickRect: View {
    let player: DraftPlayer

    var body: some View {
        VStack(spacing: 0) {
            Text("#\(player.pickNumber)")
                .font(.footnote)

            VStack {
                Text(player.player.name.components(separatedBy: .whitespaces)[0])
                if let thirdName = player.player.name.components(separatedBy: .whitespaces).safeGet(at: 2) {
                    Text(player.player.name.components(separatedBy: .whitespaces)[1] + " \(thirdName)")
                } else {
                    Text(player.player.name.components(separatedBy: .whitespaces)[1])
                }
            }
            .padding()
            .background {
                Color.hexStringToColor(hex: "EFEFF4").cornerRadius(8).shadow(radius: 0.75)
            }

            .font(.footnote)
            .padding(10)
            .minimumScaleFactor(0.5)

//            .overlay {
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke()
//            }

            Text(player.draftTeam.name)
                .font(.footnote)
        }
    }
}

// MARK: - NVPreviousPickRect_Previews

struct NVPreviousPickRect_Previews: PreviewProvider {
    static var previews: some View {
        NVPreviousPickRect(
            player: .init(player: AllExtendedBatters.batters(for: .steamer,
                                                             at: .first, limit: UserDefaults.positionLimit).first!,
                          pickNumber: 24,
                          team: .init(name: "Team 4",
                                      draftPosition: 3),
                          weightedScore: 1.20)
        )
        .frame(width: 150, height: 150)
        .previewLayout(.sizeThatFits)
    }
}
