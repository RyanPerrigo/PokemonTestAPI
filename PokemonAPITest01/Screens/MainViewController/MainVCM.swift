//
//  MainVCM.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 7/20/21.
//

import Foundation
import RxSwift


class MainVCM: ViewModel {
	
	let apiManager: APIManager

	private let displayState: PublishSubject<[BaseViewHolderModel]> = PublishSubject<[BaseViewHolderModel]>()
	
	init(apiManager:APIManager){
		self.apiManager = apiManager
	}
	
	func getStateObservable() -> Observable<[BaseViewHolderModel]> {
		return displayState.asObservable()
	}
	
	
	func pushInitialScreenState() {
		
		let holderModels:[BaseViewHolderModel] = [
			WelcomeScreenVHM()
		]
		
		displayState.onNext(holderModels)
	}
	
//	func getListOfPokemon() {
//		
//		apiManager.decodeEndpoint(endpointURL: Const.getPokemonEnpoint, responseEntityType: GetPokemonEntity.self)
//	}
	
}
