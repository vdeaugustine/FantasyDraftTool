//
//  ParsedBatterDetailView.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/26/23.
//

import SwiftUI

// MARK: - ParsedBatterDetailView

struct ParsedBatterDetailView: View {
    @State var batter: ParsedBatter

    @State var projection: ProjectionTypes = .steamer

    var body: some View {
        List {
            Picker("Projection", selection: $projection) {
                ForEach(ProjectionTypes.arr, id: \.self) { proj in
                    Text(proj.title)
                }
            }
            .onChange(of: projection, perform: { newProjection in
                if let newBatter = AllParsedBatters.batters(for: newProjection).first(where: { $0.name == batter.name }) {
                    batter = newBatter
                }
            })
            .pickerStyle(.segmented)
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)

            Section("My Stats") {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
                    ForEach(batter.relevantStatsKeys, id: \.self) { key in
                        if let val = batter.dict[key] as? Int {
                            StatRect(stat: key, value: val)
                        }
                    }
                }
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)

            ForEach(batter.positions, id: \.self) { position in

                Section("Average for \(position.str.uppercased())") {
                    LazyVGrid(columns: (0 ... 4).map { _ in GridItem(.flexible()) }) {
                        ForEach(AverageStats.arr) { stat in
                            StatRect(stat: stat.str, value: AverageStats.average(stat: stat, for: position, projectionType: projection))
                        }
                    }
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
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

extension ParsedBatterDetailView {
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
}

// MARK: - ParsedBatterDetailView_Previews

struct ParsedBatterDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ParsedBatterDetailView(batter: AllParsedBatters.theBat.all.first(where: { $0.name == "Luis Arraez" })!)
            .putInNavView()
    }
}
