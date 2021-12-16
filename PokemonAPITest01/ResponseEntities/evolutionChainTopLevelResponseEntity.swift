//
//  evolutionChainTopLevelResponseEntity.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 8/9/21.
//

import Foundation

struct EvolvesToObject: Codable {
	var is_baby: Bool
	var species: speciesObject
	var evolves_to: [EvolvesToObject]
}
struct ChainObject: Codable {
	var evolves_to: [EvolvesToObject]
}
struct EvolutionChainTopLevelEntity: Codable {
	var chain: ChainObject
	var id: Int
}
