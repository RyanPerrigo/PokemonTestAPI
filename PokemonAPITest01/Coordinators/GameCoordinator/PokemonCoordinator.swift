//
//  PokemonCoordinator.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 8/8/21.
//

import UIKit

enum pokemonCoordinatingEvents{
	case someEvent
}
class PokemonCoordinator: Coordinator {
	
	var navController: UINavigationController
	
	var children: [Coordinator]?
	
	init(navController: UINavigationController){
		self.navController = navController
	}
	
	func eventOccuredWithType(event: pokemonCoordinatingEvents) {
		
		switch event {
		case .someEvent:
			print("something")
		}
	}
}
