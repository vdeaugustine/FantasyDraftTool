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
    @State private var myPlayer: MyStatsPlayer = MyStatsPlayer(player: .nullBatter)
    @EnvironmentObject private var model: MainModel
    @State private var modifyValueAlert: Bool = false
    @State private var modifiedValue = ""
    @State private var keyToModify = ""

    var body: some View {
        List {
            Section("Select Projection") {
                SelectProjectionTypeHScroll(selectedProjectionType: $projection)
                    .onChange(of: projection, perform: { newProjection in
                        batter = AllParsedBatters.batters(for: newProjection).first(where: {$0.name == batter.name})!
                        if let newBatter = AllParsedBatters.batters(for: newProjection).first(where: { $0.name == batter.name }) {
                            batter = newBatter
                        } else if newProjection == ProjectionTypes.myProjections {
                            guard let defaultBatter = AllParsedBatters.batters(for: model.defaultProjectionSystem).first(where: { $0 == batter }) else {
                                return
                            }
                            batter = defaultBatter
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
                                .onTapGesture {
                                    modifyValueAlert = true
                                    keyToModify = key
                                    
                                }
                        }
                    }
                    StatRect(stat: "Points", value: batter.fantasyPoints(MainModel.shared.getScoringSettings()))
                    
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
                            y: .value("Fantasy Points", batter.fantasyPoints(MainModel.shared.getScoringSettings())))

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
        .onAppear {
            myPlayer = MyStatsPlayer(player: batter)
        }
        
        .alert("Edit \(keyToModify)", isPresented: $modifyValueAlert) {
            if let stat = batter.dict[keyToModify] as? Int {
                TextField("Stat", text: $modifiedValue, prompt: Text(stat.str))
            }
            
            Button("Save", role: .destructive) {
                if let int = Int(modifiedValue) {
                    batter.edit(keyToModify, with: int)
                }
                keyToModify = ""
                modifyValueAlert = false
                modifiedValue = ""
            }
            
            Button("Cancel", role: .cancel) {
                keyToModify = ""
                modifyValueAlert = false
                modifiedValue = ""
            }
        }
        
    }
}

// MARK: - StatRect

struct StatRect: View {
    let stat: String
    let value: Int

    init(stat: String, value: Int) {
        self.stat = stat
        self.value = value
    }

    init(stat: String, value: Double) {
        self.stat = stat
        guard value.isFinite && !value.isNaN else {
            self.value = 0
            return
        }
        self.value = Int(value.roundTo(places: 1))
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 1)
            VStack {
                Text(stat)
                    .font(.caption2)
                Text(value.str)
                    .fontWeight(.semibold)
                    .font(.caption)
            }
            .padding(4)
        }
    }
}

// MARK: - ParsedBatterDetailView_Previews

struct ParsedBatterDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ParsedBatterDetailView(batter: AllParsedBatters.theBat.all[3])
            .environmentObject(MainModel.shared)
            .putInNavView()
    }
}
