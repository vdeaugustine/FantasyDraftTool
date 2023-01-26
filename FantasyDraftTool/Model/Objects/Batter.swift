//
//  Player.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/11/23.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let player = try? JSONDecoder().decode(Player.self, from: jsonData)

import Foundation

// MARK: - JSONBatter

struct JSONBatter: Codable, Hashable {
    let name, team: String?
    let g, pa, hr, r: Int?
    let rbi, sb: Int?
    let bb, k: String?
    let iso, babip, avg, obp: Double?
    let slg, wOBA: Double?
    let wRC: Int?
    let bsR, off, def, war: Double?

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case team = "Team"
        case g = "G"
        case pa = "PA"
        case hr = "HR"
        case r = "R"
        case rbi = "RBI"
        case sb = "SB"
        case bb = "BB%"
        case k = "K%"
        case iso = "ISO"
        case babip = "BABIP"
        case avg = "AVG"
        case obp = "OBP"
        case slg = "SLG"
        case wOBA
        case wRC = "wRC+"
        case bsR = "BsR"
        case off = "Off"
        case def = "Def"
        case war = "WAR"
    }
}

// MARK: - Batter

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let player = try? JSONDecoder().decode(Player.self, from: jsonData)

struct Batter: Codable {
    let name, team: String
    let g, ab, pa, h: Int
    let singles, doubles, triples, hr: Int
    let r, rbi, bb, ibb: Int
    let so, hbp, sf, sh: Int
    let sb, cs: Int
    var avg: Double?

    var totalBases: Double {
        Double(singles) + (2 * Double(doubles)) + (3 * Double(triples)) + (4 * Double(hr))
    }

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
}

// MARK: Equatable, Hashable

extension Batter: Equatable, Hashable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.name == rhs.name &&
            lhs.team == rhs.team &&
            lhs.fantasyPoints(.defaultPoints) == rhs.fantasyPoints(.defaultPoints) &&
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

// struct Batter: Codable, Hashable {
//    let name, team: String
//    let g, pa, hr, r: Int
//    let rbi, sb: Int
//    let bb, k: String
//    let iso, babip, avg, obp: Double
//    let slg, wOBA: Double
//    let wRC: Int
//    let bsR, off, def, war: Double
//
//    var dict: [String: Any] {
//        ["name": name,
//         "team": team,
//         "g": g,
//         "pa": pa,
//         "hr": hr,
//         "r": r,
//         "rbi": rbi,
//         "sb": sb,
//         "bb": bb,
//         "k": k,
//         "iso": iso,
//         "babip": babip,
//         "avg": avg,
//         "obp": obp,
//         "slg": slg,
//         "wOBA": wOBA,
//         "wRC+": wRC,
//         "bsR": bsR,
//         "off": off,
//         "def": def,
//         "war": war]
//    }
//
//    init(_ jsonBatter: JSONBatter) {
//        self.name = jsonBatter.name ?? "NA"
//        self.team = jsonBatter.team ?? "NA"
//        self.g = jsonBatter.g ?? 999
//        self.pa = jsonBatter.pa ?? 999
//        self.hr = jsonBatter.hr ?? 999
//        self.r = jsonBatter.r ?? 999
//        self.rbi = jsonBatter.rbi ?? 999
//        self.sb = jsonBatter.sb ?? 999
//        self.bb = jsonBatter.bb ?? "999"
//        self.k = jsonBatter.k ?? "999"
//        self.iso = jsonBatter.iso ?? 99.999
//        self.babip = jsonBatter.babip ?? 99.999
//        self.avg = jsonBatter.avg ?? 99.999
//        self.obp = jsonBatter.obp ?? 99.999
//        self.slg = jsonBatter.slg ?? 99.999
//        self.wOBA = jsonBatter.wOBA ?? 99.999
//        self.wRC = jsonBatter.wRC ?? 999_999
//        self.bsR = jsonBatter.bsR ?? 9.999
//        self.off = jsonBatter.off ?? 9.999
//        self.def = jsonBatter.def ?? 9.999
//        self.war = jsonBatter.war ?? 9.999
//    }
// }

