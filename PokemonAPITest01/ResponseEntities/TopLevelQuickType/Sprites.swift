// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let sprites = try? newJSONDecoder().decode(Sprites.self, from: jsonData)

import Foundation

// MARK: - Sprites
class Sprites: Codable {
    var backDefault: String?
    var backFemale: JSONNull?
    var backShiny: String?
    var backShinyFemale: JSONNull?
    var frontDefault: String?
    var frontFemale: JSONNull?
    var frontShiny: String?
    var frontShinyFemale: JSONNull?
    var other: Other?
    var versions: Versions?
    var animated: Sprites?

    enum CodingKeys: String, CodingKey {
        case backDefault = "back_default"
        case backFemale = "back_female"
        case backShiny = "back_shiny"
        case backShinyFemale = "back_shiny_female"
        case frontDefault = "front_default"
        case frontFemale = "front_female"
        case frontShiny = "front_shiny"
        case frontShinyFemale = "front_shiny_female"
        case other, versions, animated
    }

    init(backDefault: String?, backFemale: JSONNull?, backShiny: String?, backShinyFemale: JSONNull?, frontDefault: String?, frontFemale: JSONNull?, frontShiny: String?, frontShinyFemale: JSONNull?, other: Other?, versions: Versions?, animated: Sprites?) {
        self.backDefault = backDefault
        self.backFemale = backFemale
        self.backShiny = backShiny
        self.backShinyFemale = backShinyFemale
        self.frontDefault = frontDefault
        self.frontFemale = frontFemale
        self.frontShiny = frontShiny
        self.frontShinyFemale = frontShinyFemale
        self.other = other
        self.versions = versions
        self.animated = animated
    }
}
