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


class SinglePokemonVC: UIViewController, ViewModelBased, StoryboardBased {
	
	
	var coordinator: PokemonCoordinator?
	
	var viewModel: SinglePokemonVCM?
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
		
		viewModel?.populateViewModels()
	}
	
	
	
}