// extension Batter {
//    static let nullBatter: Batter = Batter(.nullBatter)
// }

extension Batter {
    func load<T: Decodable>(_ projectionType: ProjectionTypes = .steamer, position: Positions) -> T {
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

    static func getPlayers(projectionType: ProjectionTypes, position: Positions? = nil) -> [Batter] {
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
            for pos in Positions.batters {
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

extension Batter {
    func fantasyPoints(_ scoringSettings: ScoringSettings) -> Double {
        var points: Double = 0
        points += Double(hr) * scoringSettings.hr
        points += Double(r) * scoringSettings.r
        points += Double(rbi) * scoringSettings.rbi
        points += Double(sb) * scoringSettings.sb

        return points
    }
}

// MARK: - AllBatters

class AllBatters: Codable, Hashable, ObservableObject {
    @Published var batters: [Batter] = Batter.getPlayers(projectionType: .steamer, position: .c)
    @Published var editedBatters: [Batter] = []

    static var shared: AllBatters = .load() ?? AllBatters()

    init() {}

    static func == (lhs: AllBatters, rhs: AllBatters) -> Bool {
        lhs.batters == rhs.batters
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(batters)
    }

    static let key = "allBatters"
    enum CodingKeys: CodingKey {
        case batters
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.batters = try values.decode([Batter].self, forKey: .batters)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(batters, forKey: .batters)
    }

    static func load() -> AllBatters? {
        if let existing = UserDefaults.standard.data(forKey: "\(Self.key)") {
            do {
                let decoder = JSONDecoder()
                let prefs = try decoder.decode(AllBatters.self, from: existing)
                return prefs
            } catch {
                print(error)
            }
        }
        return nil
    }

    func save() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            UserDefaults.standard.set(data, forKey: Self.key)
        } catch {
            print(error)
        }
    }
}

extension AllBatters {
    func averagePoints(for position: Positions, projection: ProjectionTypes, topX: Int? = nil) -> Double {
        var batters = Batter.getPlayers(projectionType: projection, position: position)
        if let topX = topX { batters = Array(batters.prefix(topX)) }
        return batters.reduce(Double(0)) { $0 + $1.fantasyPoints(ScoringSettings.defaultPoints) }
    }

    static func averagePoints(forThese batters: [Batter]) -> Double {
        (batters.reduce(Double(0)) { $0 + $1.fantasyPoints(ScoringSettings.defaultPoints) } / Double(batters.count)).roundTo(places: 1)
    }
}

// MARK: - ProjectionTypes

enum ProjectionTypes: String, CaseIterable, Codable {
    case steamer, zips, batx, atc

    static let arr = [ProjectionTypes.steamer, ProjectionTypes.atc]

    var jsonFile: String { "\(rawValue)Standard" }
}

extension JSONBatter {
    func load<T: Decodable>(_ projectionType: ProjectionTypes = .steamer) -> T {
        let data: Data
        let filename = projectionType.jsonFile
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

//    static func getPlayers(projectionType: ProjectionTypes) -> [Batter] {
//        let fileName = projectionType.jsonFile
//        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: nil) else {
//            fatalError("Unable to find \(fileName)")
//        }
//        do {
//            let data = try Data(contentsOf: fileURL)
//            let players = try JSONDecoder().decode([JSONBatter].self, from: data)
//            var retPlayers = [Batter]()
//            for player in players {
//                retPlayers.append(Batter(player))
//            }
//            return retPlayers
//        } catch {
//            fatalError("Unable to read and decode \(fileName): \(error)")
//        }
//    }
}

extension JSONBatter {
    static let nullBatter = JSONBatter(name: "NULL Batter", team: "Angels", g: 999, pa: 999, hr: 999, r: 999, rbi: 999, sb: 999, bb: "99%", k: "99%", iso: 999, babip: 999, avg: 999, obp: 999, slg: 999, wOBA: 999, wRC: 999, bsR: 999, off: 999, def: 999, war: 999)
}
