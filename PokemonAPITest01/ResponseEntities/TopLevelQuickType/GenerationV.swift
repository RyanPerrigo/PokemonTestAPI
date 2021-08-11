// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let generationV = try? newJSONDecoder().decode(GenerationV.self, from: jsonData)

import Foundation

// MARK: - GenerationV
struct GenerationV: Codable {
    var blackWhite: Sprites?

    enum CodingKeys: String, CodingKey {
        case blackWhite = "black-white"
    }
}
