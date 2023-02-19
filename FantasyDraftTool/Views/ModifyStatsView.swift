//
//  ModifyStatsView.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/10/23.
//

import SwiftUI

struct ModifyStatsView: View {
    @EnvironmentObject private var model: MainModel
    
    let batter: ParsedBatter
    @State private var myParsedBatter: ParsedBatter = .nullBatter
    
    var body: some View {
        List {
            ForEach(myParsedBatter.relevantStatsKeys, id: \.self) { key in
                Section(key) {
                    rowForStat(key)
                    
                }
            }
        }
        .navigationTitle(myParsedBatter.name)
            .onAppear {
                if let foundBatter = model.myModifiedBatters.first(where: {$0 == batter}) {
                    myParsedBatter = foundBatter
                } else {
                    myParsedBatter = batter
                }
                
            }
    }
    
    func rowForStat(_ stat: String) -> some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(ProjectionTypes.arr.indices, id: \.self) { thisProjIndex in
                    VStack {
                        Text( ProjectionTypes.arr[thisProjIndex].title)
                        
                        if let val = AllExtendedBatters.batterVariants(for: myParsedBatter)[thisProjIndex].dict[stat] as? Double {
                            Text(val.str)
                        } else if let val = AllExtendedBatters.batterVariants(for: myParsedBatter)[thisProjIndex].dict[stat] as? Int {
                            Text(val.str)
                        }
                        
                        
                    }
                    .font(.caption)
                    
                }
                
            }
        }
        
    }
}



struct ModifyStatsView_Previews: PreviewProvider {
    static var previews: some View {
        ModifyStatsView(batter: AllExtendedBatters.atc.firstBase.first!)
            .environmentObject(MainModel.shared)
            .putInNavView(displayMode: .inline)
    }
}
