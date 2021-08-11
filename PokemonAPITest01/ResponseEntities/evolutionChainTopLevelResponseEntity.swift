//
//  evolutionChainTopLevelResponseEntity.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 8/9/21.
//

import Foundation

struct evolvesToObject: Codable {
	var is_baby: Bool
	var species: speciesObject
	var evolves_to: [evolvesToObject]
}
struct chainObject: Codable {
	var evolves_to: [evolvesToObject]
}
struct EvolutionChainTopLevelEntity: Codable {
	var chain: chainObject
	var id: Int
}
