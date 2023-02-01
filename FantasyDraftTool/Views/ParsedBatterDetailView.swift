//
//  ParsedBatterDetailView.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/26/23.
//

import Charts
import SwiftUI

// MARK: - ParsedBatterDetailView

struct ParsedBatterDetailView: View {
    @State var batter: ParsedBatter

    @State var projection: ProjectionTypes = .steamer

    var body: some View {
        List {
            Section("Select Projection") {
                SelectProjectionTypeHScroll(selectedProjectionType: $projection)
                    .onChange(of: projection, perform: { newProjection in
                        if let newBatter = AllParsedBatters.batters(for: newProjection).first(where: { $0.name == batter.name }) {
                            batter = newBatter
                        }
                    })
                    .pickerStyle(.segmented)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            }

            Section("My Stats") {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
                    ForEach(batter.relevantStatsKeys, id: \.self) { key in
                        if let val = batter.dict[key] as? Int {
                            StatRect(stat: key, value: val)
                        }
                    }
                    StatRect(stat: "Points", value: batter.fantasyPoints(.defaultPoints))
                }
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)

            ForEach(batter.positions, id: \.self) { position in

                Section("Average for \(position.str.uppercased()) based on \(projection.title)") {
                    LazyVGrid(columns: (0 ... 4).map { _ in GridItem(.flexible()) }) {
                        ForEach(AverageStats.arr) { stat in
                            StatRect(stat: stat.str, value: AverageStats.average(stat: stat, for: position, projectionType: projection))
                        }
                        StatRect(stat: "Points", value: ParsedBatter.averagePoints(forThese: AllParsedBatters.batters(for: projection).filter { $0.positions.contains(position) }))
                    }
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }

            Section {
                Chart {
                    BarMark(x: .value("Batter", batter.name),
                            y: .value("Fantasy Points", batter.fantasyPoints(.defaultPoints)))

                    ForEach(batter.positions, id: \.self) { position in
                        BarMark(x: .value(position.str.uppercased(),
                                          "Average " + position.str.uppercased()),
                                y: .value("Fantasy Points",
                                          ParsedBatter.averagePoints(forThese: AllParsedBatters.batters(for: projection).filter { $0.positions.contains(position) })))
                    }
                }
                .padding()
            }
            Spacer()
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
        }

        .listStyle(.plain)
        .navigationTitle(batter.name)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.listBackground)
    }
}



struct StatRect: View {
    let stat: String
    let value: Int

    init(stat: String, value: Int) {
        self.stat = stat
        self.value = value
    }

    init(stat: String, value: Double) {
        self.stat = stat
        self.value = Int(value.roundTo(places: 1))
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 1)
            VStack {
                Text(stat)
                Text(value.str)
                    .fontWeight(.semibold)
            }
            .padding(4)
        }
    }
}

// MARK: - ParsedBatterDetailView_Previews

struct ParsedBatterDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ParsedBatterDetailView(batter: AllParsedBatters.theBat.all.first(where: { $0.name == "Luis Arraez" })!)
            .putInNavView()
    }
}
