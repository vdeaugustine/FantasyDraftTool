//
//  NVDraftPlayerDetail.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/15/23.
//

import SwiftUI

// MARK: - NVDraftPlayerDetail

struct NVDraftPlayerDetail: View {
    
    enum RankingChoice: String {
        case position, all
    }
    
    @EnvironmentObject private var model: MainModel
    @State var batter: ParsedBatter
    @State private var projection: ProjectionTypes = .steamer
//    @State private var rankingChoice: RankingChoice = .position
    @State private var foundBatter: ParsedBatter = .nullBatter

    func statRect(title: String, stat: String) -> some View {
        VStack {
            Text(stat)
            Text(title)
                .fontWeight(.heavy)
                .foregroundColor(.gray)
            Text(batter.projectionType.str)
            Text(projection.str)
        }
    }

    let stats = ["G",
                 "AB",
                 "H",
                 "HR",
                 "R",
                 "RBI",
                 "AVG",
                 "OBP",
                 "K",
                 "BB",
                 "SB",
                 "FPTS"]

    func rankStr(stat: String, rankingChoice: RankingChoice) -> String {
        
        let pool = model.draft.playerPool
//        print("rank for \(stat)", batter.dict[stat])
        let batters: [ParsedBatter]
        switch rankingChoice {
        case .position:
            guard let position = batter.positions.first else { return "NA" }
            batters  = pool.batters(for: [position], projection: batter.projectionType, draft: model.draft)
        case .all:
            batters = pool.storedBatters.batters(for: batter.projectionType)
        }
        
        if stat == "FPTS" {
            let sorted = batters.sortedByPoints(scoring: model.draft.settings.scoringSystem)
            guard let firstInd = sorted.firstIndex(of: batter) else {
                return "NA"
            }
            return (firstInd + 1).withSuffix
        }

        let sorted = batters.sorted {
            guard let stat1 = $0.dict[stat] as? NSNumber,
                  let stat2 = $1.dict[stat] as? NSNumber,
                  let dub1 = stat1 as? Double,
                  let dub2 = stat2 as? Double
            else { return true }
            return dub1 > dub2
        }

        guard let firstInd = sorted.firstIndex(of: batter) else {
            return "NA"
        }
        return (firstInd + 1).withSuffix
    }

    var body: some View {
        ScrollView {
            VStack {
                // MARK: - Heading
                Text("found batter: , \(foundBatter.description)")
                HStack {
                    Text(batter.name)
                    Divider()
                    Text(batter.team)
                    Divider()
                    Text(batter.posStr())
                    Spacer()
                }.font(.title2)

                NVDropDownProjection(selection: $projection, font: .footnote)
                    .onChange(of: projection) { newValue in
                        let allBatters = model.draft.playerPool.storedBatters.batters(for: newValue).sortedByPoints(scoring: model.draft.settings.scoringSystem)
                        
                        
                        print("allbatters", allBatters.prefixArray(10))
                        print("Changed")
                        
                        let newBatters = allBatters.filter({$0.name == batter.name})
//                            print("old batter was", batter)
                            print("found batters", newBatters)
                        if let new = newBatters.safeGet(at: 0) {
                            print("before: ", batter)
                            batter = new
                            print("new: ", batter)
                            foundBatter = new
//                            if newValue == .atc {
//                                print("new found: ", foundBatter)
//                                foundBatter = .nullBatter
//                                print("new found: ", foundBatter)
//                                batter = .nullBatter
//                            }
                            
                        } else {
                            foundBatter = .nullBatter
                        }
//                            batter = newBatter
//                            print("new batter is: ", batter)
                        
                    }

                // MARK: - Quick Stats

                VStack {
                    ZStack {
                        Color.blue.padding(.horizontal, -100).padding(.vertical, -5)
                        Text("Quick Stats").pushLeft().foregroundColor(.white)
                    }
                    VStack {
                        HStack(spacing: 25) {
                            statRect(title: "G", stat: batter.g.str)
                            statRect(title: "AB", stat: batter.ab.str)
                            statRect(title: "H", stat: batter.h.str)
                            statRect(title: "HR", stat: batter.hr.str)
                            statRect(title: "R", stat: batter.r.str)
                            statRect(title: "RBI", stat: batter.rbi.str)
                        }
                        Divider().padding(.horizontal)
                        HStack(spacing: 25) {
                            statRect(title: "AVG", stat: batter.g.str)
                            statRect(title: "OBP", stat: batter.ab.str)
                            statRect(title: "K", stat: batter.h.str)
                            statRect(title: "BB", stat: batter.hr.str)
                            statRect(title: "SB", stat: batter.r.str)
                            statRect(title: "FPTS", stat: batter.fantasyPoints(model.draft.settings.scoringSystem).str())
                        }
                    }.padding(.top, 10)
                }

                // MARK: - Position Rankings

                VStack {
                    ZStack {
                        Color.blue.padding(.horizontal, -100).padding(.vertical, -5)
                        Text("Rankings Among \(batter.posStr())").pushLeft().foregroundColor(.white)
                    }

                    VStack {
                        
                        HStack(spacing: 25) {
                            ForEach(stats.prefixArray(6), id: \.self) { statKey in

                                statRect(title: statKey, stat: rankStr(stat: statKey, rankingChoice: .position))
                            }
                        }
                        Divider().padding(.horizontal)
                        HStack(spacing: 25) {
                            ForEach(stats.suffixArray(6), id: \.self) { statKey in
                                statRect(title: statKey, stat: rankStr(stat: statKey, rankingChoice: .position))
                            }
                        }
                    }.padding(.top, 10)

                }.padding(.top)
                
                // MARK: - All Batters Rankings
                VStack {
                    ZStack {
                        Color.blue.padding(.horizontal, -100).padding(.vertical, -5)
                        Text("Rankings Among All Batters").pushLeft().foregroundColor(.white)
                    }

                    VStack {
                        
                        HStack(spacing: 25) {
                            ForEach(stats.prefixArray(6), id: \.self) { statKey in

                                statRect(title: statKey, stat: rankStr(stat: statKey, rankingChoice: .position))
                            }
                        }
                        Divider().padding(.horizontal)
                        HStack(spacing: 25) {
                            ForEach(stats.suffixArray(6), id: \.self) { statKey in
                                statRect(title: statKey, stat: rankStr(stat: statKey, rankingChoice: .position))
                            }
                        }
                    }.padding(.top, 10)

                }.padding(.top)

            }.padding()
        } .toolbar(.hidden)
    }
}

// MARK: - NVDraftPlayerDetail_Previews

struct NVDraftPlayerDetail_Previews: PreviewProvider {
    static var previews: some View {
        NVDraftPlayerDetail(batter: MainModel.shared.draft.playerPool.batters(for: [.of], projection: .steamer).first!)
            .previewDevice("iPhone 14 Pro")
            .environmentObject(MainModel.shared)
            .putInNavView(displayMode: .inline)
//            .previewDevice("iPhone SE (3rd generation)")
    }
}
