//
//  SpeciesResponseEntity.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 8/9/21.
//

import Foundation

struct varietiesObject: Codable {
	
}
struct evolutionChainObject: Codable {
	var url: String
}

struct SpeciesResponseEntity: Codable {
	var evolution_chain: evolutionChainObject
	var varieties: [varietiesObject]
}
