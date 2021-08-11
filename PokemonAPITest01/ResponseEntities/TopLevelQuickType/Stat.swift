// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let stat = try? newJSONDecoder().decode(Stat.self, from: jsonData)

import Foundation

// MARK: - Stat
struct Stat: Codable {
    var baseStat, effort: Int?
    var stat: Species?

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort, stat
    }
}
