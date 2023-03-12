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
                .font(size: 16, color: .hexStringToColor(hex: "BEBEBE"), weight: .light)
            if let team = draftPlayer.draftedTeam {
                Text("\(team.name)")
                    .font(size: 16, color: .hexStringToColor(hex: "BEBEBE"), weight: .bold)
            }
        }
    }

    var boxPart: some View {
        VStack(spacing: 12) {
            VStack(alignment: .leading) {
                Text(draftPlayer.player.name)
                    .font(size: 16, color: .white, weight: .medium)
                Text(draftPlayer.player.team)
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
    
    var recentLabel: some View {
        
        Text("Recent")
            .font(size: 16, color: "BEBEBE", weight: .medium)
        
    }

    var body: some View {
        VStack {
            teamNameAndDraftPickNumber
            boxPart
                .background(color: "4A555E", padding: 10, radius: 7, shadow: 1)
                .frame(width: 125, height: 88)
            recentLabel
        }
    }
}

// MARK: - BoxForPastPicksDVDraft_Previews

struct BoxForPastPicksDVDraft_Previews: PreviewProvider {
    static var previews: some View {
        BoxForPastPicksDVDraft(draftPlayer: .TroutOrNull)
            .background {
                #if DEBUG
                    Color.hexStringToColor(hex: "33434F")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea()
                #endif
            }
    }
}
