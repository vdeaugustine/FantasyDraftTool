//
//  SelectPositionsHScroll.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/30/23.
//

import SwiftUI

struct SelectPositionsHScroll: View {
    
    @Binding var selectedPositions: Set<Position>
    var body: some View {
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
                
                
                ForEach(Position.batters, id: \.self) { pos in
                    
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
    }
}

struct SelectPositionsHScroll_Previews: PreviewProvider {
    static var previews: some View {
        SelectPositionsHScroll(selectedPositions: .constant([]))
    }
}
