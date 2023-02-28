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
    

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(player.name)
                    .fontWeight(.bold)
                Spacer()
                Text(player.fantasyPoints(.defaultPoints).str + " pts")
                    .font(.callout)
            }
            
            
            
            HStack {
                if let batter = player as? ParsedBatter {
                    Text(batter.hr.str + " HR")
                    Text(batter.rbi.str + " RBI")
                    Text(batter.r.str + " R")
                    Text(batter.sb.str + " SB")
                    Spacer()
                    Text("score: \(batter.zScore(draft: model.draft).roundTo(places: 1).str)")
                }
                
                if let pitcher = player as? ParsedPitcher {
                    Text(pitcher.ip.str + " IP")
                    Text(pitcher.w.str + " W")
                    Text(pitcher.l.str + " L")
                    Text(pitcher.so.str + " SO")
                    Spacer()
                    Text("score: \(pitcher.zScore(draft: model.draft).roundTo(places: 1).str)")
                }
                
            }
            .font(.caption)
            
        }
        .padding(.vertical)
    }
}

// MARK: - NVAllPlayersRow_Previews

struct NVAllPlayersRow_Previews: PreviewProvider {
    static var previews: some View {
        NVAllPlayersRow(player: AllExtendedBatters.batters(for: .atc, at: .first, limit: UserDefaults.positionLimit)[0])
            .previewLayout(.sizeThatFits)
            .environmentObject(MainModel.shared)
    }
}
