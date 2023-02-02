//
//  SelectSinglePositionTypeHScroll.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/30/23.
//

import SwiftUI

// MARK: - SelectSinglePositionTypeHScroll

struct SelectSinglePositionTypeHScroll: View {
    @Binding var selectedPosition: Position
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(Position.batters, id: \.self) { position in
                    Button {
                        withAnimation {
                            selectedPosition = position
                        }
                    } label: {
                        Text(position.str.uppercased())
                            .foregroundColor(selectedPosition == position ? Color.white : Color.black)
                            .padding()
                            .height(25)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(lineWidth: 1)
                            )
                            .background(selectedPosition == position ? Color.blue : Color.clear)
                            .cornerRadius(10)
                            .padding([.vertical, .leading], 2)
                    }
                }
            }
        }
    }
}

// MARK: - SelectSinglePositionTypeHScroll_Previews

struct SelectSinglePositionTypeHScroll_Previews: PreviewProvider {
    static var previews: some View {
        SelectSinglePositionTypeHScroll(selectedPosition: .constant(.first))
    }
}
