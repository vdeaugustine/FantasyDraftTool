//
//  PositionAnalysisView.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/30/23.
//

import Charts
import SwiftUI

// MARK: - PositionAnalysisView

struct PositionAnalysisView: View {
    @State var position: Position = .of
    @State var projectionType: ProjectionTypes = .steamer
    var batters: [ParsedBatter] {
        AllExtendedBatters.batters(for: projectionType, at: position, limit: UserDefaults.positionLimit)
    }
    var allBatters: [ParsedBatter] {
        AllExtendedBatters.batters(for: projectionType, limit: UserDefaults.positionLimit)
    }
    

    var body: some View {
        VStack {
            
            List {
                
                Section {
                    SelectProjectionTypeHScroll(selectedProjectionType: $projectionType)
                    SelectSinglePositionTypeHScroll(selectedPosition: $position)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                
//                Text("Average Fantasy Points")
//                    .spacedOut(text: ParsedBatter.averagePoints(forThese: batters, scoring: <#ScoringSettings#>).str)

//                Section {
//                    Chart {
//                        ForEach(Position.batters, id: \.self) { thisPosition in
//                            BarMark(x: .value("Position", thisPosition.str.uppercased()),
//                                    y: .value("Average Fantasy Points", ParsedBatter.averagePoints(forThese: AllExtendedBatters.batters(for: projectionType, limit: UserDefaults.positionLimit).filter { $0.positions.contains(thisPosition) }, scoring: <#ScoringSettings#>)))
//                            .foregroundStyle(thisPosition == position ? .red : .blue)
//                        }
//
//                    }
//                    .padding()
//                }
            }
        }
    }
}

// MARK: - PositionAnalysisView_Previews

struct PositionAnalysisView_Previews: PreviewProvider {
    static var previews: some View {
        PositionAnalysisView()
    }
}
