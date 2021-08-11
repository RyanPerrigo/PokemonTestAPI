// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let move = try? newJSONDecoder().decode(Move.self, from: jsonData)

import Foundation

// MARK: - Move
struct Move: Codable {
    var move: Species?
    var versionGroupDetails: [VersionGroupDetail]?

    enum CodingKeys: String, CodingKey {
        case move
        case versionGroupDetails = "version_group_details"
    }
}
