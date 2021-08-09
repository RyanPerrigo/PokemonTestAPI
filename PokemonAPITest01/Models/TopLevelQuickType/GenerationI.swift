// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let generationI = try? newJSONDecoder().decode(GenerationI.self, from: jsonData)

import Foundation

// MARK: - GenerationI
struct GenerationI: Codable {
    var redBlue, yellow: RedBlue?

    enum CodingKeys: String, CodingKey {
        case redBlue = "red-blue"
        case yellow
    }
}
