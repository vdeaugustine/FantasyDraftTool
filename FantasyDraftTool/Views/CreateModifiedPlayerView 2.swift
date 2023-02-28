//
//  CreateModifiedPlayerView.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/13/23.
//

import SwiftUI

// MARK: - CreateModifiedPlayerView

struct CreateModifiedPlayerView: View {
    @EnvironmentObject private var model: MainModel
//    @State private var modifiedBatter: ParsedBatter = .nullBatter
//    @State private var keyToModify: String = ""

    let batter: ParsedBatter

    @State private var pa: Int = 500
    @State private var hr: Int = 10
    @State private var rbi: Int = 70
    @State private var r: Int = 70
    @State private var h: Int = 150
    @State private var doubles: Int = 20
    @State private var triples: Int = 2
    @State private var bb: Int = 50
    var singles: Int {
        h - doubles - triples - hr
    }

    @State private var sb: Int = 10
    @State private var hbp: Int = 5
    @State private var cs: Int = 2
    @State private var g: Int = 150
    @State private var k: Int = 100

    @Environment(\.dismiss) private var dismiss

//    var tempBatter: ParsedBatter {
//        ParsedBatter(empty: "", name: batter.name, team: batter.team, g: g, ab: batter.ab, pa: pa, h: h, the1B: singles, the2B: doubles, the3B: triples, hr: hr, r: r, rbi: rbi, bb: bb, ibb: 0, so: k, hbp: hbp, sf: 0, sh: 0, sb: sb, cs: cs, avg: 0, positions: [], projectionType: .myProjections)
//    }

//
//    var steamer: ParsedBatter? {
//        AllParsedBatters.batters(for: .steamer).first(where: { $0.name == batter.name })
//    }
//
//    var atc: ParsedBatter? {
//        AllParsedBatters.batters(for: .atc).first(where: { $0.name == batter.name })
//    }
//
//    var thebat: ParsedBatter? {
//        AllParsedBatters.batters(for: .thebat).first(where: { $0.name == batter.name })
//    }
//
//    var thebatx: ParsedBatter? {
//        AllParsedBatters.batters(for: .thebatx).first(where: { $0.name == batter.name })
//    }
//
//    var zips: ParsedBatter? {
//        AllParsedBatters.batters(for: .zips).first(where: { $0.name == batter.name })
//    }
//
//    var depthCharts: ParsedBatter? {
//        AllParsedBatters.batters(for: .depthCharts).first(where: { $0.name == batter.name })
//    }
//
//    var arr: [(ProjectionTypes, ParsedBatter)] {
    ////        [steamer, atc, thebat, thebatx, zips, depthCharts].compactMap({$0})
//        ProjectionTypes.arr.compactMap { projType in
//            if let thisBatter = AllParsedBatters.batters(for: projType).first(where: { parsedBatter in
//                parsedBatter.name == batter.name
//            }) {
//                return (projType, thisBatter)
//            } else { return nil }
//        }
//    }
//
//    func projType(index: Int) -> ProjectionTypes {
//        arr[index].0
//    }
//
//    func points(index: Int) -> Double {
    ////        let projType = projType(index: index)
//        return batter.fantasyPoints(model.scoringSettings)
//    }
//
//    func stat(index: Int, stat: String) -> Int {
//        let batter: ParsedBatter = arr[index].1
//        return batter.dict[stat] as? Int ?? 0
//    }

    var body: some View {
        List {
            Group {
                Picker("PA", selection: $pa) {
                    ForEach(0 ... 800, id: \.self) { num in
                        Text(num.str)
                            .tag(num)
                    }
                }
                Picker("G", selection: $g) {
                    ForEach(0 ... 162, id: \.self) { num in
                        Text(num.str)
                            .tag(num)
                    }
                }

                Picker("H", selection: $h) {
                    ForEach(0 ... 270, id: \.self) { num in
                        Text(num.str)
                            .tag(num)
                    }
                }

                Picker("2B", selection: $doubles) {
                    ForEach(0 ... 90, id: \.self) { num in
                        Text(num.str)
                            .tag(num)
                    }
                }

                Picker("3B", selection: $triples) {
                    ForEach(0 ... 50, id: \.self) { num in
                        Text(num.str)
                            .tag(num)
                    }
                }

                Picker("HR", selection: $hr) {
                    ForEach(0 ... 70, id: \.self) { num in
                        Text(num.str)
                            .tag(num)
                    }
                }

                Picker("RBI", selection: $rbi) {
                    ForEach(0 ... 200, id: \.self) { num in
                        Text(num.str)
                            .tag(num)
                    }
                }

                Picker("R", selection: $r) {
                    ForEach(0 ... 200, id: \.self) { num in
                        Text(num.str)
                            .tag(num)
                    }
                }

                Picker("SB", selection: $sb) {
                    ForEach(0 ... 90, id: \.self) { num in
                        Text(num.str)
                            .tag(num)
                    }
                }
            }

            Group {
                Picker("CS", selection: $cs) {
                    ForEach(0 ... 50, id: \.self) { num in
                        Text(num.str)
                            .tag(num)
                    }
                }
                Picker("SO", selection: $k) {
                    ForEach(0 ... 225, id: \.self) { num in
                        Text(num.str)
                            .tag(num)
                    }
                }

                Picker("HBP", selection: $hbp) {
                    ForEach(0 ... 30, id: \.self) { num in
                        Text(num.str)
                            .tag(num)
                    }
                }
            }
        }
        .toolbarSave {
            model.myModifiedBatters.remove(batter)
            model.myModifiedBatters.insert(
                ParsedBatter(empty: batter.empty, name: batter.name, team: batter.team, g: g, ab: batter.ab, pa: pa, h: h, the1B: singles, the2B: doubles, the3B: triples, hr: hr, r: r, rbi: rbi, bb: bb, ibb: batter.ibb, so: k, hbp: hbp, sf: batter.sf, sh: batter.sh, sb: sb, cs: cs, avg: batter.avg, positions: batter.positions, projectionType: .myProjections)
            )

            model.save()
            dismiss()
        }

//        List {
//            Section("My Stats") {
//                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
//                    ForEach(modifiedBatter.relevantStatsKeys, id: \.self) { key in
//                        if let val = modifiedBatter.dict[key] as? Int {
//                            Menu {
//                                ForEach(arr.indices, id: \.self) { ind in
//
//                                    Button {
//                                        modifiedBatter.edit(key, with: stat(index: ind, stat: key))
//
//                                    } label: {
//                                        Text("\(projType(index: ind).title): \(stat(index: ind, stat: key))")
//                                    }
//                                }
//                            } label: {
//                                StatRect(stat: key, value: val)
//                            }
//                        }
//                    }
//                    StatRect(stat: "Points", value: batter.fantasyPoints(MainModel.shared.getScoringSettings()))
//                }
//            }
//            .listRowBackground(Color.clear)
//            .listRowSeparator(.hidden)
//        }
    }
}

// MARK: - CreateModifiedPlayerView_Previews

struct CreateModifiedPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        CreateModifiedPlayerView(batter: AllParsedBatters.theBat.all[3])
            .environmentObject(MainModel.shared)
            .putInNavView(displayMode: .inline)
    }
}
