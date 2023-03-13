//
//  DVTeamStatBox.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/12/23.
//

import SwiftUI

struct DVTeamStatBox: View {
    
    let team: DraftTeam
    let value: Double
    
    var body: some View {
        HStack {
            Text(team.name)
                .lineLimit(1)
                .minimumScaleFactor(0.9)
            Rectangle()
                .frame(width: 1, height: 18)
            Text(value.simpleStr())
        }
        .frame(maxWidth: 110)
        .font(size: 12, color: "BEBEBE", weight: .regular)
        .background(color: "4A555E", padding: 8, radius: 7, shadow: 1)
        
    }
}

struct DVTeamStatBox_Previews: PreviewProvider {
    static var previews: some View {
        DVTeamStatBox(team: .someDefaultTeams(amount: 1).first!, value: 26.1)
    }
}
