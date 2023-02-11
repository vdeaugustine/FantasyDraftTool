//
//  SimulateRemainingDraftView.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/9/23.
//

import SwiftUI

struct SimulateRemainingDraftView: View {
    @EnvironmentObject private var model: MainModel
    
    @State private var stack: Stack<DraftPlayer> = .init()
    @State private var showSpinning: Double = 0.0
    
    var body: some View {
        ZStack {
            List {
                Text(showSpinning.str)
                Section("All drafted") {
                    
                    ForEach(stack.getArray(), id: \.self) { player in
                        Text("#\(player.pickNumber) " + " \(player.draftedTeam?.name ?? ""): " + player.player.name)
                    }
                }
                
                Button("Go") {
                    stack = model.draft.simulateRemainingDraft()
                }
               
            }
            
//                ProgressView(value: showSpinning)
//                .progressViewStyle(CircularProgressViewStyle())
            
        }
        
        
    }
}

struct SimulateRemainingDraftView_Previews: PreviewProvider {
    static var previews: some View {
        SimulateRemainingDraftView()
            .environmentObject(MainModel.shared)
            .putInNavView(displayMode: .inline)
    }
}
