// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let versionDetail = try? newJSONDecoder().decode(VersionDetail.self, from: jsonData)

import Foundation

// MARK: - VersionDetail
struct VersionDetail: Codable {
    var rarity: Int?
    var version: Species?
}
