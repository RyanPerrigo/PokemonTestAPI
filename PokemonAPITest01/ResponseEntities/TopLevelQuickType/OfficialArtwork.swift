// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let officialArtwork = try? newJSONDecoder().decode(OfficialArtwork.self, from: jsonData)

import Foundation

// MARK: - OfficialArtwork
struct OfficialArtwork: Codable {
    var frontDefault: String?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}
