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
    let pitcher: ParsedPitcher

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

    var body: some View {
        ScrollView {
            VStack {
                ForEach(statKey, id: \.self) { key in

                    statRow(key: key)
                }
            }
        }
        .navigationTitle([pitcher.name, isBothSPandRP ? "SP, RP" : pitcher.type.short].joinString(", "))
    }
}

// MARK: - NVPitcherStats_Previews

struct NVPitcherStats_Previews: PreviewProvider {
    static var previews: some View {
        NVPitcherStats(pitcher: AllExtendedPitchers.starters(for: .atc, limit: 10).first!)
            .putInNavView()
            .environmentObject(MainModel.shared)
    }
}
