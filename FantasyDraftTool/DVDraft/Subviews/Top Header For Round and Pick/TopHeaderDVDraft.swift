//
//  TopHeaderDVDraft.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/10/23.
//

import SwiftUI

struct TopHeaderDVDraft: View {
    let draft: Draft
    
    var body: some View {
        Text(["Round", draft.roundNumber.str +
              ",", "Pick", draft.roundPickNumber.str])
        .font(size: 28, color: .white, weight: .bold)
    }
}

struct TopHeaderDVDraft_Previews: PreviewProvider {
    static var previews: some View {
        TopHeaderDVDraft(draft: .exampleDraft(picksMade: 20, projection: .atc))
            .previewLayout(.sizeThatFits)
            .background {
                Color.hexStringToColor(hex: "33434F")
                    .ignoresSafeArea()
            }
    }
}
