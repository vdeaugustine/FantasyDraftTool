//
//  BoxForPicksDVDraft.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/10/23.
//

import SwiftUI

// MARK: - BoxForPastPicksDVDraft

struct BoxForPastPicksDVDraft: View {
    let draftPlayer: DraftPlayer

    var teamNameAndDraftPickNumber: some View {
        VStack {
            Text("#\(draftPlayer.pickNumber)")
                .font(size: 16, color: MainModel.shared.specificColor.lighter, weight: .light)
            if let team = draftPlayer.draftedTeam {
                Text("\(team.name)")
                    .font(size: 16, color: MainModel.shared.specificColor.lighter, weight: .bold)
            }
        }
    }

    var boxPart: some View {
        VStack(spacing: 12) {
            
            VStack(alignment: .leading) {
                Text(getName.firstName)
                    .font(size: 16, color: .white, weight: .medium)
                Text(getName.lastName)
                    .font(size: 16, color: .white, weight: .medium)
                Text(draftPlayer.player.team)
                    .font(size: 8, color: .white, weight: .ultraLight)
            }.pushLeft()
            

            HStack {
                VStack {
                    Text("RANK")
                        .font(size: 8, color: MainModel.shared.specificColor.lighter, weight: .light)
                    Text("3")
                        .font(size: 12, color: .white, weight: .semibold)
                }
                Spacer()

                VStack {
                    Text("RANK")
                        .font(size: 8, color: MainModel.shared.specificColor.lighter, weight: .light)
                    Text("3")
                        .font(size: 12, color: .white, weight: .semibold)
                }
                Spacer()

                VStack {
                    Text("RANK")
                        .font(size: 8, color: MainModel.shared.specificColor.lighter, weight: .light)
                    Text("3")
                        .font(size: 12, color: .white, weight: .semibold)
                }
            }
        }
    }
    
    var recentLabel: some View {
        
        Text("Recent")
            .font(size: 16, color: MainModel.shared.specificColor.lighter, weight: .medium)
        
    }
    var getName: (firstName: String, lastName: String) {
        let full = draftPlayer.player.name.components(separatedBy: .whitespaces)
        let first = full.safeGet(at: 0) ?? ""
        let second = full.safeGet(at: 1) ?? ""
        let suffix = full.safeGet(at: 2) ?? ""
        let last = [second, suffix].joinString(" ")
        return (firstName: first, lastName: last)
    }

    var body: some View {
        VStack {
            teamNameAndDraftPickNumber
            boxPart
                .background(color: MainModel.shared.specificColor.rect, padding: 10, radius: 7, shadow: 1)
                .frame(width: 125, height: 88)
            recentLabel
                .padding(.top, 2)
        }
    }
}

// MARK: - BoxForPastPicksDVDraft_Previews

struct BoxForPastPicksDVDraft_Previews: PreviewProvider {
    static var previews: some View {
        BoxForPastPicksDVDraft(draftPlayer: .TroutOrNull)
            .background {
                #if DEBUG
                    Color.backgroundBlue
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea()
                #endif
            }
    }
}
