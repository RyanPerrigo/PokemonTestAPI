// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let redBlue = try? newJSONDecoder().decode(RedBlue.self, from: jsonData)

import Foundation

// MARK: - RedBlue
struct RedBlue: Codable {
    var backDefault, backGray, frontDefault, frontGray: JSONNull?

    enum CodingKeys: String, CodingKey {
        case backDefault = "back_default"
        case backGray = "back_gray"
        case frontDefault = "front_default"
        case frontGray = "front_gray"
    }
}
