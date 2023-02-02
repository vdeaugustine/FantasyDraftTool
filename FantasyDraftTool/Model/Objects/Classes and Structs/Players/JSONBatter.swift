// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let jSONBatter = try? JSONDecoder().decode(JSONBatter.self, from: jsonData)

import Foundation

// MARK: - JSONBatter

struct JSONBatter: Codable, Hashable, Equatable {
    // MARK: Stored properties

    var empty, name, team, g: String
    var ab, pa, h, the1B: String
    var the2B, the3B, hr, r: String
    var rbi, bb, ibb, so: String
    var hbp, sf, sh, sb: String
    var cs, avg: String
}

// MARK: - Codable, Hashable, Equatable

extension JSONBatter {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.name == rhs.name &&
            lhs.team == rhs.team &&
            lhs.ab == rhs.ab &&
            lhs.pa == rhs.pa &&
            lhs.h == rhs.h &&
            lhs.sf == rhs.sf &&
            lhs.r == rhs.r
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(team)
        hasher.combine(ab)
        hasher.combine(pa)
        hasher.combine(h)
        hasher.combine(sf)
        hasher.combine(r)
        hasher.combine(team)
        hasher.combine(ab)
    }

    enum CodingKeys: String, CodingKey {
        case empty = "#"
        case name = "Name"
        case team = "Team"
        case g = "G"
        case ab = "AB"
        case pa = "PA"
        case h = "H"
        case the1B = "1B"
        case the2B = "2B"
        case the3B = "3B"
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
}

// MARK: - Loading from Data

extension JSONBatter {
    static func loadBatters(_ filename: String) -> [JSONBatter] {
        let data: Data

        guard let file = Bundle.main.url(forResource: filename, withExtension: ".json")
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
            let arr = try decoder.decode([JSONBatter].self, from: data)
            return Array(Set<JSONBatter>(arr)).sorted(by: { $0.empty < $1.empty })
        } catch {
            fatalError("Couldn't parse \(filename) as \(JSONBatter.self):\n\(error)")
        }
    }

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
}
