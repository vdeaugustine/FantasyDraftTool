//
//  TeamStatBox.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/12/23.
//

import SwiftUI

// MARK: - AllTeamsStatRankingWithDropDown

struct AllTeamsStatRankingWithDropDown: View {
    @Binding var showDropDown: Bool
    let draft: Draft

    let statsToShow: [String] = ["PTS", "SCORE", "H PTS", "P PTS", "HR", "RBI", "SB", "R", "IP", "SO", "W", "L"]

    @State var PTSTeam: [DraftTeam] = []
    @State var ScoreTeam: [DraftTeam] = []
    @State var HPTSTeam: [DraftTeam] = []
    @State var PPTSTeam: [DraftTeam] = []
    @State private var HRTeam: [DraftTeam] = []
    @State private var RBITeam: [DraftTeam] = []
    @State private var sbTeam: [DraftTeam] = []
    @State private var rTeam: [DraftTeam] = []
    @State private var ipTeam: [DraftTeam] = []
    @State private var soTeam: [DraftTeam] = []
    @State private var wTeam: [DraftTeam] = []
    var showSpinner: Bool {
        PTSTeam.isEmpty || HRTeam.isEmpty || soTeam.isEmpty
    }

    @discardableResult func rankTeamsBy(stat: String, completion: @escaping (([DraftTeam]) -> Void)) -> [DraftTeam] {
        let teams = draft.teams
        let sorted = teams.sorted { $0.totalForStat(statKey: stat, draft: draft) > $1.totalForStat(statKey: stat, draft: draft) }
        completion(sorted)
        return sorted
    }

    func update() {
        DispatchQueue.global().async {
            
            
            rankTeamsBy(stat: "PTS") { teams in
                PTSTeam = teams
            }
            rankTeamsBy(stat: "HR") { teams in
                HRTeam = teams
            }
            rankTeamsBy(stat: "SO") { teams in
                soTeam = teams
            }
            

//            rankTeamsBy(stat: "RBI") { teams in
//                RBITeam = teams
//            }
//
//            rankTeamsBy(stat: "R") { teams in
//                rTeam = teams
//            }
//
//            rankTeamsBy(stat: "SB") { teams in
//                sbTeam = teams
//            }
//
//            rankTeamsBy(stat: "IP") { teams in
//                ipTeam = teams
//            }

            
        }
    }
    
    func updateThisTeam(statKey: String, thisTeam: Binding<[DraftTeam]>) {
        rankTeamsBy(stat: statKey) { team in
            thisTeam.wrappedValue = team
        }
    }
    
    func statView(statKey: String, team: [DraftTeam]) -> some View {
        VStack(spacing: 10) {
            Text(statKey)
                .font(size: 12, color: "BEBEBE", weight: .regular)
            if let topTeam = team.first {
                DVTeamStatBox(team: topTeam, value: topTeam.totalForStat(statKey: statKey, draft: draft))
            }

            Button {
                withAnimation {
                    showDropDown.toggle()
                }
                
            } label: {
                Label("Show More", systemImage: "chevron.up")
                    .labelStyle(.iconOnly)
                    .rotationEffect(.degrees(showDropDown ? 0 : 180))
            }

            if showDropDown {
                VStack(spacing: 2) {
                    ForEach(team, id: \.self) { team in
                        DVTeamStatBox(team: team, value: team.totalForStat(statKey: statKey, draft: draft))
                    }
                }
            }
        }
    }

    var body: some View {
        ZStack {
//            ScrollView(.horizontal) {
                HStack {
                    
                    statView(statKey: "PTS", team: PTSTeam)
                    statView(statKey: "HR", team: HRTeam)
//                    statView(statKey: "RBI", team: RBITeam)
//                    statView(statKey: "R", team: rTeam)
                    statView(statKey: "SO", team: soTeam)
//                    statView(statKey: "IP", team: ipTeam)
//                    VStack(spacing: 10) {
//                        Text("PTS")
//                            .font(size: 12, color: "BEBEBE", weight: .regular)
//                        if let topTeam = PTSTeam.first {
//                            DVTeamStatBox(team: topTeam, value: topTeam.totalForStat(statKey: "PTS", draft: draft))
//                        }
//
//                        Button {
//                            showDropDown.toggle()
//                        } label: {
//                            Label("Show More", systemImage: "chevron.up")
//                                .labelStyle(.iconOnly)
//                                .rotationEffect(.degrees(showDropDown ? 0 : 180))
//                        }
//
//                        if showDropDown {
//                            VStack(spacing: 2) {
//                                ForEach(PTSTeam, id: \.self) { team in
//                                    DVTeamStatBox(team: team, value: team.totalForStat(statKey: "PTS", draft: draft))
//                                }
//                            }
//                        }
//                    }
//                    VStack(spacing: 10) {
//                        Text("HR")
//                            .font(size: 12, color: "BEBEBE", weight: .regular)
//                        if let topTeam = HRTeam.first {
//                            DVTeamStatBox(team: topTeam, value: topTeam.totalForStat(statKey: "HR", draft: draft))
//                        }
//
//                        Button {
//                            showDropDown.toggle()
//                        } label: {
//                            Label("Show More", systemImage: "chevron.up")
//                                .labelStyle(.iconOnly)
//                                .rotationEffect(.degrees(showDropDown ? 0 : 180))
//                        }
//
////                        if showDropDown {
////                            VStack(spacing: 2) {
////                                ForEach(rankTeamsBy(stat: statKey), id: \.self) { team in
////                                    DVTeamStatBox(team: team, value: team.totalForStat(statKey: statKey, draft: draft))
////                                }
////                            }
////                        }
//                    }
//
//                    VStack(spacing: 10) {
//                        Text("RBI")
//                            .font(size: 12, color: "BEBEBE", weight: .regular)
//                        if let topTeam = RBITeam.first {
//                            DVTeamStatBox(team: topTeam, value: topTeam.totalForStat(statKey: "RBI", draft: draft))
//                        }
//
//                        Button {
//                            showDropDown.toggle()
//                        } label: {
//                            Label("Show More", systemImage: "chevron.up")
//                                .labelStyle(.iconOnly)
//                                .rotationEffect(.degrees(showDropDown ? 0 : 180))
//                        }
//
////                        if showDropDown {
////                            VStack(spacing: 2) {
////                                ForEach(rankTeamsBy(stat: statKey), id: \.self) { team in
////                                    DVTeamStatBox(team: team, value: team.totalForStat(statKey: statKey, draft: draft))
////                                }
////                            }
////                        }
//                    }
                }
//            }

            if showSpinner {
                ProgressView()
            }
        }
        .onAppear {
            update()
        }
    }
}

// MARK: - TeamStatBox_Previews

struct TeamStatBox_Previews: PreviewProvider {
    static var previews: some View {
        AllTeamsStatRankingWithDropDown(showDropDown: .constant(true), draft: .loadExample()!)
            .previewBackground()
    }
}
