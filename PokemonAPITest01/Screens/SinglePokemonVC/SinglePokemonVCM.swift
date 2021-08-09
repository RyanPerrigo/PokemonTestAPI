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
class SinglePokemonVCM: ViewModel {
	
	let apiManager: APIManager
	let url: String
	
	init(apiManager:APIManager,urlResponse:String){
		self.apiManager = apiManager
		self.url = urlResponse
	}
	
	private let screenState: BehaviorSubject<SinglePokemonScreenState> = BehaviorSubject(value: .loading)
	
	
	func screenStateObservable() -> Observable<SinglePokemonScreenState> {
		return screenState.asObservable()
	}
	
	func populateViewModels() {
		
		
		var holderModels:[BaseViewHolderModel] = []
		
		apiManager.decodeEndpoint(endpointURL: url, responseEntityType: PokemonTopLevelEntity.self) { response in
			
		
			let holderModel = SinglePokemonInfoVHM(imageURLString: response.sprites.front_default!, pokemonName: response.name!, pokemonIdNumber: response.id!)
			holderModels.append(holderModel)
			self.screenState.onNext(.success(holderModels: holderModels))
		}
	}
}
