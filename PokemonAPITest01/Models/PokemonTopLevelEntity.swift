//
//  PokemonTopLevelEntity.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 7/24/21.
//

import Foundation

struct speciesObject: Codable{
	var name: String
	var url: String
}
struct version_groupObject: Codable {
	var name: String
	var url: String
}
struct move_learn_methodObject: Codable {
	var name: String
	var url: String
}

struct version_group_detailsObject: Codable {
	var level_learned_at: Int
	var move_learn_method: move_learn_methodObject
	var version_group: version_groupObject
}
struct moveObject: Codable {
	var name: String
	var url: String
}
struct movesObject: Codable {
	var move: moveObject
	var version_group_details: [version_group_detailsObject]
}
struct versionDetailsObject: Codable {
	var rarity: Int
	var version: versionObject
}
struct itemObject:Codable {
	var name: String
	var url: String
}
struct heldItemObject:Codable{
	var item: itemObject
	var version_details: [versionDetailsObject]
}
struct versionObject: Codable{
	var name: String
	var url: String
}

struct gameIndiciesObject: Codable {
	var game_index: Int
	var verson: versionObject
}

struct formObject: Codable {
	var name: String
	var url: String
}

struct ability: Codable {
	var name: String
	var url: String
}
struct ablitiyObject:Codable {
	var ability: ability
	var is_hidden: Bool
	var slot: Int
}
struct dream_worldObject: Codable{
	var front_default: String?
	var front_female: String?
}
struct officalArtworkObject: Codable {
	var front_default: String?
}
struct otherObject: Codable {
	var dream_world: dream_worldObject?
	var officialArtwork: officalArtworkObject?
	
	enum CodingKeys: String, CodingKey {
		case officialArtwork = "official-artwork"
	}
}
struct generationIObject:Codable {
	
}
struct versionsObject: Codable {
	var generationI: generationIObject
	
	enum CodingKeys: String, CodingKey {
		case generationI = "generation-i"
	}
}
struct spritesObject: Codable {
	var back_default: String?
	var back_female: String?
	var back_shiny: String?
	var back_shiny_female: String?
	var front_default: String?
	var front_female: String?
	var front_shiny: String?
	var front_shiny_female: String?
	var other: otherObject
	var versions: versionsObject
}
struct PokemonTopLevelEntity: Codable {
	var abilities: [ablitiyObject]?
	var base_experience: Int?
	var forms: [formObject]?
	var game_indicies: [gameIndiciesObject]?
	var height: Int?
	var held_items: [heldItemObject]?
	var id: Int?
	var is_default: Bool?
	var location_area_encounters: String?
	var moves: [movesObject]?
	var name: String?
	var order: Int?
	var species: speciesObject
	var sprites: spritesObject
	
}
