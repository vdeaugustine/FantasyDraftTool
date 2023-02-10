//
//  Player.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/11/23.

import Foundation

// MARK: - Batter


struct Batter: Codable {
    // MARK: Stored Properties
    let name, team: String
    let g, ab, pa, h: Int
    let singles, doubles, triples, hr: Int
    let r, rbi, bb, ibb: Int
    let so, hbp, sf, sh: Int
    let sb, cs: Int
    var avg: Double?

    // MARK: - Computed Properties
    var totalBases: Double {
        Double(singles) + (2 * Double(doubles)) + (3 * Double(triples)) + (4 * Double(hr))
    }

    var dict: [String: Any] {
        ["Name": name,
         "Team": team,
         "G": g,
         "AB": ab,
         "PA": pa,
         "H": h,
         "1B": singles,
         "2B": doubles,
         "3B": triples,
         "HR": hr,
         "R": r,
         "RBI": rbi,
         "BB": bb,
         "IBB": ibb,
         "SO": so,
         "HBP": hbp,
         "SF": sf,
         "SH": sh,
         "SB": sb,
         "CS": cs,
         "AVG": avg ?? 0]
    }
    
    // MARK: - Methods
    func fantasyPoints(_ scoringSettings: ScoringSettings) -> Double {
        var points: Double = 0
        points += Double(hr) * scoringSettings.hr
        points += Double(r) * scoringSettings.r
        points += Double(rbi) * scoringSettings.rbi
        points += Double(sb) * scoringSettings.sb

        return points
    }
}

// MARK: - Codable Equatable, Hashable

extension Batter: Equatable, Hashable {
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case team = "Team"
        case g = "G"
        case ab = "AB"
        case pa = "PA"
        case h = "H"
        case singles = "1B"
        case doubles = "2B"
        case triples = "3B"
        case hr = "HR"
        case r = "R"
        case rbi = "RBI"
        case bb = "BB"
        case ibb = "IBB"
        case so = "SO"
        case hbp = "HBP"
        case sf = "SF"
        case sh = "SH"
        case sb = "SB"
        case cs = "CS"
        case avg = "AVG"
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.name == rhs.name &&
            lhs.team == rhs.team &&
            lhs.fantasyPoints(MainModel.shared.getScoringSettings()) == rhs.fantasyPoints(MainModel.shared.getScoringSettings()) &&
            lhs.ab == rhs.ab
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(team)
        hasher.combine(g)
        hasher.combine(ab)
        hasher.combine(pa)
        hasher.combine(h)
        hasher.combine(singles)
        hasher.combine(doubles)
        hasher.combine(triples)
        hasher.combine(hr)
        hasher.combine(r)
        hasher.combine(rbi)
        hasher.combine(bb)
        hasher.combine(ibb)
        hasher.combine(so)
        hasher.combine(hbp)
        hasher.combine(sf)
        hasher.combine(sh)
        hasher.combine(sb)
        hasher.combine(cs)
        hasher.combine(avg)
    }
}

// MARK: Loading
extension Batter {
    func load<T: Decodable>(_ projectionType: ProjectionTypes = .steamer, position: Position) -> T {
        let data: Data
        let filename = projectionType.jsonFile + position.str + ".json"
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }

        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }

    static func getPlayers(projectionType: ProjectionTypes, position: Position? = nil) -> [Batter] {
        if let position = position {
            let fileName = projectionType.jsonFile + position.str + ".json"
            guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: nil) else {
                fatalError("Unable to find \(fileName)")
            }
            do {
                let data = try Data(contentsOf: fileURL)
                let players = try JSONDecoder().decode([Batter].self, from: data)
                return players
            } catch {
                fatalError("Unable to read and decode \(fileName): \(error)")
            }
        } else {
            var retarr = [Batter]()
            for pos in Position.batters {
                let fileName = projectionType.jsonFile + pos.str + ".json"
                guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: nil) else {
                    fatalError("Unable to find \(fileName)")
                }
                do {
                    let data = try Data(contentsOf: fileURL)
                    let players = try JSONDecoder().decode([Batter].self, from: data)
                    retarr += players
                } catch {
                    fatalError("Unable to read and decode \(fileName): \(error)")
                }
            }
            return retarr
        }
    }
}





