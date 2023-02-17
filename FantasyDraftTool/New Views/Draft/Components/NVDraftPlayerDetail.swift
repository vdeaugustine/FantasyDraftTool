//
//  NVDraftPlayerDetail.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/15/23.
//

import SwiftUI

// MARK: - NVDraftPlayerDetail

struct NVDraftPlayerDetail: View {
    @EnvironmentObject private var model: MainModel

    let batter: ParsedBatter
    @State private var projection: ProjectionTypes = .steamer

    @State private var position: Position? = nil

    var numPicksTill: Int {
        let batters = model.draft.playerPool.batters.sorted(by: { $0.zScore() > $1.zScore() })

        guard let ind = batters.firstIndex(where: { $0.name == batter.name }) else { return 0 }

        return ind + 1
    }

    func plusMinusStr(statKey: String, batterNum: Int) -> String? {
        guard let position = position
        else { return nil }
        let positionAverage = Int(AverageStats.average(for: statKey, for: position, and: projection).roundTo(places: 0))

        return (batterNum - positionAverage).str
    }

    var body: some View {
        List {
            HStack(spacing: 20) {
                NVDropDownProjection(selection: $projection)

                Spacer()
                if let position = position,
                   let rank = model.draft.playerPool.positionRank(for: batter, at: position) {
                    Text("#\(rank) \(position.str.uppercased())")
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                }
                Text("\(batter.fantasyPoints(model.draft.settings.scoringSystem).str) pts")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
            }
            .listSectionSeparator(.hidden)
            .listRowSeparator(.hidden)

            Section {
                Text("\(numPicksTill.withSuffix) best player left in pool")
            }

            if let position = position {
                Section {
                    Text("\(model.draft.teams.filter { $0.positionsEmpty.contains(position) }.count) teams still need to fill this position")
                }
            }

            LazyVGrid(columns: GridItem.fixedItems(5, size: 70)) {
                ForEach(batter.relevantStatsKeys, id: \.self) { statKey in

                    if let stat = batter.dict[statKey] as? Int,
                       let position = position {
                        VStack {
                            Text(statKey)
                            Text(stat.str)
                            if let plusMinus = plusMinusStr(statKey: statKey, batterNum: stat) {
                                Text(plusMinus)
                            }
                        }
                        .padding(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10).stroke()
                        }
                    }
                }
            }
        }
        .listStyle(.plain)

        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    model.draft.addOrRemoveStar(batter)
                } label: {
                    Label("Star Player", systemImage: model.draft.isStar(batter) ? "diamond.fill" : "diamond")
                }

                Button("Draft") {
                }
            }
        }
        .navigationTitle(batter.name + " • " + batter.team)
        .onAppear {
            position = batter.positions.first
        }
    }
}

// MARK: - NVDraftPlayerDetail_Previews

struct NVDraftPlayerDetail_Previews: PreviewProvider {
    static var previews: some View {
        NVDraftPlayerDetail(batter: AllParsedBatters.batters(for: .zips, at: .of)[25])
            .environmentObject(MainModel.shared)
            .putInNavView()
    }
}
