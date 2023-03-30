//
//  ColorSelectionView.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/17/23.
//

import SwiftUI

struct ColorSelectionView: View {
    
    // Available color options
    let colorOptions: [SpecificColors] = [.firstOne, .mysterious, .nightSky, .crimsonSunset, .goldenHarvest, .natureWalk, .purpleHaze]
    
    // Selected color
    @State var selectedColor: SpecificColors = .firstOne
    
    @EnvironmentObject private var model: MainModel
    
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Select a color scheme:")
                    .font(.headline)
                
                // Display each color option as a button
                ForEach(colorOptions, id: \.self) { colorOption in
                    Button(action: {
                        // Set the selected color when a color option is selected
                        self.selectedColor = colorOption
                        model.specificColor = colorOption
                    }) {
                        VStack(spacing: 10) {
                            Rectangle()
                                .foregroundColor(colorOption.rect)
                                .frame(width: 50, height: 50)
                            
                            
                            Text(colorOption.niceStr)
                                .font(.caption)
                                .foregroundColor(.white)
                                .background {
                                    Rectangle()
                                        .foregroundColor(colorOption.nice)
                                        .frame(width: 50, height: 20)
                                        .cornerRadius(10)
                                }
                            
                            
                            
                            
                            
                        }
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
        }
        .padding()
    }
}


struct ColorSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ColorSelectionView()
    }
}
