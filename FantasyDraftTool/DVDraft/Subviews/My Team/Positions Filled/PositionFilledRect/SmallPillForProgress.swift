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
            return MainModel.shared.specificColor.nice
        } else {
            return MainModel.shared.specificColor.nice.opacity(0.10)
        }
    }
    
    var body: some View {
        ZStack {
            color
                .cornerRadius(7)
            RoundedRectangle(cornerRadius: 7)
                .stroke(lineWidth: 0.25)
                .foregroundColor(MainModel.shared.specificColor.lighter)
                
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
