//
//  NVAllPlayers.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/14/23.
//

import SwiftUI

// MARK: - NVAllPlayers

struct NVAllPlayers: View {
    @EnvironmentObject private var model: MainModel
    @State private var projectionSelected: ProjectionTypes = .steamer
    @State private var positionSelected: Position? = nil
    @State private var sortOptionSelected: NVSortByDropDown.Options = .score
    @State private var showOnlyUtil: Bool = false

    var filteredPlayers: [ParsedBatter] {
        if let positionSelected = positionSelected {
            return AllExtendedBatters.batters(for: projectionSelected, limit: UserDefaults.positionLimit)
                .filter {
                    $0.positions.contains(positionSelected)
                }
        }

        return AllExtendedBatters.batters(for: projectionSelected, limit: UserDefaults.positionLimit)
    }

    var sortedPlayers: [ParsedBatter] {
        switch sortOptionSelected {
            case .points:
                return filteredPlayers.sorted { $0.fantasyPoints(model.scoringSettings) > $1.fantasyPoints(model.scoringSettings) }
            case .score:
                return filteredPlayers.sortedByZscore(draft: model.draft)
            case .hr:
                return filteredPlayers.sorted { $0.hr > $1.hr }
            case .rbi:
                return filteredPlayers.sorted { $0.rbi > $1.rbi }
            case .r:
                return filteredPlayers.sorted { $0.r > $1.r }
            case .sb:
                return filteredPlayers.sorted { $0.sb > $1.sb }
        }
    }

    var filterUtility: [ParsedBatter] {
        if showOnlyUtil {
            return sortedPlayers.filter { $0.positions.count > 1 }
        }
        return sortedPlayers
    }

    var utilityButton: some View {
        Button {
            showOnlyUtil.toggle()
        } label: {
            HStack {
                Text("UTIL")
                    .fontWeight(.semibold)

                Image(systemName: "person.and.arrow.left.and.arrow.right")
            }
            .font(.callout)
            .padding(7)
            .conditionalModifier(showOnlyUtil) {
                $0.foregroundColor(.white)
            }

            .conditionalModifier(showOnlyUtil) {
                $0.background {
                    Color.blue
                }
                .cornerRadius(10)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 1)
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                NVDropDownProjection(selection: $projectionSelected)
                NVDropDownPosition(selection: $positionSelected)
                NVSortByDropDown(selection: $sortOptionSelected)
            }
            .padding([.leading])
            ScrollView {
                LazyVStack {
                    ForEach(filterUtility) { player in

                        NavigationLink {
                            DVBatterDetail(player: player)

                        } label: {
                            DVAllPlayersRow(player: player)
                        }.buttonStyle(.plain)
                            .padding(.horizontal)
                    }
                }
            }

//            .listRowInsets(EdgeInsets(top: -5, leading: 0, bottom: -100, trailing: 0))
            .background {
                MainModel.shared.specificColor.background
                    .ignoresSafeArea()
            }
        }
        .listStyle(.plain)
        .navigationTitle("Players")
        .background {
            MainModel.shared.specificColor.background
                .ignoresSafeArea()
        }
    }
}

// MARK: - NVAllPlayers_Previews

struct NVAllPlayers_Previews: PreviewProvider {
    static var previews: some View {
        NVAllPlayers()
            .environmentObject(MainModel.shared)
            .putInNavView()
    }
}
