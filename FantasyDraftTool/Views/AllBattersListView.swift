//
//  ContentView.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/26/23.
//

import SwiftUI

// MARK: - AllBattersListView

struct AllBattersListView: View {
    @State private var projection: ProjectionTypes = .steamer
    @State private var selectedPositions: Set<Position> = []

    var batters: [ParsedBatter] {
        if selectedPositions.isEmpty {
            return AllExtendedBatters.batters(for: projection).removingDuplicates().sorted(by: { $0.fantasyPoints(MainModel.shared.getScoringSettings()) > $1.fantasyPoints(MainModel.shared.getScoringSettings()) })
        }

        return selectedPositions.reduce([ParsedBatter]()) { partialResult, pos in
            partialResult + AllExtendedBatters.batters(for: projection, at: pos)
        }
        .removingDuplicates()
        .sorted(by: { $0.fantasyPoints(MainModel.shared.getScoringSettings()) > $1.fantasyPoints(MainModel.shared.getScoringSettings()) })
    }

    var body: some View {
        VStack {
            SelectProjectionTypeHScroll(selectedProjectionType: $projection)

            SelectPositionsHScroll(selectedPositions: $selectedPositions)

            List {
                ForEach(batters, id: \.self) { batter in

                    NavigationLink {
                        ParsedBatterDetailView(batter: batter, projection: projection)
                    } label: {
                        Text(batter.name)
                            .spacedOut(text: batter.fantasyPoints(MainModel.shared.getScoringSettings()).str)
                    }
                }
            }
        }
        .background(Color.listBackground)
    }
}

// MARK: - AllBattersListView_Previews

struct AllBattersListView_Previews: PreviewProvider {
    static var previews: some View {
        AllBattersListView()
            .putInNavView()
    }
}
