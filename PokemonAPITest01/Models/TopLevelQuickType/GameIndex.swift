// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let gameIndex = try? newJSONDecoder().decode(GameIndex.self, from: jsonData)

import Foundation

// MARK: - GameIndex
struct GameIndex: Codable {
    var gameIndex: Int?
    var version: Species?

    enum CodingKeys: String, CodingKey {
        case gameIndex = "game_index"
        case version
    }
}
