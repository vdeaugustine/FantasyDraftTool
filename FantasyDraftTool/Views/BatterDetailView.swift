//
//  BatterDetailView.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/11/23.
//

import SwiftUI

// MARK: - BatterDetailView

struct BatterDetailView: View {
    @EnvironmentObject private var model: AllBatters
    @State var batter: Batter
    @State var selectedProjType: ProjectionTypes = .steamer
    @State private var showAlertThatNoPlayerFoundForProjection = false

    var body: some View {
        VStack {
            Picker("Projection Type", selection: $selectedProjType) {
                ForEach(ProjectionTypes.arr, id: \.self) { type in
                    Text(type.rawValue.uppercased())
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .onChange(of: selectedProjType) { newProjectionType in
                if let newBatter = Batter.getPlayers(projectionType: newProjectionType).first(where: { thisBatter in
                    thisBatter.name == batter.name
                }) {
                    batter = newBatter
                } else {
                    showAlertThatNoPlayerFoundForProjection.toggle()
                }
            }
            List {
                Text("Points")
                    .spacedOut(text: batter.fantasyPoints(.defaultPoints).str)

                Section("Totals") {
                    Group {
                        Text("H")
                            .spacedOut(text: batter.h.str)
                        Text("1B")
                            .spacedOut(text: batter.singles.str)
                        Text("2B")
                            .spacedOut(text: batter.doubles.str)
                        Text("3B")
                            .spacedOut(text: batter.triples.str)
                        Text("HR")
                            .spacedOut(text: batter.hr.str)
                        Text("RBI")
                            .spacedOut(text: batter.rbi.str)
                        Text("R")
                            .spacedOut(text: batter.r.str)
                        Text("SB")
                            .spacedOut(text: batter.sb.str)
                        Text("CS")
                            .spacedOut(text: batter.cs.str)
                        Text("K")
                            .spacedOut(text: batter.so.str)
                    }
                    Text("TB")
                        .spacedOut(text: batter.totalBases.str)
                }

                Section("Points") {
                    Group {
                        Text("TB")
                            .spacedOut(text: ScoringSettings.defaultPoints.fantasyPoints(for: ScoringSettings.Statistic.tb, for: batter).str)
                        Text("SO")
                            .spacedOut(text: ScoringSettings.defaultPoints.fantasyPoints(for: ScoringSettings.Statistic.so, for: batter).str)
                    }
                }
            }
        }
        .navigationTitle(batter.name + ": \(batter.team)")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.listBackground)
        .alert("\(batter.name) is not found in the list for this projection", isPresented: $showAlertThatNoPlayerFoundForProjection) {
            Button("OK") {}
        }
    }
}

// MARK: - BatterDetailView_Previews

struct BatterDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BatterDetailView(batter: AllBatters.shared.batters.first!)
            .environmentObject(AllBatters.shared)
            .putInNavView()
    }
}
