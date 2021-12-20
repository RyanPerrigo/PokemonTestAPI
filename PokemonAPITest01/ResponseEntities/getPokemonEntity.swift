//
//  getPokemonEntity.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 8/7/21.
//

import Foundation

struct GetPokemonRootEntity: Decodable {
    var count: Int
    var previous: String?
    var next: String?
    var results: [IndividualPokemonEntity]
}


struct IndividualPokemonEntity: Decodable {
	var name: String
	var url: String
}
