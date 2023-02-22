//
//  NVSidePickCircles.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/14/23.
//

import SwiftUI

// MARK: - NVPreviousPickCircle

struct NVPreviousPickRect: View {
    let player: DraftPlayer

    var body: some View {
        VStack(spacing: 7) {
            Text("Pick #\(player.pickNumber)")
                .font(.headline)
            Image(systemName: "chevron.down")
            VStack {
                Text(player.player.name.components(separatedBy: .whitespaces)[0])

                Text(player.player.name.components(separatedBy: .whitespaces)[1])
            }
            .padding(10)
            .minimumScaleFactor(0.5)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke()
            }

            Text(player.draftedTeam?.name ?? "NA")
                .font(.headline)
        }
    }
}

// MARK: - NVPreviousPickCircle_Previews

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
