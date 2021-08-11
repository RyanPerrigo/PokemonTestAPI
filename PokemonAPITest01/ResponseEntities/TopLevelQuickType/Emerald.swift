// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let emerald = try? newJSONDecoder().decode(Emerald.self, from: jsonData)

import Foundation

// MARK: - Emerald
struct Emerald: Codable {
    var frontDefault, frontShiny: String?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
    }
}
