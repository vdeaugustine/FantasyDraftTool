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
    @EnvironmentObject private var viewModel: DVDraftViewModel
    
    
    var body: some View {
        VStack(spacing: 15){
            HStack {
                Text("Rankings")
                    .font(size: 16, color: MainModel.shared.specificColor.lighter, weight: .medium)
                Spacer()
                
                NVDropDownProjection(selection: $projection, font: viewModel.dropDownFont)
            }
            
            AllTeamsStatRankingWithDropDown(showDropDown: $showDropDown, draft: model.draft)
        }
    }
}

struct DVDraftRankings_Previews: PreviewProvider {
    static var previews: some View {
        DVDraftRankings(projection: .constant(.depthCharts))
            .environmentObject(MainModel.shared)
            .environmentObject(DVDraftViewModel.init())
            
    }
}
