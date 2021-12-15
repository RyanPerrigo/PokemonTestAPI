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

class PokemonOverViewVC: UIViewController, ViewModelBased, StoryboardBased {
	
	
	@IBOutlet weak var dynamicCollectionView: DynamicCollectionView!
	
	var coordinator: MainCoordinator?
	var viewModel: PokemonOverViewVCM?
	let disposeBag = DisposeBag()
	
	
	override func viewDidLoad() {
		
		print("viewDidLoad()")
		
		
		viewModel?.navigateToSinglePokeDetailCallback = { toplevelEntity in
			
			self.coordinator?
				.eventOccured(with: .singlePokemonClicked(
					toplevelEntity,
					nil
				))
		}
		
		viewModel?
			.screenStateObservable()
			.subscribe(onNext: { (screenState) in
				
				switch(screenState) {
				
				case .loading:
					var holderModels:[BaseViewHolderModel] = []
					let spinnerModel = LoadingVHM()
					holderModels.append(spinnerModel)
					self.dynamicCollectionView.pushImmutableList(holderModels: holderModels)
				case let .success(holderModels):
					
					self.dynamicCollectionView.pushImmutableList(holderModels: holderModels)
					
				case .error:
					print("Error")
				//display error state
				
				case .nextPageLoading:
					
					print("somethingElse")
				case .nextPageLoadSuccess(holderModels: let holderModels):
					
                    self.dynamicCollectionView.pushImmutableList(holderModels: holderModels)
					print("something\(holderModels)")
				}
				
			},
                       onError: {error in
                debugPrint(error)
            })
			.disposed(by: disposeBag)
		
        dynamicCollectionView.setLastCellDisplayedListener {
            debugPrint("Bottom Detected!!!")
            self.viewModel?.onScrollToBottomDetected()
        }
	}
	
}
