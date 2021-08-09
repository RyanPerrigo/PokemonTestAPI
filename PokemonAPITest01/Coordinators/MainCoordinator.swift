//
//  MainCoordinator.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 7/20/21.



import UIKit

enum AppLevelCoordinatingEvents {
	case appStart
	case appRefresh
	case startGame
	case singlePokemonClicked(_ responseURL:String)
}

class MainCoordinator: Coordinator {

	
	var children: [Coordinator]?
	var navController: UINavigationController
	
	init(navigationController:UINavigationController){
		self.navController = navigationController
	}
	
	func eventOccured(with type: AppLevelCoordinatingEvents) {
		switch type {
		case .appStart:
			let vm = MainVCM(apiManager: APIManager())
			let vc = MainVC.instantiate(withViewModel: vm)
			vc.coordinator = self
			UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
			UINavigationBar.appearance().shadowImage = UIImage()
			UINavigationBar.appearance().backgroundColor = .clear
			UINavigationBar.appearance().backIndicatorImage = UIImage()
			
			navController.setViewControllers([vc], animated: false)
			print("app start")
			
		case .appRefresh:
			
		print("app refresh")
		case .startGame:
			let vm = PokemonVCM(apiManager: APIManager())
			let vc = PokemonVC.instantiate(withViewModel: vm)
			vc.coordinator = self
			navController.pushViewController(vc, animated: true)
		case .singlePokemonClicked(let urlString):
			let vm = SinglePokemonVCM(apiManager: APIManager(), urlResponse: urlString)
			let vc = SinglePokemonVC.instantiate(withViewModel: vm)
			navController.pushViewController(vc, animated: true)
			
		}
		
	}
	
}
