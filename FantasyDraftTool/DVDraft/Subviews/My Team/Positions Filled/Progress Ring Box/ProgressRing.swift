//
//  ProgressRing.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/11/23.
//

import SwiftUI

// MARK: - ProgressRing

struct ProgressRing: View {
    @EnvironmentObject private var model: MainModel

    let completed: Int
    let needed: Int

    var percent: Double {
        Double(completed) / Double(needed)
    }

//    var percent: Double
//    var widthHeight: CGFloat = 105
//    var textToShowInMiddle: String? = nil
//    var lineWidth: CGFloat = 2
    var body: some View {
        ZStack {
            VStack(spacing: 6) {
                VStack(spacing: 2) {
                    Text(completed.str).font(size: 18, color: "BEBEBE", weight: .medium)

                    RoundedRectangle(cornerRadius: 7)
                        .frame(width: 20, height: 1.5)
                        .foregroundColor(.hexStringToColor(hex: "BEBEBE"))
//                            .padding(.vertical, 10)

                    Text(needed.str).font(size: 18, color: "BEBEBE", weight: .medium)
                }
                
                
                Text("Picks").font(size: 12, color: "BEBEBE", weight: .medium)
            }
            .padding(28)
            .overlay {
                
                ZStack {
                    Circle()
                        .stroke(lineWidth: 5)
                        .foregroundColor(.hexStringToColor(hex: "BEBEBE"))
                    Circle()
                        .trim(from: .leastNonzeroMagnitude, to: percent > 0.05 ? percent : 0.05)
                        .stroke(lineWidth: 5)
                        .rotationEffect(.degrees(-90))
                        .rotation3DEffect(.degrees(180), axis: (x: 0.0, y: 1.0, z: 0.0))
                        .foregroundColor(Color.hexStringToColor(hex: "305294"))
                }
                
            }

//                ZStack {
//                    Circle()
//                        .stroke(lineWidth: lineWidth)
//                        .foregroundColor(.gray)
//                    Circle()
//                        .trim(from: .leastNonzeroMagnitude, to: percent > 0.05 ? percent : 0.05)
//                        .stroke(lineWidth: lineWidth)
//                        .rotationEffect(.degrees(-90))
//                        .rotation3DEffect(.degrees(180), axis: (x: 0.0, y: 1.0, z: 0.0))
//                        .foregroundColor(Color.hexStringToColor(hex: "305294"))
            ////                        .foregroundColor(model.themeColor)
//                    if let textToShowInMiddle = textToShowInMiddle {
//                        Text(textToShowInMiddle)
//                            .minimumScaleFactor(0.2)
//                            .padding(.horizontal, 2)
//                    }
//                }
//                .frame(width: widthHeight - 10, height: widthHeight - 10)
        }

        .frame(width: 105, height: 105)
    }
}

// MARK: - ProgressRing_Previews

struct ProgressRing_Previews: PreviewProvider {
    static var previews: some View {
        ProgressRing(completed: 8, needed: 25)
            .environmentObject(MainModel.shared)
    }
}
