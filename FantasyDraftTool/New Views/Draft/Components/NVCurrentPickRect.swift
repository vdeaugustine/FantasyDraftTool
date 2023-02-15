//
//  NVCurrentPickRect.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/14/23.
//

import SwiftUI

struct NVCurrentPickRect: View {
    
    let draft: Draft
    
    var currentTeam: DraftTeam {
        draft.currentTeam
    }
    
    var positionsEmpty: Set<Position> {
        draft.currentTeam.positionsEmpty
    }
    
    var poolForPositions: Set<ParsedBatter> {
        var retSet: Set<ParsedBatter> = []
        for position in positionsEmpty {
            guard let pool = draft.playerPool.battersDict[position] else { continue }
            for player in pool {
                retSet.insert(player)
            }
        }
        return retSet
    }
    
    var prediction: ParsedBatter? {
        poolForPositions.sorted(by: {$0.zScore() > $1.zScore()}).first
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

struct NVCurrentPickRect_Previews: PreviewProvider {
    static var previews: some View {
        NVCurrentPickRect(draft: .exampleDraft())
        .frame(width: 150, height: 150)
        .previewLayout(.sizeThatFits)
    }
}
