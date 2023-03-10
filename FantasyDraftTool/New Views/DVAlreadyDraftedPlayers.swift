//
//  DVAlreadyDraftedPlayers.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/9/23.
//

import SwiftUI

// MARK: - DVAlreadyDraftedPlayers

struct DVAlreadyDraftedPlayers: View {
    @EnvironmentObject private var model: MainModel

    @State private var showAmount: Int = 3
    var body: some View {
        VStack {
            VStack(spacing: 15) {
                Text(["Drafted"])
                    .font(size: 20, color: .white, weight: .medium)
            }

            VStack {
                ForEach(model.draft.pickStack.getArray().prefixArray(showAmount), id: \.self) { player in
                    DVAlreadyDraftedPlayerRow(player: player)
                }
            }
            
            Button {
                showAmount += 3
            } label: {
                Label("Show more", systemImage: "plus")
            }
        }
    }
}

// MARK: - DVAlreadyDraftedPlayers_Previews

struct DVAlreadyDraftedPlayers_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.hexStringToColor(hex: "33434F")
            ScrollView {
                DVAlreadyDraftedPlayers()
                    .environmentObject(MainModel.shared)
            }
        }
    }
}
