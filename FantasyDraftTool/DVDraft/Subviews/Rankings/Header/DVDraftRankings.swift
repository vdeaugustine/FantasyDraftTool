//
//  DVDraftRankings.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/12/23.
//

import SwiftUI



struct DVDraftRankings: View {
    @Binding var projection: ProjectionTypes
    @State private var showDropDown = false
    @EnvironmentObject private var model: MainModel
    
    var body: some View {
        VStack(spacing: 15){
            HStack {
                Text("Rankings")
                    .font(size: 16, color: "BEBEBE", weight: .medium)
                Spacer()
                
                NVDropDownProjection(selection: $projection, font: .system(size: 10))
            }
            
            AllTeamsStatRankingWithDropDown(showDropDown: $showDropDown, draft: model.draft)
        }
    }
}

struct DVDraftRankings_Previews: PreviewProvider {
    static var previews: some View {
        DVDraftRankings(projection: .constant(.depthCharts))
            .environmentObject(MainModel.shared)
            
    }
}
