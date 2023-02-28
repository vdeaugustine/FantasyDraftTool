//
//  MyTeamQuickView.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/18/23.
//

import SwiftUI

// MARK: - MyTeamQuickView

struct NVMyTeamQuickView: View {
    @EnvironmentObject private var model: MainModel

    var body: some View {
        List {
//            if let myTeam = model.draft.myTeam {
            ForEach(Position.batters.corOrder, id: \.self) { pos in
                Section(pos.str.uppercased()) {
                    if let myTeam = model.draft.myTeam,
                       let filteredPlayers = myTeam.draftedPlayers.filter(for: pos),
                       filteredPlayers.isEmpty == false {
                        
                        ForEach(filteredPlayers, id: \.self) { player in
                            Text(player)
                        }

                    } else {
                        Text("None drafted yet")
                    }
                }
            }
//            }
        }
        .navigationTitle("My Team")
    }
}

// MARK: - MyTeamQuickView_Previews

struct MyTeamQuickView_Previews: PreviewProvider {
    static var previews: some View {
        NVMyTeamQuickView()
            .environmentObject(MainModel.shared)
            .putInNavView()
    }
}
