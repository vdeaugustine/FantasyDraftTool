//
//  NVCurrentPickRect.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/14/23.
//

import SwiftUI

// MARK: - NVCurrentPickRect

struct NVCurrentPickRect: View {
    let draft: Draft

    let projection: ProjectionTypes

    var currentTeam: DraftTeam {
        draft.currentTeam
    }

    var positionsEmpty: Set<Position> {
        draft.currentTeam.positionsEmpty
    }

    var poolForPositions: Set<ParsedBatter> {
        var retSet: Set<ParsedBatter> = []
        for position in positionsEmpty {
            let pool = draft.playerPool.storedBatters.batters(for: draft.projectionCurrentlyUsing, at: position)
            for player in pool {
                retSet.insert(player)
            }
        }
        return retSet
    }

    var prediction: ParsedPlayer? {
        guard draft.playerPool.storedBatters.batters(for: draft.projectionCurrentlyUsing).isEmpty == false else {
            return nil
        }
        return draft.currentTeam.recommendedPlayer(draft: draft, projection: projection)
    }

    var body: some View {
        VStack(spacing: 7) {
            Text("Pick #\(draft.totalPickNumber)")
                .font(.headline)

            Image(systemName: "chevron.down")

            VStack {
                if let player = prediction {
                    Text("Prediction:")
                        .font(.caption2)
                    Text(player.name.components(separatedBy: .whitespaces)[0])

                    Text(player.name.components(separatedBy: .whitespaces)[1])
                }
            }
            .padding(10)
            .minimumScaleFactor(0.5)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke()
            }

            Text(draft.currentTeam.name)
                .font(.headline)
        }
    }
}

// MARK: - NVCurrentPickRect_Previews

struct NVCurrentPickRect_Previews: PreviewProvider {
    static var previews: some View {
        NVCurrentPickRect(draft: .nullDraft, projection: .atc)
            .frame(width: 150, height: 150)
            .previewLayout(.sizeThatFits)
    }
}
