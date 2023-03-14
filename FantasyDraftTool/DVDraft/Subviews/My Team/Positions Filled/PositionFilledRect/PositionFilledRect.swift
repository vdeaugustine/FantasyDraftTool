//
//  PositionFilledRect.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/10/23.
//

import SwiftUI

// MARK: - PositionFilledRect

struct PositionFilledRect: View {
    let position: Position
    let myTeam: DraftTeam

    var topPosLabel: some View {
        Text(position.str.uppercased())
            .font(size: 12, color: "BEBEBE", weight: .regular)
    }

    var numFilled: Int {
        myTeam.players(for: position).count
    }

    var numNeeded: Int {
        let num = myTeam.minForPositions[position] ?? 0
        return num > 6 ? 6 : num
    }

    var valueLabel: some View {
        Text(numFilled.str)
            .font(size: 12, color: "BEBEBE", weight: .regular)
    }

    var body: some View {
        VStack(spacing: 3) {
            topPosLabel

            VStack {
                valueLabel
                HStack(spacing: 1.5) {
                    ForEach(0 ..< 3, id: \.self) { num in
                        SmallPillForProgress(isFilled: num < numFilled)
                    }
                }
                if numNeeded >= 3 {
                    HStack(spacing: 1.5) {
                        ForEach(3 ..< 6, id: \.self) { num in
                            if num < numNeeded {
                                SmallPillForProgress(isFilled: num < numFilled)
                            }
                            
                        }
                    }
                }
            }

            .background(color: "4A555E", padding: 5, radius: 7, shadow: 1)
//            ForEach(myTeam.draftedPlayers, id: \.self) { player in
//                Text(player.player.name)
//            }
        }
    }
}

// MARK: - PositionFilledRect_Previews

struct PositionFilledRect_Previews: PreviewProvider {
    static var previews: some View {
        PositionFilledRect(position: .of, myTeam: Draft.exampleDraft(picksMade: 2, projection: .atc).myTeam!)
            .previewBackground()
    }
}

extension View {
    func previewBackground() -> some View {
        frame(maxWidth: .infinity, maxHeight: .infinity)
//            .ignoresSafeArea()
            .background(color: "33434F", padding: 0)
    }
}
