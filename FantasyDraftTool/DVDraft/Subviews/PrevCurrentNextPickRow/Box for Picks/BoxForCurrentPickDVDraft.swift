//
//  BoxForCurrentPickDVDraft.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/10/23.
//

import SwiftUI

// MARK: - BoxForCurrentPickDVDraft

struct BoxForCurrentPickDVDraft: View {
    @EnvironmentObject private var model: MainModel

    var draft: Draft { model.draft }

    var currentLabel: some View {
        Text("Current")
            .font(size: 16, color: MainModel.shared.specificColor.lighter, weight: .medium)
            .padding(.top, 5)
    }

    var player: ParsedPlayer {
        draft.currentTeam.recommendedPlayer(draft: draft, projection: model.draft.projectionCurrentlyUsing) ?? ParsedBatter.nullBatter
    }

    var teamNameAndDraftPickNumber: some View {
        VStack {
            Text("#\(draft.totalPickNumber + 1)")
                .font(size: 16, color: MainModel.shared.specificColor.lighter, weight: .light)
            if let team = draft.currentTeam {
                Text("\(team.name)")
                    .font(size: 16, color: MainModel.shared.specificColor.lighter, weight: .bold)
            }
        }
    }

    var getName: (firstName: String, lastName: String) {
        let full = player.name.components(separatedBy: .whitespaces)
        let first = full.safeGet(at: 0) ?? ""
        let second = full.safeGet(at: 1) ?? ""
        let suffix = full.safeGet(at: 2) ?? ""
        let last = [second, suffix].joinString(" ")
        return (firstName: first, lastName: last)
    }

    var body: some View {
        VStack {
            teamNameAndDraftPickNumber
            boxPart
                .background(color: MainModel.shared.specificColor.rect, padding: 10, radius: 7, shadow: 1)
                .frame(width: 125, height: 88)
            currentLabel
        }
    }

    var boxPart: some View {
        VStack(spacing: 12) {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text(getName.firstName)
                        .font(size: 16, color: .white, weight: .medium)
                    Text(getName.lastName)
                        .font(size: 16, color: .white, weight: .medium)
                }
                Text(player.team)
                    .font(size: 8, color: .white, weight: .ultraLight)
            }.pushLeft()

            HStack {
                VStack {
                    if let batter = player as? ParsedBatter,
                       let rank = draft.playerPool.totalRank(for: batter) {
                        Text("B RANK")
                            .font(size: 8, color: MainModel.shared.specificColor.lighter, weight: .light)
                        Text(rank.str)
                            .font(size: 12, color: .white, weight: .semibold)
                    }
                    if let pitcher = player as? ParsedPitcher,
                       let rank = draft.playerPool.totalRank(for: pitcher) {
                        Text("P RANK")
                            .font(size: 8, color: MainModel.shared.specificColor.lighter, weight: .light)
                        Text(rank.str)
                            .font(size: 12, color: .white, weight: .semibold)
                    }
                }
                Spacer()

                VStack {
                    if let adpStr = player.getSomeADPStr(),
                       adpStr.isEmpty == false {
                        Text("ADP")
                            .font(size: 8, color: MainModel.shared.specificColor.lighter, weight: .light)
                        Text(adpStr)
                            .font(size: 12, color: .white, weight: .semibold)
                    }
                }
                Spacer()

                VStack {
                    Text("PTS")
                        .font(size: 8, color: MainModel.shared.specificColor.lighter, weight: .light)
                    Text(player.fantasyPoints(draft.settings.scoringSystem).simpleStr())
                        .font(size: 12, color: .white, weight: .semibold)
                }
            }
        }
    }
}

// MARK: - BoxForCurrentPickDVDraft_Previews

struct BoxForCurrentPickDVDraft_Previews: PreviewProvider {
//    static let draft = Draft.exampleDraft(picksMade: 30, projection: .thebat)
    static var previews: some View {
        BoxForCurrentPickDVDraft()
            .environmentObject(MainModel.shared)
    }
}
