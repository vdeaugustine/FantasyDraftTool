//
//  BoxForCurrentPickDVDraft.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/10/23.
//

import SwiftUI

struct BoxForCurrentPickDVDraft: View {
    
    
    @EnvironmentObject private var model: MainModel
    
    var draft: Draft { model.draft }
    
    var body: some View {
        VStack {
            teamNameAndDraftPickNumber
            boxPart
                .background(color: "4A555E", padding: 10, radius: 7, shadow: 1)
                .frame(width: 125, height: 88)
            currentLabel
        }
    }

    var teamNameAndDraftPickNumber: some View {
        VStack {
            Text("#\(draft.totalPickNumber)")
                .font(size: 16, color: .hexStringToColor(hex: "BEBEBE"), weight: .light)
            if let team = draft.currentTeam {
                Text("\(team.name)")
                    .font(size: 16, color: .hexStringToColor(hex: "BEBEBE"), weight: .bold)
            }
        }
    }
    
    var getName: (firstName: String, lastName: String) {
        let full = player.name.components(separatedBy: .whitespaces)
        let first = full.safeGet(at: 0) ?? ""
        let second = full.safeGet(at: 1) ?? ""
        let suffix = full.safeGet(at: 2) ?? ""
        let last = [second, suffix].joinString(" ")
        return (firstName: first, lastName: last)
    }

    var boxPart: some View {
        
        VStack(spacing: 12) {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text(getName.firstName)
                        .font(size: 16, color: .white, weight: .medium)
                    Text(getName.lastName)
                        .font(size: 16, color: .white, weight: .medium)
                }
                Text(player.team)
                    .font(size: 8, color: .white, weight: .ultraLight)
            }.pushLeft()

            HStack {
                VStack {
                    Text("RANK")
                        .font(size: 8, color: .hexStringToColor(hex: "BEBEBE"), weight: .light)
                    Text("3")
                        .font(size: 12, color: .white, weight: .semibold)
                }
                Spacer()

                VStack {
                    Text("RANK")
                        .font(size: 8, color: .hexStringToColor(hex: "BEBEBE"), weight: .light)
                    Text("3")
                        .font(size: 12, color: .white, weight: .semibold)
                }
                Spacer()

                VStack {
                    Text("RANK")
                        .font(size: 8, color: .hexStringToColor(hex: "BEBEBE"), weight: .light)
                    Text("3")
                        .font(size: 12, color: .white, weight: .semibold)
                }
            }
        }
    }
    
    var currentLabel: some View {
        
        Text("Current")
            .font(size: 16, color: "BEBEBE", weight: .medium)
        
    }
    
    var player: ParsedBatter {
        draft.currentTeam.recommendedPlayer(draft: draft, projection: model.draft.projectionCurrentlyUsing) ?? .nullBatter
    }

    

}

struct BoxForCurrentPickDVDraft_Previews: PreviewProvider {
    
    static let draft = Draft.exampleDraft(picksMade: 30, projection: .thebat)
    static var previews: some View {
        BoxForCurrentPickDVDraft()
            .environmentObject(MainModel.shared)
            
    }
}
