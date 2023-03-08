//
//  NVPlayerStats.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/7/23.
//

import SwiftUI

// MARK: - NVPlayerStats

struct NVPlayerStats: View {
    @EnvironmentObject private var model: MainModel
    let player: ParsedBatter

   
    @State private var myBatter: ParsedBatter = .nullBatter
    @State private var modifiedKey: String = ""
    @State private var modifiedStat: Int = 0
    @State private var showModifier = false
    
    @State private var selected: [Int] = []

    func batterProjection(_ type: ProjectionTypes) -> ParsedBatter? {
        let time1 = Date.now
        if let position = player.positions.first {
            let positionPlayers = AllParsedBatters.batters(for: type, at: position)
            if let foundPlayer = positionPlayers.first(where: { $0.name == player.name }) {
                let time2 = Date.now
                print("Found time: ", time2 - time1)
                return foundPlayer
            }
        }
        return nil
    }
    
    func statRow(key: String) -> some View {
        VStack(spacing: 5) {
            Text(key)
                .pushLeft()
                .padding(.leading)
            HStack {
                ForEach(ProjectionTypes.batterArr, id: \.self) { thisProj in

                    if let batter = batterProjection(thisProj),
                       let stat = batter.dict[key] as? Int {
                        VStack {
                            Text(thisProj.title)
                                .font(.caption2)
                            Text(stat.str)
                        }
                        .padding(10)
                        .background {
                            Color.listBackground.cornerRadius(7)
                        }
                    }
                }
            }
        }
    }

    var body: some View {
        ScrollView {
            VStack {
                ForEach(player.relevantStatsKeys, id: \.self ) { key in
                    statRow(key: key)
                }
            }
        }

//        List {
//            ForEach(ProjectionTypes.batterArr, id: \.self) { proj in
//
//                Section(proj.title) {
//                    if let foundPlayer = batterProjection(proj) {
//                        Text([foundPlayer.name, foundPlayer.fantasyPoints(.defaultPoints), foundPlayer.projectionType.title].joinString(" | "))
//                    }
//                }
//            }
//
//            Section("My batter") {
//                Text([myBatter.name, myBatter.fantasyPoints(.defaultPoints), myBatter.projectionType.title].joinString(" | "))
//            }
//        }
        .navigationTitle(player.name)
        .onAppear {
            myBatter = player
        }
    }
}

// MARK: - NVPlayerStats_Previews

struct NVPlayerStats_Previews: PreviewProvider {
    static var previews: some View {
        NVPlayerStats(player: AllParsedBatters.atc.of.first(where: { $0.name.lowercased().contains("trout") }) ?? .nullBatter)
            .environmentObject(MainModel.shared)
            .putInNavView()
    }
}
