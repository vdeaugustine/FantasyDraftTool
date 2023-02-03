//
//  SelectProjectionTypeHScroll.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/30/23.
//

import SwiftUI

struct SelectProjectionTypeHScroll: View {
    @Binding var selectedProjectionType: ProjectionTypes
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(ProjectionTypes.allArr, id: \.self) { projectionType in
                    Button {
                        
                        withAnimation {
                            selectedProjectionType = projectionType
                        }
                    } label: {
                        Text(projectionType.str.uppercased())
                            .foregroundColor(selectedProjectionType == projectionType ? Color.white : Color.black)
                            .padding()
                            .height(25)
                            .overlay (
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(lineWidth: 1)
                                    
                            )
                            .background( selectedProjectionType == projectionType ? Color.blue : Color.clear )
                            .cornerRadius(10)
                            .padding([.vertical, .leading], 2)
                    }
                }
            }
        }
    }
}

struct SelectProjectionTypeHScroll_Previews: PreviewProvider {
    
    static var previews: some View {
        SelectProjectionTypeHScroll(selectedProjectionType: .constant(.steamer))
    }
}
