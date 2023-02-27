//
//  LoadingDraft.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/19/23.
//

import SwiftUI

// MARK: - LoadingDraft

struct LoadingDraft: View {
    @EnvironmentObject private var model: MainModel
    @Binding var progress: Double

    var body: some View {
        VStack {
            ProgressView("Loading draft", value: progress, total: 1)

//            GeometryReader { geo in
//                HStack(spacing: 0) {
//                    // loaded
//                    Rectangle()
//                        .fill(Color.blue)
//                        .frame(width: geo.size.width * model.draftLoadProgress)
//                    // not loaded
//                    Rectangle()
//                        .fill(Color.gray)
//                }
//            }
//            .frame(height: 10)
//            .padding()
        }
        
    }
}

// MARK: - LoadingDraft_Previews

struct LoadingDraft_Previews: PreviewProvider {
    static var previews: some View {
        LoadingDraft(progress: .constant(0.5))
            .environmentObject(MainModel.shared)
    }
}
