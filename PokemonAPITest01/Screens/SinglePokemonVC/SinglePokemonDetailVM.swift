//
//  SinglePokemonVCM.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 8/7/21.
//

import Foundation
import RxSwift

enum SinglePokemonScreenState {
	case loading
	case success(holderModels:[BaseViewHolderModel])
	case error
}
class SinglePokemonDetailVM: ViewModel {
	
	let apiManager: APIManager
	let topLevelPokeEntity: PokemonTopLevelEntity?
	let pokeUrl: String?
	var navToEvolutionsClicked: ((String) -> Void)?
	private let disposeBag = DisposeBag()
	
	
	
	init(
		apiManager:APIManager,
		 topLevelPokeEntity:PokemonTopLevelEntity?,
		 pokeUrl:String?
	){
		self.apiManager = apiManager
		self.topLevelPokeEntity = topLevelPokeEntity
		self.pokeUrl = pokeUrl
	}
	
	private let screenState: BehaviorSubject<SinglePokemonScreenState> = BehaviorSubject(value: .loading)
	
	
	func screenStateObservable() -> Observable<SinglePokemonScreenState> {
		return screenState.asObservable()
	}
	
	func populateViewModels() {
		
		var holderModels: [BaseViewHolderModel] = []
		
		if let safeTopLevelEntity = topLevelPokeEntity {
			
			print("Binding Top Level Entity!")
			
			let holderModel = SinglePokemonInfoVHM(
				topLevelPokeEntity: safeTopLevelEntity,
				onEvolutionTapped: {
					print("onEvolutionTapped callback")
					self.navToEvolutionsClicked?(safeTopLevelEntity.species.url)
				})
			holderModels.append(holderModel)
			self.screenState.onNext(.success(holderModels: holderModels))
		}
		else if let safeUrl = pokeUrl {
			
			print("Need to fetch top level entity from url")
			
			apiManager.decodeEndpointObservable(
				endpointURL: safeUrl,
                responseEntityType: PokemonTopLevelEntity.self, errorCallback: {
                    debugPrint("Some api Response Error being handled in singlePokemonDetailVM")
                }
			)
				.flatMap { pokemonTopLevelEntity -> Observable<SinglePokemonInfoVHM> in
					
					let holderModel = SinglePokemonInfoVHM(
						topLevelPokeEntity: pokemonTopLevelEntity,
						onEvolutionTapped: {
							self.navToEvolutionsClicked?(pokemonTopLevelEntity.species.url)
						}
					)
					
					return Observable.just(holderModel)
					
				}.subscribe (onNext:{ holdermodel in
					var holderModelsToPush: [BaseViewHolderModel] = []
					holderModelsToPush.append(holdermodel)
					self.screenState.onNext(.success(holderModels: holderModelsToPush))
				})
				.disposed(by: disposeBag)
			
		}
		
		
		
		
	}
}
