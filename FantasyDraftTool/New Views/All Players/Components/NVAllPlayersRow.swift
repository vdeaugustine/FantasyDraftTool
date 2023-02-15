//
//  NVAllPlayersRow.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/14/23.
//

import SwiftUI

// MARK: - NVAllPlayersRow

struct NVAllPlayersRow: View {
    let batter: ParsedBatter

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(batter.name)
                    .fontWeight(.bold)
                Spacer()
                Text(batter.fantasyPoints(.defaultPoints).str + " pts")
                    .font(.callout)
            }
            
            HStack {
                Text(batter.hr.str + " HR")
                Text(batter.rbi.str + " RBI")
                Text(batter.r.str + " R")
                Text(batter.sb.str + " SB")
                Spacer()
                Text("score: \(batter.zScore().roundTo(places: 1).str)")
                
            }
            .font(.caption)
            
        }
        .padding(.vertical)
    }
}

// MARK: - NVAllPlayersRow_Previews

struct NVAllPlayersRow_Previews: PreviewProvider {
    static var previews: some View {
        NVAllPlayersRow(batter: AllParsedBatters.batters(for: .atc, at: .first)[0])
            .previewLayout(.sizeThatFits)
    }
}
