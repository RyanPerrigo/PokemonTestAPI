// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let generationIii = try? newJSONDecoder().decode(GenerationIii.self, from: jsonData)

import Foundation

// MARK: - GenerationIii
struct GenerationIii: Codable {
    var emerald: Emerald?
    var fireredLeafgreen, rubySapphire: Crystal?

    enum CodingKeys: String, CodingKey {
        case emerald
        case fireredLeafgreen = "firered-leafgreen"
        case rubySapphire = "ruby-sapphire"
    }
}
