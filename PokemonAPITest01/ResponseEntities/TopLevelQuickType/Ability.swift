// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let ability = try? newJSONDecoder().decode(Ability.self, from: jsonData)

import Foundation

// MARK: - Ability
struct Ability: Codable {
    var ability: Species?
    var isHidden: Bool?
    var slot: Int?

    enum CodingKeys: String, CodingKey {
        case ability
        case isHidden = "is_hidden"
        case slot
    }
}
