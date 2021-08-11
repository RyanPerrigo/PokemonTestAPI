// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let dreamWorld = try? newJSONDecoder().decode(DreamWorld.self, from: jsonData)

import Foundation

// MARK: - DreamWorld
struct DreamWorld: Codable {
    var frontDefault: String?
    var frontFemale: JSONNull?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontFemale = "front_female"
    }
}
