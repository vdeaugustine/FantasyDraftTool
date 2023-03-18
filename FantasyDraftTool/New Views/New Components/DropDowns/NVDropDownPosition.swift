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
                    Label("ALL", systemImage: selection == nil ? "checkmark" : "")
                }
                Divider()
            }
            ForEach(positions, id: \.self) { position in
                Button {
                    selection = position
                } label: {
                    Label(position.str.uppercased(), systemImage: selection == position ? "checkmark" : "")
                }
            }
        } label: {
            
            HStack {
                Text(selection?.str.uppercased() ?? "ALL")
                    .fontWeight(.semibold)
                Image(systemName: "baseball.diamond.bases")
            }
            .font(font)
            .foregroundColor(.white)
            .background(color: MainModel.shared.specificColor.nice, padding: 6)
            .buttonStyle(.plain)
        }
        
    }
}

struct NVDropDownPosition_Previews: PreviewProvider {
    static var previews: some View {
        NVDropDownPosition(selection: .constant(Position.ss))
            .previewLayout(.sizeThatFits)
    }
}
