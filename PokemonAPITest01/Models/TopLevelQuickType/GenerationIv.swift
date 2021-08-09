// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let generationIv = try? newJSONDecoder().decode(GenerationIv.self, from: jsonData)

import Foundation

// MARK: - GenerationIv
struct GenerationIv: Codable {
    var diamondPearl, heartgoldSoulsilver, platinum: Sprites?

    enum CodingKeys: String, CodingKey {
        case diamondPearl = "diamond-pearl"
        case heartgoldSoulsilver = "heartgold-soulsilver"
        case platinum
    }
}
