//
//  NVDropDown.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/14/23.
//

import SwiftUI

// MARK: - NVDropDownProjection

struct NVDropDownProjection: View {
    @Binding var selection: ProjectionTypes
    var font: Font = .callout
    var body: some View {
        Menu {
            ForEach(ProjectionTypes.batterArr, id: \.self) { projectionType in
                Button {
                    selection = projectionType
                } label: {
                    Text(projectionType.title)
                }
            }
        } label: {
            HStack {
                Text(selection.title)

                    .fontWeight(.semibold)
                Image(systemName: "chart.xyaxis.line")
            }
            .font(font)
            .padding(7)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 1)
            }
        }
    }
}

// MARK: - NVDropDownProjection_Previews

struct NVDropDownProjection_Previews: PreviewProvider {
    static var previews: some View {
        NVDropDownProjection(selection: .constant(ProjectionTypes.steamer))
            .previewLayout(.sizeThatFits)
    }
}
