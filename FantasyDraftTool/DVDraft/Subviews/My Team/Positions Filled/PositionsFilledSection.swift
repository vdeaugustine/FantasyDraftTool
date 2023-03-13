//
//  PositionsFilledSection.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/11/23.
//

import SwiftUI

// MARK: - PositionsFilledSection

struct PositionsFilledSection: View {
    let myTeam: DraftTeam

    let positionsTopRow: [Position] = [.c, .first, .second, .third]

    let positionsBottomRow: [Position] = [.ss, .of, .sp, .rp]

    func filled(for pos: Position) -> Int {
        myTeam.players(for: pos).count
    }

    var body: some View {
        VStack {
            Text("Positions Filled")
                .font(size: 16, color: "BEBEBE", weight: .medium)
                .pushLeft()
//                .padding(.leading, 15)

            HStack {
                ProgressRing(completed: 15, needed: 25)

                VStack {
                    HStack {
                        ForEach(positionsTopRow, id: \.self) { pos in

                            PositionFilledRect(position: pos, myTeam: myTeam)
                        }
                    }
                    HStack {
                        ForEach(positionsBottomRow, id: \.self) { pos in
                            
                            PositionFilledRect(position: pos, myTeam: myTeam)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - PositionsFilledSection_Previews

struct PositionsFilledSection_Previews: PreviewProvider {
    static let demoteam: DraftTeam = {
        let drafted = DraftPlayer(player: ParsedBatter.TroutOrNull, pickNumber: 1, round: 1, pickInRound: 1, weightedScore: 2.5)

        let team = DraftTeam(name: "Team Tulo", draftPosition: 1, draftedPlayers: [drafted])

        return team

    }()
    
    static let demoDraft: Draft = {
        if let demo = Draft.loadDraft() { return demo }
        return Draft.exampleDraft(picksMade: 1, projection: .steamer)
    }()

    static var previews: some View {
        PositionsFilledSection(myTeam: demoteam)
            .padding(.horizontal)
            .previewBackground()
    }
}
