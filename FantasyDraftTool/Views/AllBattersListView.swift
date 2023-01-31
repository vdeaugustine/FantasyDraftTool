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
    @State private var selectedPositions: Set<Positions> = []

    var batters: [ParsedBatter] {
        if selectedPositions.isEmpty {
            return AllParsedBatters.batters(for: projection).removingDuplicates().sorted(by: { $0.fantasyPoints(.defaultPoints) > $1.fantasyPoints(.defaultPoints) })
        }

        return selectedPositions.reduce([ParsedBatter]()) { partialResult, pos in
            partialResult + AllParsedBatters.batters(for: projection, at: pos)
        }
        .removingDuplicates()
        .sorted(by: { $0.fantasyPoints(.defaultPoints) > $1.fantasyPoints(.defaultPoints) })
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
                            .spacedOut(text: batter.fantasyPoints(.defaultPoints).str)
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