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
	case singlePokemonClicked(_ topLevelPokemonEntity:PokemonTopLevelEntity?,_ pokeUrl: String?)
	case pokeEvolutionOverviewClicked(_ evolutionUrl: String)
//	case evolvedPokemonClicked(_ topLevelPokeURL: String)
}

class MainCoordinator: Coordinator {

	
	var children: [Coordinator]?
	var navController: UINavigationController
	
	init(navigationController:UINavigationController){
		self.navController = navigationController
	}
	
	func eventOccured(with type: AppLevelCoordinatingEvents) {
		
		print("Event Occured with type: \(type)")
		
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
			break

			
		case .appRefresh:
			break
			
			
		case .startGame:
			let vm = PokemonSearchVM(apiManager: APIManager())
			let vc = PokemonSearchVC.instantiate(withViewModel: vm)
			vc.coordinator = self
			navController.pushViewController(vc, animated: true)
			break
			
		case .singlePokemonClicked(let topLevelPokemonEntity, let urlString):
			
			let vm = SinglePokemonDetailVM(
				apiManager: APIManager(),
				topLevelPokeEntity: topLevelPokemonEntity,
				pokeUrl: urlString
			)
			
			let vc = SinglePokemonDetailVC.instantiate(withViewModel: vm)
			vc.coordinator = self
			navController.pushViewController(vc, animated: true)
			break
			
		case .pokeEvolutionOverviewClicked(let evolutionUrl):
			
			let vm = PokeEvolutionOverviewVM(speciesUrl: evolutionUrl)
			let vc = PokeEvolutionOverviewVC.instantiate(withViewModel: vm)
			vc.coordinator = self
			navController.pushViewController(vc, animated: true)
			break
			
//		case .evolvedPokemonClicked(let topLevelPokeUrl):
//
//			let vm = EvolvedPokeVCM(urlString: topLevelPokeUrl)
//			let vc = EvolvedPokeVC.instantiate(withViewModel: vm)
//			vc.coordinator = self
//			navController.pushViewController(vc, animated: true)
		
		}
		
		
		
	}
	
}
