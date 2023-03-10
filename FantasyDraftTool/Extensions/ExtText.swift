//
//  ExtText.swift
//  Paycheck Visualizer Redesign
//
//  Created by Vincent DeAugustine on 10/9/22.
//

import Foundation
import SwiftUI




extension Text {
    init(_ dub: Double) {
        self.init(dub.str)
    }
    
    init(_ player: ParsedBatter) {
        self.init(player.name)
    }
    
    init(_ draftPlayer: DraftPlayer) {
        self.init(draftPlayer.player.name)
    }

    
    init(_ arr: [String], sep: String = " ") {
        self.init(arr.joinString(sep))
    }
    
    
    func grayOptionText() -> some View {
        fontWeight(.semibold)
            .foregroundColor(.hexStringToColor(hex: "757575"))
    }

    func spacedOut<Content: View>(@ViewBuilder otherView: () -> Content) -> some View {
        HStack {
            self
            Spacer()
            otherView()
        }
    }

    func spacedOut(text: String) -> some View {
        HStack {
            self
            Spacer()
            Text(text)
        }
    }

    func customSwitch(_ condition: Bool, fontSize: CGFloat = 24) -> some View {
        let selectedFontWeight: Font.Weight = .heavy
        let selectedFontSize: CGFloat = fontSize
        let nonSelectedFontWeight: Font.Weight = .bold
        let nonSelectedFontSize: CGFloat = fontSize - 4
        let selectedColor: Color = Color("PrototypeBlue")
        let nonSelectedColor: Color = Color("ItemCardText")
        return VStack(spacing: 1) {
            self
                .fontWeight(condition ? selectedFontWeight : nonSelectedFontWeight)
                .font(.system(size: condition ? selectedFontSize : nonSelectedFontSize))
                .lineLimit(1)

            if condition {
                Rectangle()
                    .frame(height: 2)
                    .padding(.horizontal, 10)
            }
        }
        .foregroundColor(condition ? selectedColor : nonSelectedColor)
        .minimumScaleFactor(0.85)
    }

    func labelForOption() -> Text {
        fontWeight(.semibold)
            .foregroundColor(.hexStringToColor(hex: "757575"))
            .font(.system(size: 22))
    }

    func labelForValue() -> Text {
        fontWeight(.heavy)
            .font(.system(size: 20))
    }

    func headerFormat() -> Text {
        font(.system(size: 24))
            .fontWeight(.semibold)
    }

    func makeHeader() -> some View {
        HStack {
            self
                .headerFormat()
            Spacer()
        }
        .padding(.bottom)
    }
}
