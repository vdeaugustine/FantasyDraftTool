//
//  RecommendedPlayerView.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/3/23.
//

import SwiftUI
import Charts

//struct RecommendedPlayerView: View {
//    @EnvironmentObject private var model: MainModel
//    
//    let bestPick: BestPick
//    var numberOnePlayer: ParsedBatter { bestPick.topPlayer }
//    var nextBestOption: ParsedBatter? {
//        bestPick.draftState.playerPool.batters(for: numberOnePlayer.positions, projection: model.draft.projectionCurrentlyUsing, draft: model.draft).first
//    }
//    var body: some View {
//        List {
//            Section {
//                Text(numberOnePlayer.name)
//                    .font(.largeTitle)
//                    .fontWeight(.heavy)
//            }.listRowSeparator(.hidden)
//            
//            
//            Text("Positions " + numberOnePlayer.posStr())
//            Text("\(numberOnePlayer.fantasyPoints(model.scoringSettings).roundTo(places: 1).str) projected points")
//            
//            ForEach(numberOnePlayer.positions, id: \.self) { pos in
////                if let average = bestPick.draftState.playerPool.positionAveragesDict[pos] {
////                    Text(pos.str.uppercased() + " average points = " + average.roundTo(places: 1).str)
////                }
//                
//            }
//        }
//        
//        .listStyle(.plain)
//        .navigationTitle("Recommendation")
//        .navigationBarTitleDisplayMode(.inline)
//    }
//}

//struct RecommendedPlayerView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecommendedPlayerView(bestPick: .init(draftState: MainModel.shared.draft))
//            .environmentObject(MainModel.shared)
//            .putInNavView()
//    }
//}
