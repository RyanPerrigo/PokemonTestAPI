//
//  PokemonVC.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 8/7/21.
//

import RxSwift
import RxCocoa
import Reusable

class PokemonOverViewVC: UIViewController, ViewModelBased, StoryboardBased {
	
	
    @IBOutlet weak var topLevelStackView: UIStackView!
    @IBOutlet weak var dynamicCollectionView: DynamicCollectionView!
	
    var coordinator: MainCoordinator?
	var viewModel: PokemonOverViewVM?
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
		let searchBar = SearchBarView()
       
        searchBar.setViewActions(onTextEntered: { textString in
            self.viewModel?.searchTextSubject.onNext(textString)
        }, onSearchClicked: {
            print("Search clicked")
            self.viewModel?.onSearchClicked()
        },
        allPokemonArray: viewModel!.getAllPokemonArray()
        
        )
        self.topLevelStackView.insertArrangedSubview(searchBar, at: 0)
        
		viewModel?
			.screenStateObservable()
			.subscribe(onNext: { (screenState) in
				
				switch(screenState) {
				
				case .loading:
					
					let spinnerModel = LoadingVHM()
					
					self.dynamicCollectionView.pushImmutableList(holderModels: [spinnerModel])
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
                case .onSearchClicked(let pokemonTopLevelEntity):
                    self.dismiss(animated: false)
                    DispatchQueue.main.async {
                        self.coordinator?
                            .eventOccured(with: .singlePokemonClicked(
                                pokemonTopLevelEntity,
                                nil
                            ))
                    }
                    
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
