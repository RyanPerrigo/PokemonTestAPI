// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let heldItem = try? newJSONDecoder().decode(HeldItem.self, from: jsonData)

import Foundation

// MARK: - HeldItem
struct HeldItem: Codable {
    var item: Species?
    var versionDetails: [VersionDetail]?

    enum CodingKeys: String, CodingKey {
        case item
        case versionDetails = "version_details"
    }
}
