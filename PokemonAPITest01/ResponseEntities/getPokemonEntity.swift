//
//  getPokemonEntity.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 8/7/21.
//

import Foundation

struct resultsObject: Decodable {
	var name: String
	var url: String
}
struct GetPokemonEntity: Decodable {
	var count: Int
	var next: String
	var previous: String?
	var results: [resultsObject]
}
