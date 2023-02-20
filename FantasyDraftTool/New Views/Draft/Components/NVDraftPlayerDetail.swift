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

    @State private var notYourTurnAlert = false
    
    @State private var draftedAlert = false
    
    @Environment (\.dismiss) private var dismiss

    var numPicksTill: Int {
        let batters = model.draft.playerPool.batters.sorted(by: { $0.zScore(draft: model.draft) > $1.zScore(draft: model.draft) })

        guard let ind = batters.firstIndex(where: { $0.name == batter.name }) else { return 0 }

        return ind + 1
    }

    func plusMinusStr(statKey: String, batterNum: Int) -> String? {
        guard let position = position
        else { return nil }
        let positionAverage = Int(AverageStats.average(for: statKey, for: position, and: projection).roundTo(places: 0))

        let relativeBatter: Int = batterNum - positionAverage

        let prefix: String = relativeBatter >= 0 ? "+" : ""

        return prefix + relativeBatter.str
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
                            Text(statKey).fontWeight(.bold)
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

            Section {
                if let position = position,
                   let pickStackArray = model.draft.pickStack.getArray(),
                   let playersAtPosition = pickStackArray.filter({ $0.player.positions.contains(position) }) {
                    GroupBox("Drafted So Far") {
                        ForEach(playersAtPosition, id: \.self) { player in
                            HStack {
                                Text(player.player.name)
                                if let draftedTeam = player.draftedTeam {
                                    Text(draftedTeam.name)
                                }
                                Text("Pick number: \(player.pickNumber)")
                            }
                        }
                    }
                }

            } header: {
                Text("Position")
            }

            Section {
                if let position = position {
                    GroupBox("By Position") {
                        ForEach(batter.similarPlayers(5, for: position, and: projection), id: \.self) { similarPlayer in

                            Text(similarPlayer)
                                .spacedOut {
                                    Text(similarPlayer.fantasyPoints(model.draft.settings.scoringSystem))
                                }
                        }
                    }
                }

            } header: {
                Text("Similar Players")
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
                    
                    model.draft.makePick(.init(player: batter, draft: model.draft))
                    draftedAlert.toggle()
                    
                    
//                    if model.draft.currentTeam == model.draft.myTeam {
//                        model.draft.makePick(.init(player: batter, draft: model.draft))
//                    } else {
//                        notYourTurnAlert.toggle()
//                    }
                    
                }
            }
        }
        .navigationTitle(batter.name + " • " + batter.team)
        .onAppear {
            position = batter.positions.first
        }
        .alert("It is not your turn", isPresented: $notYourTurnAlert) {
            Button("OK") {}
        }
        .alert("\(model.draft.previousTeam?.name ?? "") drafted \(batter.name)", isPresented: $draftedAlert) {
            Button("OK") {
                
                dismiss()
                
            }
        }
}
}

// MARK: - NVDraftPlayerDetail_Previews

struct NVDraftPlayerDetail_Previews: PreviewProvider {
    static var previews: some View {
        NVDraftPlayerDetail(batter: AllExtendedBatters.batters(for: .zips, at: .of)[25])
            .environmentObject(MainModel.shared)
            .putInNavView()
            
    }
}
