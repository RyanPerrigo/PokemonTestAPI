//
//  PokemonVC.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 8/7/21.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable

class PokemonVC: UIViewController, ViewModelBased, StoryboardBased {
	
	@IBOutlet weak var dynamicCollectionView: DynamicCollectionView!
	
	var coordinator: MainCoordinator?
	var viewModel: PokemonVCM?
	let disposeBag = DisposeBag()
	
	
	override func viewDidLoad() {
		
		print("viewDidLoad()")
		
//		viewModel?.stateObservable()
//			.subscribe(onNext: { (holderModels) in
//
//					self.dynamicCollectionView.pushImmutableList(holderModels: holderModels)
//
//		})
//		.disposed(by: disposeBag)
		viewModel?.navigateToSinglePokemonCallback = { responseURL in
			
			self.coordinator?.eventOccured(with: .singlePokemonClicked(responseURL))
		}
		viewModel?.screenStateObservable()
			.subscribe(onNext: { (screenState) in
				
				switch(screenState) {
				
				case .loading:
					print("loading")
					//display loading text or something
				case let .success(holderModels):
					
					self.dynamicCollectionView.pushImmutableList(holderModels: holderModels)
					
				case .error:
					print("Error")
					//display error state
					
				case .nextPageLoading:
					
					print("somethingElse")
				case .nextPageLoadSuccess(holderModels: let holderModels):
					
					print("something\(holderModels)")
				}
				
			})
			.disposed(by: disposeBag)
		
		self.viewModel?.populateHolderModels()
		
	}
	
}
