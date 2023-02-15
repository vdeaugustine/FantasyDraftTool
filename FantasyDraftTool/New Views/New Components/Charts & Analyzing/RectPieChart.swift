//
//  RectPieChart.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/14/23.
//

import SwiftUI

struct RectPieChart: View {
    
    let data: [Double]
    var labels: [String] = []
    
    var sum: Double {
        data.reduce(0, {$0 + $1})
    }
    
    var colors: [Color] = [.red, .blue, .orange, .cyan, .green, .purple]
    
    var height: Double = 60
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Rectangle()
                    .foregroundColor(.gray)
                HStack(spacing: 0) {
                    ForEach(data.indices, id: \.self) { ind in
                        Rectangle()
                            .foregroundColor(colors[ind])
                            .frame(width: (data[ind] / sum) * geo.size.width)
                            .overlay {
                                
                                if let label = labels.safeGet(at: ind) {
                                    VStack {
                                        Text(label)
                                            .fontWeight(.semibold)
                                        Text(data[ind].str)
                                    }
                                    .padding(.vertical, 5)
                                    .minimumScaleFactor(0.75)
                                    .foregroundColor(.white)
                                }
                                
                            }
                    }
                }
            }
            
        }
        .height(height)
    }
}

struct RectPieChart_Previews: PreviewProvider {
    static var previews: some View {
        RectPieChart(data: [45, 36, 21], labels: ["Aaron Judge", "Top 5 OF", "OF Avg"])
            .previewLayout(.sizeThatFits)
    }
}
