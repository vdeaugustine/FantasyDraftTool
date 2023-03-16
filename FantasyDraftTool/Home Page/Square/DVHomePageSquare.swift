//
//  DVHomePageSquare.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/16/23.
//

import SwiftUI

// MARK: - DVHomePageSquare


struct FindPlayersRect: View {
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 15) {
                Image(systemName: "doc.text.magnifyingglass")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36, height: 48)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.cyan, .white, .white)
                
                Text("Find Players")
                    .font(size: 18, color: .white, weight: .semibold)
            }
            .pushLeft()
            Spacer()
        }
        .padding([.leading, .top])
        .frame(width: 150, height: 140)
        .background(color: .niceGray, padding: 0)
    }
}

struct SettingsRect: View {
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 15) {
                Image(systemName: "gear.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36, height: 48)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.cyan, .white, .white)
                
                Text("Settings")
                    .font(size: 18, color: .white, weight: .semibold)
            }
            .pushLeft()
            Spacer()
        }
        .padding([.leading, .top])
        .frame(width: 150, height: 140)
        .background(color: .niceGray, padding: 0)
    }
}

struct TradeAnalyzerRect: View {
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 15) {
                Image(systemName: "arrow.2.squarepath")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36, height: 48)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.cyan, .white, .white)
                
                VStack(alignment: .leading) {
                    Text("Trade")
                    Text("Analyzer")
                }
                    .font(size: 18, color: .white, weight: .semibold)
            }
            .pushLeft()
            Spacer()
        }
        .padding([.leading, .top])
        .frame(width: 150, height: 140)
        .background(color: .niceGray, padding: 0)
    }
}

struct AccountRect: View {
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 15) {
                Image(systemName: "person.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36, height: 48)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.cyan, .white, .white)
                
                Text("Account")
                    .font(size: 18, color: .white, weight: .semibold)
            }
            .pushLeft()
            Spacer()
        }
        .padding([.leading, .top])
        .frame(width: 150, height: 140)
        .background(color: .niceGray, padding: 0)
    }
}

//struct DVHomePageSquare: View {
//    let imageStr: String
//    let labelStr1: String
//    var labelStr2: String? = nil
//    var fontSize: CGFloat = 37
//    var body: some View {
//        HStack {
//            VStack(alignment: .leading, spacing: 14) {
//                Image(systemName: imageStr)
//                    .symbolRenderingMode(.palette)
////                    .font(.system(size: fontSize))
//                    .resizable()
//                    .foregroundStyle(.cyan, .white, .white)
//                    .aspectRatio(contentMode: .fit)
////                    .padding(.top, 20)
//                    .frame(height: 48)
//                Spacer()
//                VStack(alignment: .leading) {
//                    Text(labelStr1)
//                    if let labelStr2 = labelStr2 {
//                        Text(labelStr2)
//                    }
//                }
////                .padding(.bottom, 20)
//                .lineLimit(2)
//                .font(size: 20, color: .white, weight: .semibold)
//                .pushLeft()
//
//                Spacer()
//            }
//            .frame(width: 150, height: 140)
//        }
//        .background(color: .niceGray, padding: 0, radius: 7, shadow: 1)
////        .padding([.top, .leading], 20)
//
//
//    }
//}

// MARK: - DVHomePageSquare_Previews

struct DVHomePageSquare_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AccountRect()
        }
//        DVHomePageSquare(imageStr: "arrow.2.squarepath", labelStr1: "Trade", labelStr2: "Analyzer", fontSize: 30)
    }
}
