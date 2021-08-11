// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let generationIi = try? newJSONDecoder().decode(GenerationIi.self, from: jsonData)

import Foundation

// MARK: - GenerationIi
struct GenerationIi: Codable {
    var crystal, gold, silver: Crystal?
}
