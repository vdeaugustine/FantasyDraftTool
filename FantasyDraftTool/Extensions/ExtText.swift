//
//  ExtText.swift
//  Paycheck Visualizer Redesign
//
//  Created by Vincent DeAugustine on 10/9/22.
//

import Foundation
import SwiftUI




extension Text {
    /// An extension to the Text type that provides an initializer for creating a text view from a Double value.
    ///
    /// - Parameter dub: A Double value to be converted to a string and used as the text for the view.
    ///
    /// This extension adds an initializer to the Text type that takes a Double value as its argument. The str computed property is used to convert the Double value to a string, which is then passed to the default Text initializer to create the text view.

    /// The resulting Text view is then created and can be used to display the string representation of the Double value.
    init(_ dub: Double) {
        self.init(dub.str)
    }
    
    /// An initializer for the Text type that creates a text view from a ParsedBatter object.
    ///
    /// - Parameter player: A ParsedBatter object representing a baseball batter.
    ///
    /// This initializer takes a ParsedBatter object as its argument and creates a text view using the batter's name, which is accessed using the name property of the ParsedBatter object.

    /// The resulting Text view is then created and can be used to display the batter's name.
    init(_ player: ParsedBatter) {
        self.init(player.name)
    }
    
    /// An initializer for the Text type that creates a text view from a DraftPlayer object.
    ///
    /// - Parameter draftPlayer: A DraftPlayer object representing a drafted baseball player.
    ///
    /// This initializer takes a DraftPlayer object as its argument and creates a text view using the drafted player's name, which is accessed using the player property of the DraftPlayer object.

    /// The resulting Text view is then created and can be used to display the drafted player's name.
    init(_ draftPlayer: DraftPlayer) {
        self.init(draftPlayer.player.name)
    }

    /// An initializer for the Text type that creates a text view from an array of String values.
    ///
    /// - Parameters:
    /// - arr: An array of String values to be combined into a single string and used as the text for the view.
    /// - sep: A separator string used to separate the values in the array. The default value is " ".
    ///
    /// This initializer takes an array of String values as its argument and creates a text view using the combined string created from the array's values. The joinString() method is called with the sep parameter to combine the String values into a single string.

    /// The resulting Text view is then created and can be used to display the combined string created from the array's values.
    init(_ arr: [String], sep: String = " ") {
        self.init(arr.joinString(sep))
    }
    
    
    func grayOptionText() -> some View {
        fontWeight(.semibold)
            .foregroundColor(.hexStringToColor(hex: "757575"))
    }

    
    /// An extension to the Text type that provides a method for adding spacing and another view to a text view.
    ///
    /// - Parameter otherView: A closure returning a View to be added to the text view with additional spacing.
    ///
    /// - Returns: A modified Text view with the original text and additional view separated by a spacer.
    ///
    /// This extension adds a method to the Text type that modifies the view to include an additional view separated from the original text by a spacer. The original text is included in the view with the self parameter.

    /// The otherView parameter is used to create a new View that displays the additional content. The two views and a spacer are then combined into an HStack view and returned as the result of this method.
    func spacedOut<Content: View>(@ViewBuilder otherView: () -> Content) -> some View {
        HStack {
            self
            Spacer()
            otherView()
        }
    }

    /// An extension to the Text type that provides a method for adding spacing and additional text to a text view.
    ///
    /// - Parameter text: A String value to be added to the text view with additional spacing.
    ///
    /// - Returns: A modified Text view with the original text and additional text separated by a spacer.
    ///
    /// This extension adds a method to the Text type that modifies the view to include additional text separated from the original text by a spacer. The original text is included in the view with the self parameter.

    /// The text parameter is used to create a new Text view that displays the additional text. The two Text views and a spacer are then combined into an HStack view and returned as the result of this method.
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
