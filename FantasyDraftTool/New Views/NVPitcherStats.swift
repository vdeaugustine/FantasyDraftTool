//
//  NVPitcherStats.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/7/23.
//

import SwiftUI

// MARK: - NVPitcherStats

struct NVPitcherStats: View {
    @EnvironmentObject private var model: MainModel
    @State var pitcher: ParsedPitcher

    @State private var projectionOptions: [ProjectionTypes] = []
    @State private var projectionType: ProjectionTypes = MainModel.shared.mainSettings.defaultProjection

    var isBothSPandRP: Bool {
        if pitcher.type == .starter {
            for proj in ProjectionTypes.pitcherArr {
                let others = AllExtendedPitchers.relievers(for: proj, limit: 500)
                if others.contains(where: { $0.name == pitcher.name }) {
                    return true
                }
            }

        } else {
            for proj in ProjectionTypes.pitcherArr {
                let others = AllExtendedPitchers.starters(for: proj, limit: 500)
                if others.contains(where: { $0.name == pitcher.name }) {
                    return true
                }
            }
        }

        return false
    }

    var statKey: [String] {
        switch pitcher.type {
            case .starter:
                return pitcher.starterStatKeys
            case .reliever:
                return pitcher.relieverStatKeys
        }
    }

    func findPitcher(_ projType: ProjectionTypes) -> ParsedPitcher? {
        let pool: [ParsedPitcher]
        switch pitcher.type {
            case .reliever:
                pool = AllExtendedPitchers.relievers(for: projType, limit: 500)
            case .starter:
                pool = AllExtendedPitchers.starters(for: projType, limit: 500)
        }

        return pool.first(where: { $0.name == pitcher.name })
    }

    func statRow(key: String) -> some View {
        VStack(spacing: 5) {
            Text(key)
                .pushLeft()
                .padding(.leading)
            HStack {
                ForEach(ProjectionTypes.pitcherArr, id: \.self) { thisProj in

                    if let pitcher = findPitcher(thisProj),
                       let stat = pitcher.dict[key] as? Int,
                       stat > 0 {
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

    var typeStr: String {
        isBothSPandRP ? "SP, RP" : pitcher.type.short
    }

    var customDivider: some View {
        RoundedRectangle(cornerRadius: 7)
            .foregroundColor(.white)
            .frame(height: 1)
            .frame(maxWidth: .infinity)
    }

    var verticalDivider: some View {
        RoundedRectangle(cornerRadius: 7)
            .foregroundColor(.white)
            .frame(width: 1)
            .frame(maxHeight: .infinity)
    }

    var posAvg: Double {
        let peers = pitcher.peers.filter {
            guard let adp = $0.adp else { return false }
            return adp <= 450
        }
        return ParsedPitcher.averagePoints(forThese: peers, scoringSettings: .defaultPoints)
    }

//    func rank(_ pitcher: ParsedPitcher) {

    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading) {
                    Text(pitcher.name)
                        .font(.largeTitle)
                    HStack(alignment: .bottom) {
                        Text([typeStr, pitcher.team].joinString(" • "))
                        Spacer()
                        VStack(spacing: 5) {
                            Text("Proj. System")
                                .font(.caption2)
                                .foregroundColor(.gray)

                            Menu {
                                ForEach(projectionOptions, id: \.self) { proj in
                                    Button {
                                        if let found = findPitcher(proj) {
                                            pitcher = found
                                            projectionType = pitcher.projectionType
                                        }
                                    } label: {
                                        Label(proj.title, systemImage: proj == projectionType ? "checkmark" : "")
                                    }
                                }
                            } label: {
                                Text(projectionType.title)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                            }

//                            Text(pitcher.projectionType.title)
                        }
                    }
                    .padding(.leading)
                    .font(.title3)
                }
                .pushLeft()
                .foregroundColor(.white)
                .padding(.leading)

                customDivider.padding(.horizontal)

                HStack {
                    VStack {
                        Text("POS RANK")
                            .foregroundColor(.gray)
                            .font(.footnote)

                        Text(pitcher.pitcherRank()?.str ?? "NA")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                    }
                    .padding(.trailing)

                    verticalDivider

                    VStack {
                        Text("ADP")
                            .foregroundColor(.gray)
                            .font(.footnote)

                        Text(pitcher.adpStr() ?? "NA")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal)

                    verticalDivider

                    VStack {
                        Text("PROJ. PTS")
                            .foregroundColor(.gray)
                            .font(.footnote)

                        Text(pitcher.fantasyPoints(.defaultPoints).str())
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal)

                    verticalDivider

                    VStack {
                        Text("POS AVG")
                            .foregroundColor(.gray)
                            .font(.footnote)

                        Text(posAvg.str())
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                    }
                    .padding(.leading)
                }

                VStack {
                    VStack {
                        Text("SO")
                            .fontWeight(.semibold).foregroundColor(.hexStringToColor(hex: "959496"))

                        if let stat = pitcher.dict[statKey[0]] as? Int {
                            Text(stat.str)
                                .foregroundColor(.white)
                            
                            
                            
                            
                            
                            
                        }

//                        customDivider.frame(width: 20)
                    }
                }
                .padding()
                .background {
                    Color.hexStringToColor(hex: "434343").cornerRadius(7)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background {
            Color.hexStringToColor(hex: "1B1B1D").edgesIgnoringSafeArea(.all)
        }
        .onAppear {
            projectionType = pitcher.projectionType
            for projection in ProjectionTypes.allArr {
                let type = pitcher.type
                let peers: [ParsedPitcher]
                switch type {
                    case .starter:
                        peers = AllExtendedPitchers.starters(for: projection, limit: 1_000)
                    case .reliever:
                        peers = AllExtendedPitchers.relievers(for: projection, limit: 1_000)
                }
                if peers.contains(where: { $0.name == pitcher.name }) {
                    projectionOptions.append(projection)
                }
            }
        }
    }
}

struct Bars: View {
    
    let stat: String
    let value: Double
    let avg: Double
    let max: Double
    let height: CGFloat
    
    var avgHeight: Double {
        avg / max * height
    }
    
    var valueHeight: Double {
        value / max * height
    }
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                Rectangle()
                    .foregroundColor(.blue)
                    .frame(width: 20)
                
                Rectangle()
                    .foregroundColor(.red)
                    .frame(width: 20)
                
                
                
            }
            
            
        }
        .height(height)
        
        
        
        
    }
    
    
}

// MARK: - NVPitcherStats_Previews

// struct NVPitcherTable: View {
//    let pitcher: ParsedPitcher
//
//
//
//    var body: some View {
//        ScrollView {
//            VStack {
//                Text(pitcher.name)
//
//                    .font(.title2)
//                Text([pitcher pitcher.team])
//            }
//            .foregroundColor(.white)
//
//        }
//        .frame(maxWidth: .infinity)
//        .background {
//            Color.hexStringToColor(hex: "111115").edgesIgnoringSafeArea(.all)
//        }
//    }
// }

struct NVPitcherStats_Previews: PreviewProvider {
    static var previews: some View {
        NVPitcherStats(pitcher: AllExtendedPitchers.starters(for: .atc, limit: 10).first!)
            .putInNavView()
            .environmentObject(MainModel.shared)
    }
}
