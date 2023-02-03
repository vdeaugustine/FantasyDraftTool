//
//  StrongestAtEachPositionView.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/3/23.
//

import Charts
import SwiftUI

// MARK: - StrongestAtEachPositionViewSideBySide

struct StrongestAtEachPositionViewSideBySide: View {
    @EnvironmentObject private var model: MainModel

    enum leagueOrTeam: String {
        case league
        case team
    }

    var body: some View {
        VStack {
            Text("Strongest Team by Position")
                .font(.callout)
                .foregroundStyle(.secondary)

            Chart {
                ForEach(Position.batters, id: \.self) { pos in
                    BarMark(x: .value("Points",
                                      model.draft.strongestTeam(for: pos).points(for: pos)),
                            y: .value("Position and Team",
                                      "\(pos.str.uppercased())"))
                        .position(by: .value("team", leagueOrTeam.team.rawValue))

                        .annotation(position: .trailing, alignment: .center) {
                            Text(model.draft.strongestTeam(for: pos).name)
                                .font(.caption2)
                        }
                        .annotation(position: .overlay, alignment: .center) {
                            Text(model.draft.strongestTeam(for: pos).points(for: pos).str)
                                .font(.caption2)
                                .foregroundColor(.white)
                        }

                    BarMark(x: .value("Points",
                                      model.draft.leagueAverage(for: pos)),
                            y: .value("Position and Team",
                                      "\(pos.str.uppercased())"))
                        .position(by: .value("team", leagueOrTeam.league.rawValue))

                        .annotation(position: .trailing, alignment: .center) {
                            Text("League Average")
                                .font(.caption2)
                        }
                        .annotation(position: .overlay, alignment: .center) {
                            Text(model.draft.leagueAverage(for: pos).str)
                                .font(.caption2)
                                .foregroundColor(.white)
                        }
                        .foregroundStyle(Color.red)
                }
            }
            .chartForegroundStyleScale(["League Average": Color.red,
                                        "Position and Team": Color.green])
            .chartXAxis {
                AxisMarks(position: .bottom) { _ in
                    // AxisGridLine().foregroundStyle(.clear)
                    AxisTick().foregroundStyle(.clear)
                    AxisValueLabel()
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { _ in
                    // AxisGridLine().foregroundStyle(.clear)
                    AxisTick().foregroundStyle(.clear)
                    AxisValueLabel()
                }
            }
        }
    }
}

// MARK: - StrongestAtEachPositionView

struct StrongestAtEachPositionView: View {
    @EnvironmentObject private var model: MainModel

    var body: some View {
        VStack {
            Text("Strongest Team by Position")
                .font(.callout)
                .foregroundStyle(.secondary)

            Chart {
                ForEach(Position.batters, id: \.self) { pos in
                    BarMark(x: .value("Position and Team",
                                      "\(pos.str.uppercased())"),
                            y: .value("Points",
                                      model.draft.strongestTeam(for: pos).points(for: pos)))

                        .annotation(position: .overlay, alignment: .center) {
                            VStack {
                                Text(model.draft.strongestTeam(for: pos).name)
                                    .fontWeight(.bold)
                                Text(model.draft.strongestTeam(for: pos).points(for: pos).str)
                            }
                            .font(.caption2)
                            .foregroundColor(.white)
                        }

                    BarMark(x: .value("Position and Team",
                                      "\(pos.str.uppercased())"),
                            y: .value("Points",
                                      model.draft.leagueAverage(for: pos)))

                        .annotation(position: .overlay, alignment: .center) {
                            VStack {
                                Text("League")
                                    .fontWeight(.bold)
                                Text(model.draft.leagueAverage(for: pos).str)
                            }
                            .font(.caption2)
                            .foregroundColor(.white)
                        }
                        .foregroundStyle(Color.red)
                }
            }
            .chartForegroundStyleScale(["Rest of the League Average": Color.red,
                                        "Strongest Team's Average": Color.blue])

            .chartXAxis {
                AxisMarks(position: .bottom) { _ in
                    // AxisGridLine().foregroundStyle(.clear)
                    AxisTick().foregroundStyle(.clear)
                    AxisValueLabel()
                }
            }
            .chartYAxis {
                AxisMarks(position: .bottom) { _ in
                    // AxisGridLine().foregroundStyle(.clear)
//                    AxisTick().foregroundStyle(.clear)
//                    AxisValueLabel()
                }
            }
        }
    }
}

// MARK: - StrongestAtEachPositionView_Previews

struct StrongestAtEachPositionView_Previews: PreviewProvider {
    static var previews: some View {
        StrongestAtEachPositionView()
            .environmentObject(MainModel.shared)
    }
}
