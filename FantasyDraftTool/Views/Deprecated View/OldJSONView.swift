//
//  ContentView.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/11/23.
//

import SwiftUI

// MARK: - ContentView

struct OldJSONView: View {
    @State private var selectedProjType: ProjectionTypes = .steamer
    @State private var playersPerPosition: Int = 20

    func filteredBatters(_ position: Position) -> [Batter] {
        Array(
            Batter
                .getPlayers(projectionType: selectedProjType,
                            position: position)
                .sorted(by: { $0.fantasyPoints(.defaultPoints) > $1.fantasyPoints(.defaultPoints) })
                .prefix(playersPerPosition)
        )
    }

    var body: some View {
        VStack {
            Picker("Projection Type", selection: $selectedProjType) {
                ForEach(ProjectionTypes.arr, id: \.self) { type in
                    Text(type.rawValue.uppercased())
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            

            List {
                ForEach(Position.batters, id: \.self) { pos in
                    Section {
                        ForEach(filteredBatters(pos), id: \.self) { player in
                            NavigationLink {
                                BatterDetailView(batter: player, selectedProjType: selectedProjType)
                            } label: {
                                Text(player.name)
                                    .spacedOut(text: player.fantasyPoints(ScoringSettings.defaultPoints).str)
                            }
                        }
                    } header: {
                        Text(pos.str)
                            .spacedOut(text:
                                AllBatters.averagePoints(forThese: filteredBatters(pos)).str)
                    }
                }
            }
        }
        .background(Color.listBackground)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu(playersPerPosition.str) {
                    VStack {
                        Button("Players per position") {}
                        Divider()
                        ForEach(1 ... 30, id: \.self) { num in
                            Button {
                                playersPerPosition = num
                            } label: {
                                Text(num.str)
                            }
                        }
                    }
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    
                    
                    
                } label: {
                    Label("Sort", systemImage: "line.3.horizontal.decrease")
                }
            }
        }
        .navigationTitle("Players List")
        .putInNavView(displayMode: .inline)
    }
}

// MARK: - ContentView_Previews

struct OldJSONView_Previews: PreviewProvider {
    static var previews: some View {
        OldJSONView()
    }
}
