//
//  DVDraftViewModel.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/13/23.
//

import Foundation
import SwiftUI

extension Color {
    static let niceBlue: Color = .hexStringToColor(hex: "305294")
    static let niceGray: Color = .hexStringToColor(hex: "4A555E")
    static let lighterGray: Color = .hexStringToColor(hex: "BEBEBE")
    static let pointsGold: Color = .hexStringToColor(hex: "8B7500")
    static let backgroundBlue: Color = .hexStringToColor(hex: "33434F")
}

class DVDraftViewModel: ObservableObject {
    let dropDownFont: Font = .system(size: 14)

    @Published var amountOfAvailablePlayersToShow: Int = 10
    @Published var showSpinnerForPlayers: Bool = true
    @Published var availablePlayers: [ParsedPlayer] = []
    
    
    
    
}
