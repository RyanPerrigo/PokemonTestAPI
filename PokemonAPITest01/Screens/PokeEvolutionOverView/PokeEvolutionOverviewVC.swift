//
//  PokeEvolutionOverviewVC.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 8/9/21.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable


class PokeEvolutionOverviewVC: UIViewController, ViewModelBased, StoryboardBased, Coordinating{
	
	var coordinator: MainCoordinator?
	var viewModel: PokeEvolutionOverviewVCM?
	private let disposeBag = DisposeBag()
	@IBOutlet weak var dynamicCollectionView: DynamicCollectionView!
	
	
	
	
	override func viewDidLoad() {
		
		
		
        viewModel?.viewStateObservable().subscribe(onNext: {
            viewState in
            
            switch viewState {
            case .start:
                return
            case .loading:
                return
            case .success(let holderModels):
                self.dynamicCollectionView.pushImmutableList(holderModels: holderModels)
            case .empty:
                return
            }
        })
            .disposed(
                by: disposeBag)
        
		viewModel?.navToPokeEvoDetailsCallback = { urlString in

			self.coordinator?
				.eventOccured(with: .singlePokemonClicked(
								nil,
								urlString
				))
		}
		
		
		
		 
	}
}
