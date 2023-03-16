//
//  DVHomePage.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/16/23.
//

import SwiftUI

struct DVHomePage: View {
    var body: some View {
        VStack(spacing: 20) {
            
            HStack(spacing: 20) {
                
                FindPlayersRect()
                
                TradeAnalyzerRect()
//                DVHomePageSquare(imageStr: "doc.text.magnifyingglass", labelStr1: "Find Players")
//                DVHomePageSquare(imageStr: "gear.circle", labelStr1: "Settings")
            }
            
            HStack(spacing: 20) {
                SettingsRect()
                AccountRect()
//                DVHomePageSquare(imageStr: "arrow.2.squarepath", labelStr1: "Trade", labelStr2: "Analyzer", fontSize: 30)
//                DVHomePageSquare(imageStr: "gear.circle", labelStr1: "Settings")
            }
            
            DVHomeLeaguesRect()
                .padding()
                .background {
                    Color.niceGray.cornerRadius(7)
                }
                .padding()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color.backgroundBlue
        }
    }
}

struct DVHomePage_Previews: PreviewProvider {
    static var previews: some View {
        DVHomePage()
    }
}
