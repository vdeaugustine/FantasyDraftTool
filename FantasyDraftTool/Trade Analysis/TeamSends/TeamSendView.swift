//
//  TeamSendView.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/18/23.
//

import SwiftUI

struct TeamSendView: View {
    @Binding var teamSends: [ParsedPlayer]
    @Binding var showSearch: Bool
    @Binding var searchText: String
    @Binding var filteredPlayers: [ParsedPlayer]
    @Binding var isSearching: Bool
    
    
    let teamName: String
    
    var body: some View {
        VStack(spacing: 15) {
            Text("\(teamName) Sends")
                .font(size: 20, color: .white, weight: .medium)
                .pushLeft()

            ForEach(teamSends.indices, id: \.self) { playerInd in
                if let player = teamSends.safeGet(at: playerInd) {
                    PlayerBasicStatRow(player: player)
                }
            }

            if showSearch {
                VStack {
                    Text("Add Players")
                        .font(size: 16, color: MainModel.shared.specificColor.lighter, weight: .medium)
                        .pushLeft()
                        .padding(.leading)
                    SearchTextField(searchText: $searchText, placeholder: "Player Name")
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                    
                    if filteredPlayers.isEmpty == false {
                        ZStack {
                            ScrollView {
                                LazyVStack {
                                    ForEach(filteredPlayers.indices, id: \.self) { playerInd in

                                        if let batter = filteredPlayers.safeGet(at: playerInd) as? ParsedBatter {
                                            PlayerBasicStatRowButton(player: batter) {
                                                if !teamSends.contains(batter) {
                                                    teamSends.append(batter)
                                                }
                                                searchText = ""
                                            }
                                        }

                                        if let pitcher = filteredPlayers.safeGet(at: playerInd) as? ParsedPitcher {
                                            PlayerBasicStatRowButton(player: pitcher) {
                                                if !teamSends.contains(pitcher) {
                                                    teamSends.append(pitcher)
                                                }
                                                searchText = ""
                                            }
                                        }
                                    }
                                    .listRowBackground(Color.clear)
                                    Spacer()
                                }
                            }
                            .height(200)
                            .listStyle(.plain)
                            .cornerRadius(7)

                            if isSearching {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(2)
                            }
                        }
                    } else {
                        Spacer()
                    }

                }
            }

            if showSearch {
                doneButton()
            } else {
                addPlayerButton()
            }
        }
    }
    
    func addPlayerButton() -> some View {
        Button {
            showSearch = true
            
        } label: {
            Label("Add Player", systemImage: "plus")
                .font(size: 16, color: .white, weight: .semibold)
                .frame(maxWidth: .infinity)
                .height(44)
                .background(color: MainModel.shared.specificColor.rect, padding: 0)
        }
    }


    
    func doneButton() -> some View {
        Button {
           showSearch = false
            
        } label: {
            Label("Done", systemImage: "checkmark.circle.fill")
                .font(size: 16, color: .white, weight: .semibold)
                .frame(maxWidth: .infinity)
                .height(44)
                .background(color: MainModel.shared.specificColor.nice, padding: 0)
        }
    }
}


//struct TeamSendView_Previews: PreviewProvider {
//    static var previews: some View {
//        TeamSendView(
//            teamSends: .constant([]),
//            showSearch: .constant([]),
//            searchText: .constant(""),
//            filteredPlayers: $team2FilteredPlayers,
//            isSearching: $isSearching,
//            teamName: "Team 2",
//            doneButtonAction: {
//                // Your action for the done button
//            },
//            addPlayerButtonAction: {
//                // Your action for the add player button
//            }
//        )
//    }
//}
