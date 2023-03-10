//
//  DVBatterDetail.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/8/23.
//

import SwiftUI

// MARK: - DVBatterDetail

struct DVBatterDetail: View {
    @EnvironmentObject private var model: MainModel

    let player: ParsedBatter

    var horizontalDivider: some View {
        RoundedRectangle(cornerRadius: 7)
            .height(1)
            .foregroundColor(.hexStringToColor(hex: "BEBEBE"))
    }

    var verticalDivider: some View {
        RoundedRectangle(cornerRadius: 7)
            .frame(width: 1)
            .foregroundColor(.hexStringToColor(hex: "BEBEBE"))
    }

    var body: some View {
        ScrollView {
            VStack {
                // MARK: - Header

                HStack {
                    Text("Mike Trout") // Name
                        .font(.system(size: 32))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "star") // Is a favorite
                        .font(.title2)
                        .foregroundColor(.hexStringToColor(hex: "BEBEBE"))
                }

                HStack(alignment: .bottom) {
                    // MARK: - Team and Position

                    HStack {
                        Text("OF") // Position
                        Text("•")
                        Text("LAA") // team
                    }
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                    Spacer()

                    // MARK: - Projection System

                    VStack(spacing: 7) {
                        Text("Proj. System")
                            .font(.system(size: 12))
                            .foregroundColor(.hexStringToColor(hex: "BEBEBE"))
                        Text("ATC") // proj system
                            .font(.system(size: 16))
                            .foregroundColor(Color.white)
                            .fontWeight(.semibold)
                    }
                    .padding(10)
                    .background {
                        Color.hexStringToColor(hex: "4A555D")
                            .cornerRadius(7)
                    }
                }

                // MARK: - Divider

                horizontalDivider.padding()

                // MARK: - Quick Numbers Bar

                HStack {
                    VStack(spacing: 7) {
                        Text("POS RANK")
                            .font(.system(size: 12))
                            .fontWeight(.medium)
                            .foregroundColor(.hexStringToColor(hex: "BEBEBE"))

                        Text("2")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    verticalDivider.padding(.horizontal, 7)
                    VStack(spacing: 7) {
                        Text("ADP")
                            .font(.system(size: 12))
                            .fontWeight(.medium)
                            .foregroundColor(.hexStringToColor(hex: "BEBEBE"))

                        Text("2")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    verticalDivider.padding(.horizontal, 7)
                    VStack(spacing: 7) {
                        Text("PROJ PTS")
                            .font(.system(size: 12))
                            .fontWeight(.medium)
                            .foregroundColor(.hexStringToColor(hex: "BEBEBE"))

                        Text("450")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    verticalDivider.padding(.horizontal, 7)
                    VStack(spacing: 7) {
                        Text("POS AVG")
                            .font(.system(size: 12))
                            .fontWeight(.medium)
                            .foregroundColor(.hexStringToColor(hex: "BEBEBE"))

                        Text("270")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }

                // MARK: - Analysis boxes row 1

                LazyVGrid(columns: GridItem.fixedItems(2, size: 170), spacing: 20) {
                    ForEach(player.relevantStatsKeys, id: \.self) { statKey in

                        if let position = player.positions.first,
                           let stat = player.dict[statKey] as? Int,
                           let dub = Double(stat) {
                            StatAnalysisBox(batterFullName: player.name,
                                            posStr: position.str,
                                            statKey: statKey,
                                            value: dub,
                                            percentile: 0.25,
                                            posAVG: dub - 50,
                                            allAvg: dub - 100)
                        }
                    }
                }
                .padding(.top)

                horizontalDivider.padding(40)

                // MARK: - Similar Players

                DVSimilarPlayers()
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .background {
            Color.hexStringToColor(hex: "33434F")
                .ignoresSafeArea()
        }
    }
}

// MARK: - DVSimilarPlayers

extension DVBatterDetail {
    struct DVSimilarPlayers: View {
        let player1: ParsedBatter = .player(by: "judge")
        let player2: ParsedBatter = .player(by: "mookie betts")
        let player3: ParsedBatter = .player(by: "harper")

        var verticalDivider: some View {
            RoundedRectangle(cornerRadius: 7)
                .frame(width: 1)
                .foregroundColor(.hexStringToColor(hex: "BEBEBE"))
                .padding(.vertical, 10)
        }

        func statWithColorBox(_ value: String, label: String, plusMinus: Int) -> some View {
            VStack(spacing: 5) {
                Text([value, label].joinString(" "))
                    .fontWeight(.light)
                    .foregroundColor(.white)
                    .font(.system(size: 12))

                Text(plusMinus.str)
                    .foregroundColor(.white)
                    .font(.system(size: 8))
                    .padding(.vertical, 3)
                    .padding(.horizontal, 7)
                    .background {
                        if plusMinus >= 0 {
                            Color.hexStringToColor(hex: "3DA100")
                                .cornerRadius(3)
                        } else {
                            Color.red
                                .cornerRadius(3)
                        }
                    }
            }
        }
        
        func row(_ player: ParsedBatter) -> some View {
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(player.name)
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                            
                        
                        Text([player.posStr(), player.team].joinString(" • "))
                            .font(.system(size: 12))
                            .fontWeight(.light)
                            .padding(.leading, 4)
                    }
                    .foregroundColor(.white)
                    
                    Spacer()

                    statWithColorBox(player.fantasyPoints(.defaultPoints).str, label: "pts", plusMinus: 82)

                    verticalDivider

                    statWithColorBox(20.9.str(), label: "ADP", plusMinus: -32)

                    verticalDivider

                    statWithColorBox("#10", label: "OF", plusMinus: 32)
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Label("Set as favorite", systemImage: "star.fill")
                            .labelStyle(.iconOnly)
                            .foregroundColor(.hexStringToColor(hex: "BFA30C"))
                    }
                    
                }

                .frame(maxWidth: .infinity)
    //                .pushLeft()
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background {
                    Color.hexStringToColor(hex: "4A555E")
                        .cornerRadius(7)
                        .shadow(radius: 1.5)
                }
            }
        }
        
        var horizontalDivider: some View {
            RoundedRectangle(cornerRadius: 7)
                .height(1)
                .foregroundColor(.hexStringToColor(hex: "BEBEBE"))
        }

        var body: some View {
            VStack {
                Text("Similar Players")
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .pushLeft()

                Text("Fantasy Points")
                    .foregroundColor(.hexStringToColor(hex: "BEBEBE"))
                    .fontWeight(.medium)
                    .font(.system(size: 16))
                    .pushLeft()
                    .padding(.leading, 7)
                    .padding(.top, 5)

                row(player1)
                row(player2)
                row(player3)
                
                horizontalDivider
                    .padding(50)
                
            }
        }
    }

    // MARK: - StatAnalysisBox

    struct StatAnalysisBox: View {
        let batterFullName: String
        let posStr: String
        let statKey: String
        let value: Double
        let percentile: Double
        let posAVG: Double
        let allAvg: Double

        var lastName: String {
            let fullArr = batterFullName.components(separatedBy: .whitespaces)
            return fullArr[1]
        }

        var body: some View {
            VStack {
                // Number header
                HStack(alignment: .bottom) {
                    Text("\(statKey):")
                        .font(.system(size: 16))
                        .fontWeight(.bold)

                    Text(Int(value).str)
                        .font(.system(size: 16))
                        .fontWeight(.medium)

                }.foregroundColor(.white)
                    .pushLeft().padding(.leading)

                // Percentile bar

                PercentileBar(percentile: percentile)
                    .frame(height: 20)
                    .padding(.horizontal)

                // MARK: - Bars

                BarsForStat(lastName: lastName,
                            positionStr: posStr,
                            playerValue: value,
                            positionAvg: posAVG,
                            allAvg: allAvg)
            }
            .padding(.vertical, 5)
            .padding(.top, 3)
            .frame(width: 153, height: 160)
            .background {
                Color.hexStringToColor(hex: "4A555E").cornerRadius(7)
            }
        }
        // MARK: - BarsForStat
        struct BarsForStat: View {
            let lastName: String
            let positionStr: String
            let playerValue: Double
            let positionAvg: Double
            let allAvg: Double

            enum GreatestValue {
                case player, position, all
            }

            var greatestValue: Double {
                [playerValue, positionAvg, allAvg].sorted(by: >).first!
            }

            func height(for barValue: Double, totalHeight: CGFloat) -> CGFloat {
                let fraction = barValue / greatestValue
                return fraction * totalHeight * 0.65
            }

            var body: some View {
                VStack {
                    GeometryReader { geo in
                        HStack(alignment: .bottom) {
                            // Batter's
                            VStack {
                                Text("\(Int(playerValue))")
                                    .font(.system(size: 8))
                                    .foregroundColor(.white)
                                Rectangle()
                                    .foregroundColor(.hexStringToColor(hex: "5364FF"))
                                    .frame(width: 25, height: height(for: playerValue, totalHeight: geo.size.height))
                                Text(lastName)
                                    .font(.system(size: 8))
                                    .foregroundColor(.white)
                            }

                            VStack {
                                Text(Int(positionAvg).str)
                                    .font(.system(size: 8))
                                    .foregroundColor(.white)
                                Rectangle()
                                    .foregroundColor(.hexStringToColor(hex: "54D6FF"))
                                    .frame(width: 25,
                                           height: height(for: positionAvg, totalHeight: geo.size.height))
                                Text(positionStr)
                                    .font(.system(size: 8))
                                    .foregroundColor(.white)
                            }

                            VStack(spacing: 5) {
                                Text(Int(allAvg).str)
                                    .font(.system(size: 8))
                                    .foregroundColor(.white)
                                Rectangle()
                                    .foregroundColor(.hexStringToColor(hex: "54FFE0"))
                                    .frame(width: 25, height: height(for: allAvg, totalHeight: geo.size.height))
                                Text("All")
                                    .font(.system(size: 8))
                                    .foregroundColor(.white)
                            }
                        }
                        .centerInParentView()
                        .height(geo.size.height)
                    }
                }
            }
        }

        // MARK: - PercentileBar
        struct PercentileBar: View {
            let percentile: Double

            var body: some View {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .foregroundColor(.hexStringToColor(hex: "D9D9D9"))
                            .height(2)

                        HStack {
                            Circle()
                                .foregroundColor(.hexStringToColor(hex: "D9D9D9"))
                            Spacer()
                            Circle()
                                .foregroundColor(.hexStringToColor(hex: "D9D9D9"))
                            Spacer()
                            Circle()
                                .foregroundColor(.hexStringToColor(hex: "D9D9D9"))
                        }
                        .frame(width: geo.size.width, height: 5)

                        ZStack {
                            Circle()
                                .foregroundColor(.getColorFromValue(percentile))
                                .height(15)

                            Text(Int(percentile * 100).str)
                                .font(.system(size: 8))
                                .foregroundColor(.white)
                        }
                        .position(x: geo.size.width * percentile, y: geo.size.height / 2)
                    }
                    .frame(width: geo.size.width)
                }
            }
        }
        
        
        
        
        
        
    }

    

    

    

    
}


// MARK: - DVBatterDetail_Previews

struct DVBatterDetail_Previews: PreviewProvider {
    static var previews: some View {
        DVBatterDetail(player: .TroutOrNull)
    }
}