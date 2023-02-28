//
//  SmallComponents.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/24/23.
//

import SwiftUI

// MARK: - LabelAndValueRect

struct LabelAndValueRect: View {
    let label: String
    let value: String
    var color: Color = .white

    var body: some View {
        
            VStack {
                Text(label.uppercased())
                    .fontWeight(.medium)
                Divider().padding(.horizontal, 10)
                Text(value)
            }
            .padding(10)
            .font(.caption2)
            .background {
                color
                    .cornerRadius(10)
                    .shadow(radius: 0.7)
            }
            .minimumScaleFactor(0.5)
            
        
    }
}

// MARK: - LabelAndValueRect_Previews

struct LabelAndValueRect_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.listBackground

            LabelAndValueRect(label: "G", value: "125")
                .frame(width: 70)
                .previewLayout(.sizeThatFits)
//                .previewLayout(.fixed(width: 100, height: 100))
        }
    }
}
