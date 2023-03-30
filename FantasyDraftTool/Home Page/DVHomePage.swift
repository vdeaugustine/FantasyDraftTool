//
//  DVHomePage.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/16/23.
//

import SwiftUI

struct DVHomePage: View {
    
    @EnvironmentObject private var model: MainModel
    
    
    @State private var showConfirmation = false
    
    @State private var draftSelected: Draft? = nil
    var confirmationMessage: String {
        guard let draftSelected = draftSelected else {
            return "Error selecting draft. Please hit cancel"
        }
        return "Are you sure you want to enter \(draftSelected.leagueName)? This will overwrite any current draft that has not been saved."
    }
    
    
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
            
            DVHomeLeaguesRect(showConfirmation: $showConfirmation, draftSelected: $draftSelected)
                .padding()
                .background {
                    MainModel.shared.specificColor.rect.cornerRadius(7)
                }
                .padding()
                .navigationDestination(for: DraftDestination.self) { draftDestination in
                    switch draftDestination {
                    case .loadDraft:
                        DVDraft()
                    case .newDraft:
                        DVDraft()
                    case .setupDraft:
                        SetupDraftView()
                    }
                }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            MainModel.shared.specificColor.background
        }
        .confirmationDialog(confirmationMessage, isPresented: $showConfirmation, titleVisibility: .visible) {
            Button("Enter", role: .destructive) {
                guard let draftSelected = draftSelected else { return }
                model.draft = draftSelected
                model.navPathForDrafting.append(DraftDestination.loadDraft)
            }
            
            Button("Cancel", role: .cancel) { }
            
        }
        .navigationDestination(for: DraftDestination.self) { draftDestination in
            switch draftDestination {
            case .loadDraft:
                DVDraft()
            case .newDraft:
                DVDraft()
            case .setupDraft:
                DVSetUpLeagueView()
            }
        }
    }
}

struct DVHomePage_Previews: PreviewProvider {
    static var previews: some View {
        DVHomePage()
            .environmentObject(MainModel.shared)
            
    }
}
