//
//  SmallPillForProgress.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/11/23.
//

import SwiftUI

struct SmallPillForProgress: View {
    let isFilled: Bool
    
    var color: Color {
        if isFilled {
            return .hexStringToColor(hex: "305294")
        } else {
            return .hexStringToColor(hex: "305294").opacity(0.10)
        }
    }
    
    var body: some View {
        ZStack {
            color
                .cornerRadius(7)
            RoundedRectangle(cornerRadius: 7)
                .stroke(lineWidth: 0.25)
                .foregroundColor(Color.hexStringToColor(hex: "BEBEBE"))
                
        }
        
        .frame(width: 15, height: 4)
    }
}

struct SmallPillForProgress_Previews: PreviewProvider {
    static var previews: some View {
        SmallPillForProgress(isFilled: false)
            .previewLayout(.sizeThatFits)
    }
}
