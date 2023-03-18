//
//  NVSortByDropDown.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/14/23.
//

import SwiftUI

// MARK: - NVSortByDropDown

struct NVSortByDropDown: View {
    @Binding var selection: Options
    var font: Font = .callout
    
    var body: some View {
        Menu {
            ForEach(Options.stats, id: \.self) { option in
                Button {
                    selection = option
                } label: {
                    Label(option.str, systemImage: option == selection ? "checkmark" : "")
                }
            }
            Divider()
            ForEach(Options.other, id: \.self) { option in
                Button {
                    selection = option
                } label: {
                    Label(option.str.uppercased(), systemImage: option == selection ? "checkmark" : "")
                }
            }

        } label: {
            HStack {
                Text(selection.str.uppercased())
                    .fontWeight(.semibold)
                Image(systemName: "line.3.horizontal.decrease")
            }
            .font(font)
            .foregroundColor(.white)
            .background(color: MainModel.shared.specificColor.nice, padding: 6)
            .buttonStyle(.plain)
                
//            .overlay {
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(lineWidth: 1)
//            }
        }
            
    }

    enum Options {
        case points, score, hr, rbi, r, sb

        var str: String {
            switch self {
                case .points:
                    return "Points"
                case .score:
                    return "Score"
                case .hr:
                    return "HR"
                case .rbi:
                    return "RBI"
                case .r:
                    return "R"
                case .sb:
                    return "SB"
            }
        }

        static let stats: [Options] = [.hr, .rbi, .r, .sb]
        static let other: [Options] = [.points, .score]
    }
}

// MARK: - NVSortByDropDown_Previews

struct NVSortByDropDown_Previews: PreviewProvider {
    static var previews: some View {
        NVSortByDropDown(selection: .constant(.points))
    }
}
