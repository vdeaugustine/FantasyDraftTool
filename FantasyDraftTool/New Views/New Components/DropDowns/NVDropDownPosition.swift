//
//  NVDropDownPosition.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/14/23.
//

import SwiftUI

struct NVDropDownPosition: View {
    @Binding var selection: Position?
    var positions: [Position] = Position.batters
    var font: Font = .callout
    var showAll: Bool = true
    var showBorder: Bool = true
    
    var body: some View {
        
        Menu {
            
            if showAll {
                Button {
                    selection = nil
                } label: {
                    Text("ALL")
                }
                Divider()
            }
            ForEach(positions, id: \.self) { position in
                Button {
                    selection = position
                } label: {
                    Text(position.str.uppercased())
                }
            }
        } label: {
            
            HStack {
                Text(selection?.str.uppercased() ?? "ALL")
                    .fontWeight(.semibold)
                Image(systemName: "baseball.diamond.bases")
            }
            .font(font)
            .padding(7)
            .overlay {
                if showBorder {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 1)
                }
                
            }
        }
        
    }
}

struct NVDropDownPosition_Previews: PreviewProvider {
    static var previews: some View {
        NVDropDownPosition(selection: .constant(Position.ss))
            .previewLayout(.sizeThatFits)
    }
}
