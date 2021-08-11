//
//  Coordinator.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 7/20/21.
//

import UIKit


protocol Coordinator {
	var navController: UINavigationController {get set}
	var children: [Coordinator]? {get set}
	
}
protocol Coordinating {
	associatedtype CoordinatorType = Coordinator
	var coordinator: CoordinatorType? {get set}
}
