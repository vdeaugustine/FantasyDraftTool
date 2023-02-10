//
//  RemainingAnalysisPosition.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/9/23.
//

import SwiftUI

// MARK: - RemainingAnalysisPosition

struct RemainingAnalysisPosition: View {
    @EnvironmentObject private var model: MainModel
    let position: Position
    @State private var showTop3: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            Text(position.str.uppercased())
                .font(.title3)
                .fontWeight(.bold)

            if let players = model.draft.playerPool.battersDict[position] {
                Text("Remaining players: \(players.count)")
            }

            if let average = model.draft.playerPool.positionAveragesDict[position] {
                Text("Average points: \(average.roundTo(places: 1).str)")
            }
            
            if showTop3,
            let players = model.draft.playerPool.battersDict[position] {
                
                ForEach(players.prefixArray(3), id: \.self) { player in
                    VStack {
                        Text("\(player.name): \(player.fantasyPoints(model.scoringSettings).str)")
                        
                    }
                    
                    
                }
            }
            
            Button(showTop3 ? "Hide" : "Show top 3") {
                    showTop3.toggle()
                
            }
        }
    }
}

// MARK: - RemainingAnalysisPosition_Previews

struct RemainingAnalysisPosition_Previews: PreviewProvider {
    static var previews: some View {
        RemainingAnalysisPosition(position: .second)
            .environmentObject(MainModel.shared)
    }
}
