// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let generationVi = try? newJSONDecoder().decode(GenerationVi.self, from: jsonData)

import Foundation

// MARK: - GenerationVi
struct GenerationVi: Codable {
    var frontDefault: String?
    var frontFemale: JSONNull?
    var frontShiny: String?
    var frontShinyFemale: JSONNull?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontFemale = "front_female"
        case frontShiny = "front_shiny"
        case frontShinyFemale = "front_shiny_female"
    }
}
