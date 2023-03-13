//
//  DVDraftViewModel.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/13/23.
//

import Foundation
import SwiftUI

class DVDraftViewModel: ObservableObject {
    let dropDownFont: Font = .system(size: 14)

    @Published var amountOfAvailablePlayersToShow: Int = 10
    @Published var showSpinnerForPlayers: Bool = true
    @Published var availablePlayers: [ParsedPlayer] = []
}
