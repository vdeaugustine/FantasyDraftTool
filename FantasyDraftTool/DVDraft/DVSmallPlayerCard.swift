//
//  DVSmallPlayerCard.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/14/23.
//

import SwiftUI

// MARK: - DVSmallPlayerCard

struct DVSmallPlayerCard: View {
    @EnvironmentObject private var model: MainModel

    @Binding var playerForCard: ParsedPlayer?
    let player: ParsedPlayer
    @Binding var showDraftConfirmation: Bool

    var verticalDivider: some View {
        RoundedRectangle(cornerRadius: 7)
            .frame(width: 1)
            .foregroundColor(MainModel.shared.specificColor.lighter)
    }

    var starImage: String {
        model.isStar(player) ? "star.fill" : "star"
    }

    
    var starColor: Color {
        model.isStar(player) ? .pointsGold : .lighterGray
    }

    var horizontalDivider: some View {
        RoundedRectangle(cornerRadius: 7)
            .height(1)
            .foregroundColor(MainModel.shared.specificColor.lighter)
    }

    var body: some View {
        VStack(spacing: 27) {
            VStack(spacing: 10) {
                HStack {
                    Text(player.name) // Name
                        .font(.system(size: 32))
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Spacer()
                    Image(systemName: starImage) // Is a favorite
                        .font(.title2)
                        .foregroundColor(starColor)
                }

                HStack(alignment: .top) {
                    // MARK: - Team and Position

                    VStack(alignment: .leading) {
                        HStack {
                            Text(player.posStr()) // Position
                            Text("•")
                            Text(player.team) // team
                        }
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    }

                    Spacer()
                    
                    Button {
                        showDraftConfirmation.toggle()
                    } label: {
                        Text("Draft #\(model.draft.totalPickNumber + 1) OVR")
                            .font(size: 16, color: .white, weight: .medium)
                            .padding(.horizontal, 10)
                            .background(color: MainModel.shared.specificColor.nice, padding: 7)
                    }
                    .buttonStyle(.plain)
                }
            }

            VStack {
                // MARK: - Quick Numbers Bar

                HStack {
                    VStack(spacing: 7) {
                        Text("POS RANK")
                            .font(.system(size: 12))
                            .fontWeight(.medium)
                            .foregroundColor(MainModel.shared.specificColor.lighter)

                        Text("2")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    verticalDivider.padding(.horizontal, 7)
                    VStack(spacing: 7) {
                        Text("ADP")
                            .font(.system(size: 12))
                            .fontWeight(.medium)
                            .foregroundColor(MainModel.shared.specificColor.lighter)

                        Text("2")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    verticalDivider.padding(.horizontal, 7)
                    VStack(spacing: 7) {
                        Text("PROJ PTS")
                            .font(.system(size: 12))
                            .fontWeight(.medium)
                            .foregroundColor(MainModel.shared.specificColor.lighter)

                        Text("450")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    verticalDivider.padding(.horizontal, 7)
                    VStack(spacing: 7) {
                        Text("POS AVG")
                            .font(.system(size: 12))
                            .fontWeight(.medium)
                            .foregroundColor(MainModel.shared.specificColor.lighter)

                        Text("270")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
                .frame(maxHeight: 45)
                
                
                horizontalDivider
                    .padding(.vertical, 5)

                
                VStack {
                    
                    if let adp = player.adp,
                       let diff = Int(adp) - model.draft.currentPickNumber
                    {
                        Text("Player will most likely be drafted in approximately \(diff) picks")
                            .font(size: 16, color: MainModel.shared.specificColor.lighter, weight: .light)
                            .lineLimit(2)
                            .layoutPriority(1)
                    }
                    
                    Spacer()
                    
                    // MARK: - Action Buttons
                    HStack {
                        
                        Button {
                            playerForCard = nil
                        } label: {
                            Text("Cancel")
                                .font(size: 16, color: .white, weight: .medium)
                                .padding(.horizontal, 10)
                                .background(color: MainModel.shared.specificColor.rect, padding: 7)
                        }
                        .buttonStyle(.plain)
                        
                        Spacer()
                        
                        NavigationLink {
                            
                            
                            if let batter = player as? ParsedBatter {
                                DVBatterDetailDraft(draftPlayer: .init(player: batter, draft: model.draft))
                            }
                          //                                model.navPathForDrafting.append(batter)
                          //                            }
//                                                      if let pitcher = player as? ParsedPitcher {
//                                                          model.navPathForDrafting.append(pitcher)
                            
                          
                        } label: {
                            Text("Go to Player Page")
                                .font(size: 16, color: .white, weight: .medium)
                                .padding(.horizontal, 10)
                                .background(color: MainModel.shared.specificColor.nice, padding: 7)
                        }
                        .buttonStyle(.plain)
                        
//                        Button {
//                            playerForCard = nil
//
//
////                            if let batter = player as? ParsedBatter {
////                                model.navPathForDrafting.append(batter)
////                            }
////                            if let pitcher = player as? ParsedPitcher {
////                                model.navPathForDrafting.append(pitcher)
////                            }
//                        } label: {
//                            Text("Go to Player Page")
//                                .font(size: 16, color: .white, weight: .medium)
//                                .padding(.horizontal, 10)
//                                .background(color: .niceBlue, padding: 7)
//                        }
//                        .buttonStyle(.plain)
                        
                    }
                    .padding(.horizontal, 10)
                }
            }

            
        }
        .frame(maxWidth: 430, maxHeight: 270)
        .background(color: MainModel.shared.specificColor.background, padding: 10)
        .navigationDestination(for: ParsedBatter.self) { batter in
            DVBatterDetailDraft(draftPlayer: .init(player: batter, draft: model.draft))
        }
    }
}

// MARK: - DVSmallPlayerCard_Previews

struct DVSmallPlayerCard_Previews: PreviewProvider {
    static var previews: some View {
        DVSmallPlayerCard(playerForCard: .constant(ParsedBatter.TroutOrNull), player: ParsedBatter.TroutOrNull, showDraftConfirmation: .constant(false))
            .environmentObject(MainModel.shared)
    }
}