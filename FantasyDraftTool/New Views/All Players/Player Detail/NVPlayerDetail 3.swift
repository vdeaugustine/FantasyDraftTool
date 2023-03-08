//
//  NVPlayerDetail.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/14/23.
//

import Charts
import SwiftUI

// MARK: - NVPlayerDetail

struct NVPlayerDetail: View {
    let batter: ParsedBatter
    @State private var projectionSelected: ProjectionTypes = .steamer
    @State private var playerPosition: Position? = nil

    var thisBatter: ParsedBatter {
        AllExtendedBatters.batters(for: projectionSelected, limit: UserDefaults.positionLimit).first(where: { $0.name == batter.name })!
    }

    var top5Position: [ParsedBatter] {
        guard let position = playerPosition else { return [] }
        let batters: [ParsedBatter] = AllExtendedBatters.batters(for: projectionSelected, at: position, limit: UserDefaults.positionLimit)
        let sorted = batters.sortedByPoints(scoring: MainModel.shared.draft.settings.scoringSystem).prefixArray(5)
        return sorted
    }

    var top5Average: Double {
        let answer = ParsedBatter.averagePoints(forThese: top5Position, scoring: MainModel.shared.draft.settings.scoringSystem).roundTo(places: 2)
        return answer
    }

    var positionAverage: Double {
        guard let position = playerPosition else { return 0 }
        let batters = AllExtendedBatters.batters(for: projectionSelected, at: position, limit: UserDefaults.positionLimit)
        let answer = ParsedBatter.averagePoints(forThese: batters, scoring: MainModel.shared.draft.settings.scoringSystem).roundTo(places: 2)
        return answer
    }

    var top5HR: Double {
        guard let position = playerPosition else { return 0 }
        let batters = AllExtendedBatters.batters(for: projectionSelected, at: position, limit: UserDefaults.positionLimit)
        let sorted = batters.sorted(by: { $0.hr > $1.hr })
        let top5 = sorted.prefixArray(5)
        let sum: Double = top5.reduce(Double(0)) { $0 + Double($1.hr) }
        return sum / Double(top5.count)
    }

    var positionHR: Double {
        guard let position = playerPosition else { return 0 }
        let batters = AllExtendedBatters.batters(for: projectionSelected, at: position, limit: UserDefaults.positionLimit)
        let sum: Double = batters.reduce(Double(0)) { $0 + Double($1.hr) }
        return (sum / Double(batters.count)).roundTo(places: 1)
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                NVDropDownProjection(selection: $projectionSelected)
                NVDropDownPosition(selection: $playerPosition)

            }.padding()
            List {
                Section {
                    GroupBox("Fantasy Points") {
                        Chart {
                            BarMark(x: .value("Name", batter.name), y: .value("Points", thisBatter.fantasyPoints(MainModel.shared.scoringSettings)))
                                .annotation(position: .overlay) {
                                    Text(thisBatter.fantasyPoints(MainModel.shared.scoringSettings).str)
                                        .foregroundColor(.white)
                                }

                            BarMark(x: .value("Name", "Top 5 \(batter.posStr())"), y: .value("Points", top5Average))
                                .annotation(position: .overlay) {
                                    Text(top5Average.str)
                                        .foregroundColor(.white)
                                }

                            BarMark(x: .value("Name", "Avg \(batter.posStr())"), y: .value("Points", positionAverage))
                                .annotation(position: .overlay) {
                                    Text(positionAverage.str)
                                        .foregroundColor(.white)
                                }
                        }
                        .chartXAxis {
                            AxisMarks(position: .bottom) { _ in
                                AxisTick().foregroundStyle(.clear)
                                AxisValueLabel()
                            }
                        }
                        .chartYAxis {
                            AxisMarks(position: .trailing) { _ in
                                AxisTick().foregroundStyle(.clear)
                                AxisValueLabel()
                            }
                        }
                        .padding()
                    }
                    .listSectionSeparator(.hidden)
                }

                Section {
                    GroupBox("Home Runs") {
                        Chart {
                            BarMark(x: .value("Name", batter.name), y: .value("HR", thisBatter.hr))
                                .annotation(position: .overlay) {
                                    Text(thisBatter.hr.str)
                                        .foregroundColor(.white)
                                }

                            BarMark(x: .value("Name", "Top 5 \(batter.posStr())"), y: .value("HR", top5HR))
                                .annotation(position: .overlay) {
                                    Text(top5HR.str)
                                        .foregroundColor(.white)
                                }

                            BarMark(x: .value("Name", "Avg \(batter.posStr())"), y: .value("HR", positionHR))
                                .annotation(position: .overlay) {
                                    Text(positionHR.str)
                                        .foregroundColor(.white)
                                }
                        }
                        .chartXAxis {
                            AxisMarks(position: .bottom) { _ in
                                AxisTick().foregroundStyle(.clear)
                                AxisValueLabel()
                            }
                        }
                        .chartYAxis {
                            AxisMarks(position: .trailing) { _ in
                                AxisTick().foregroundStyle(.clear)
                                AxisValueLabel()
                            }
                        }
                        .padding()
                    }

                    .listSectionSeparator(.hidden)
                    .padding(.top)
                }

                Section {
                    GroupBox("Home Runs") {
                        RectPieChart(data: [Double(thisBatter.hr),
                                            top5HR,
                                            positionHR],
                                     labels: [batter.name,
                                              "Top 5 at \(thisBatter.posStr())",
                                              "Avg \(thisBatter.posStr()) HR"],
                                     colors: [.blue,
                                              .red,
                                              .green],
                                     height: 40)
                            .cornerRadius(5)
                    }
                }
            }
        }

        // MARK: - Start main modifiers

        .listStyle(.plain)
        .onAppear {
            playerPosition = batter.positions.first
        }
        .navigationTitle(batter.name + " • " + batter.team)
    }
}

// MARK: - NVPlayerDetail_Previews

struct NVPlayerDetail_Previews: PreviewProvider {
    static var previews: some View {
        NVPlayerDetail(batter: AllExtendedBatters.batters(for: .zips, at: .of, limit: UserDefaults.positionLimit)[0])
            .putInNavView()
    }
}
