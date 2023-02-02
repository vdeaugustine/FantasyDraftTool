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
        AllParsedBatters.batters(for: projectionType, at: position)
    }
    var allBatters: [ParsedBatter] {
        AllParsedBatters.batters(for: projectionType)
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
                
                Text("Average Fantasy Points")
                    .spacedOut(text: ParsedBatter.averagePoints(forThese: batters).str)

                Section {
                    Chart {
                        ForEach(Position.batters, id: \.self) { thisPosition in
                            BarMark(x: .value("Position", thisPosition.str.uppercased()),
                                    y: .value("Average Fantasy Points", ParsedBatter.averagePoints(forThese: AllParsedBatters.batters(for: projectionType).filter { $0.positions.contains(thisPosition) })))
                            .foregroundStyle(thisPosition == position ? .red : .blue)
                        }

                    }
                    .padding()
                }
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
