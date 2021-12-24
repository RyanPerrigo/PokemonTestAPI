// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let other = try? newJSONDecoder().decode(Other.self, from: jsonData)

import Foundation

// MARK: - Other
struct Other: Codable {
    var dreamWorld: DreamWorld?
    var officialArtwork: OfficialArtwork?
    

    enum CodingKeys: String, CodingKey {
        case dreamWorld = "dream_world"
        case officialArtwork = "official-artwork"
    }
}
struct HomeObject: Codable {
    var frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}
