//
//  PokemonVCM.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 8/7/21.
//

import Foundation
import RxSwift


class PokemonVCM: ViewModel {
	
	enum PokemonVCState{
		case loading
		case success(holderModels: [BaseViewHolderModel])
		case nextPageLoading
		case nextPageLoadSuccess(holderModels: [BaseViewHolderModel])
		case error
	}
	
	private let apiManager: APIManager
	
	private let screenState: BehaviorSubject<PokemonVCState> = BehaviorSubject(value: .loading)
	var navigateToSinglePokemonCallback: ((_ responseUrl: String)->Void)?

	func screenStateObservable() -> Observable<PokemonVCState> {
		return screenState.asObservable()
	}
	
	init(apiManager:APIManager){
		self.apiManager = apiManager
	}
	
	
	func populateHolderModels() {
		
				apiManager
					.decodeEndpoint(
						endpointURL: Const.getPokemonEnpoint,
						responseEntityType: GetPokemonEntity.self,
						onDecodedCallback: { listOfPokemon in
		
					let displayPokemon = listOfPokemon.results.map { resultsObject in
								SingleLabelVHM(labelText: resultsObject.name, onViewTapped: {
									self.navigateToSinglePokemonCallback?(resultsObject.url)
								})
							}
							
							self.screenState.onNext(.success(holderModels: displayPokemon))
		
//							self.holderModelState.onNext(displayPokemon)
				})
		
//		apiManager
//			.decodeEndpointObservable(
//				endpointURL: Const.getPokemonEnpoint,
//				responseEntityType: GetPokemonEntity.self
//			)
//			.subscribe { listOfPokemon in
//				let displayPokemon = listOfPokemon.results.map { resultsObject in
//					SingleLabelVHM(labelText: resultsObject.name, onViewTapped: {
//						print("----VIEW TAPPED---")
//					})
//				}
//
//
//				self.holderModelState.onNext(displayPokemon)
//			} onError: { error in
//				print(error)
//			} onCompleted: {
//
//			} onDisposed: {
//
//			}
		

		
		
	}
}
