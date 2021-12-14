//
//  SinglePokemonVC.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 8/7/21.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable


class SinglePokemonDetailVC: UIViewController, ViewModelBased, StoryboardBased, Coordinating {
	
	
	var coordinator: MainCoordinator?
	
	
	
	
	
	var viewModel: SinglePokemonDetailVCM?
	private let disposeBag = DisposeBag()
	
	@IBOutlet weak var dynamicCollectionView: DynamicCollectionView!
	
	override func viewDidLoad() {
		
		viewModel?
			.screenStateObservable()
			.subscribe(onNext: { singlePokemonScreenState in
				
				switch singlePokemonScreenState {
				
				case .loading:
					print("loading")
				case .success(holderModels: let holderModels):
					self.dynamicCollectionView.pushImmutableList(holderModels: holderModels)
				case .error:
					print("ERROR DUDE")
				}
			}
			)
			.disposed(by: disposeBag )
		
		viewModel?.navToEvolutionsClicked = { theSpeciesUrl in
			self.coordinator?.eventOccured(with: .pokeEvolutionOverviewClicked(theSpeciesUrl))
		}
		
		viewModel?.populateViewModels()
	}
	
	
	
}
