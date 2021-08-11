// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let typeElement = try? newJSONDecoder().decode(TypeElement.self, from: jsonData)

import Foundation

// MARK: - TypeElement
struct TypeElement: Codable {
    var slot: Int?
    var type: Species?
}
