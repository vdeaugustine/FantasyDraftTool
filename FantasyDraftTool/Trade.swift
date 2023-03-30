//
//  Trade.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/18/23.
//

import Foundation
 

//class Trade {
//    let playersToTradeTeamA: [ParsedPlayer]
//    let playersToTradeTeamB: [ParsedPlayer]
//    var feedbackMessage: String
//    
//    init(teamA: Team, teamB: Team, playersToTradeTeamA: [ParsedPlayer], playersToTradeTeamB: [ParsedPlayer]) {
//        self.teamA = teamA
//        self.teamB = teamB
//        self.playersToTradeTeamA = playersToTradeTeamA
//        self.playersToTradeTeamB = playersToTradeTeamB
//        self.feedbackMessage = ""
//    }
//    
//    func isTradeValid() -> Bool {
//        for player in playersToTradeTeamA {
//            if !teamA.roster.contains(player) {
//                feedbackMessage = "Player \(player.name) is not on team \(teamA.name)'s roster."
//                return false
//            }
//        }
//        
//        for player in playersToTradeTeamB {
//            if !teamB.roster.contains(player) {
//                feedbackMessage = "Player \(player.name) is not on team \(teamB.name)'s roster."
//                return false
//            }
//        }
//        
//        return true
//    }
//    
//    func performTrade() -> Bool {
//        if !isTradeValid() {
//            return false
//        }
//        
//        for player in playersToTradeTeamA {
//            teamA.roster.removeAll(where: { $0 == player })
//            teamB.roster.append(player)
//        }
//        
//        for player in playersToTradeTeamB {
//            teamB.roster.removeAll(where: { $0 == player })
//            teamA.roster.append(player)
//        }
//        
//        feedbackMessage = "Trade successfully completed between \(teamA.name) and \(teamB.name)."
//        return true
//    }
//    
//    func getFeedback() -> String {
//        return feedbackMessage
//    }
//}
