//
//  ContentView.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/26/23.
//

import SwiftUI

extension Array where Element: Hashable {
    func removingDuplicates() -> Self {
        Array(Set(self))
    }
}

// MARK: - AllBattersListView

struct AllBattersListView: View {
    @State private var projection: ProjectionTypes = .steamer
    @State private var selectedPositions: Set<Positions> = []
    
    var batters: [ParsedBatter] {
        
        if selectedPositions.isEmpty {
            return AllParsedBatters.batters(for: projection).removingDuplicates().sorted(by: { $0.fantasyPoints(.defaultPoints) > $1.fantasyPoints(.defaultPoints) })
        }
        
        return selectedPositions.reduce([ParsedBatter]()) { partialResult, pos in
            partialResult + AllParsedBatters.batters(for: projection, at: pos)
        }
        .removingDuplicates()
        .sorted(by: { $0.fantasyPoints(.defaultPoints) > $1.fantasyPoints(.defaultPoints) })
    }
    
    var body: some View {
        VStack {
            Picker("Projection", selection: $projection) {
                ForEach(ProjectionTypes.arr, id: \.self) { proj in
                    Text(proj.title)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    Button{
                        selectedPositions = []
                    } label: {
                        Text("All".uppercased())
                            .foregroundColor(selectedPositions.isEmpty ? Color.white : Color.black)
                            .padding()
                            .height(25)
                            .overlay (
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(lineWidth: 1)
                                    
                            )
                            .background( selectedPositions.isEmpty ? Color.blue : Color.clear )
                            .cornerRadius(10)
                            .padding([.vertical, .leading], 2)
                    }
                    
                    
                    ForEach(Positions.batters, id: \.self) { pos in
                        
                        Button {
                            if selectedPositions.contains(pos) {
                                selectedPositions.remove(pos)
                            } else {
                                selectedPositions.insert(pos)
                            }
                        } label: {
                            Text(pos.str.uppercased())
                                .foregroundColor(selectedPositions.contains(pos) ? Color.white : Color.black)
                                .padding()
                                .height(25)
                                .overlay (
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(lineWidth: 1)
                                        
                                )
                                .background( selectedPositions.contains(pos) ? Color.blue : Color.clear )
                                .cornerRadius(10)
                                .padding([.vertical, .leading], 2)
                        }
                        .buttonStyle(.plain)
                        
                    }
                }
            }
            .padding(.horizontal)
            

            List {
                ForEach(batters, id: \.self) { batter in

                    NavigationLink {
                        ParsedBatterDetailView(batter: batter, projection: projection)
                    } label: {
                        Text(batter.name)
                            .spacedOut(text: batter.fantasyPoints(.defaultPoints).str)
                    }
                }
            }
        }
        .background(Color.listBackground)
    }
}

// MARK: - AllBattersListView_Previews

struct AllBattersListView_Previews: PreviewProvider {
    static var previews: some View {
        AllBattersListView()
            .putInNavView()
    }
}
