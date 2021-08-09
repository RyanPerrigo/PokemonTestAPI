// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let generationVii = try? newJSONDecoder().decode(GenerationVii.self, from: jsonData)

import Foundation

// MARK: - GenerationVii
struct GenerationVii: Codable {
    var icons: DreamWorld?
    var ultraSunUltraMoon: GenerationVi?

    enum CodingKeys: String, CodingKey {
        case icons
        case ultraSunUltraMoon = "ultra-sun-ultra-moon"
    }
}
