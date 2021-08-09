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
	
	private var pokemonHolders: [BaseViewHolderModel] = []

	func screenStateObservable() -> Observable<PokemonVCState> {
		return screenState.asObservable()
	}
	
	init(apiManager:APIManager){
		self.apiManager = apiManager
	}
	
	
	func populateHolderModels() {
		
//				apiManager
//					.decodeEndpoint(
//						endpointURL: Const.getPokemonEnpoint,
//						responseEntityType: GetPokemonEntity.self,
//						onDecodedCallback: { listOfPokemon in
//
//					let displayPokemon = listOfPokemon.results.map { resultsObject in
//								SingleLabelVHM(labelText: resultsObject.name, onViewTapped: {
//									self.navigateToSinglePokemonCallback?(resultsObject.url)
//								})
//							}
//
//							self.screenState.onNext(.success(holderModels: displayPokemon))
//
////							self.holderModelState.onNext(displayPokemon)
//				})
		
//		apiManager
//			.decodeEndpointObservable(
//				endpointURL: Const.getPokemonEnpoint,
//				responseEntityType: GetPokemonEntity.self
//			)
//			.subscribe { listOfPokemon in
//				let displayPokemon = listOfPokemon.results.map { resultsObject in
//					SingleLabelVHM(labelText: resultsObject.name, onViewTapped: {
//						self.navigateToSinglePokemonCallback?(resultsObject.url)
//					})
//				}
//
//				self.screenState.onNext(.success(holderModels: displayPokemon))
//			} onError: { error in
//				print(error)
//			} onCompleted: {
//
//			} onDisposed: {
//
//			}
		
		print("OBSERVABLE CHAIN BEGIN")
		
		apiManager
			.decodeEndpointObservable(
				endpointURL: Const.getPokemonEnpoint,
				responseEntityType: GetPokemonEntity.self
			)
			.flatMap { (getPokemonResponseEntity) in
				
				
				return Observable.from(getPokemonResponseEntity.results) //breaks array into array of indy observables
			}
			.flatMap { (resultsObject: resultsObject) -> Observable<PokemonTopLevelEntity> in
				 return self.apiManager.decodeEndpointObservable(endpointURL: resultsObject.url, responseEntityType: PokemonTopLevelEntity.self)
			}
			.flatMap { (pokemonTopLevelEntity) -> Observable<SinglePokemonInfoVHM> in

				
				let singlePokeInfo = SinglePokemonInfoVHM(
					imageURLString: pokemonTopLevelEntity.sprites.front_default!,
					pokemonName: pokemonTopLevelEntity.name!,
					pokemonIdNumber: pokemonTopLevelEntity.id!
				)

				return Observable.just(singlePokeInfo)
			}
			.subscribe { (vModel: BaseViewHolderModel) in
				self.pokemonHolders.append(vModel)
				self.screenState.onNext(.success(holderModels: self.pokemonHolders))
			}
		
	}
	
//	func generateHolderModels() -> Observable<[SinglePokemonInfoVHM]> {
//		return apiManager
//			.decodeEndpointObservable(
//				endpointURL: Const.getPokemonEnpoint,
//				responseEntityType: GetPokemonEntity.self
//			)
//			.flatMap { (getPokemonResponseEntity) in
//				Observable.from(getPokemonResponseEntity.results)
//			}
//			.flatMap { (resultsObject) -> Observable<PokemonTopLevelEntity> in
//				 return self.apiManager.decodeEndpointObservable(endpointURL: resultsObject.url, responseEntityType: PokemonTopLevelEntity.self)
//			}
//			.flatMap { (pokemonTopLevelEntity: PokemonTopLevelEntity) -> Observable<SinglePokemonInfoVHM> in
//
//				let singlePokeInfo = SinglePokemonInfoVHM(
//					imageURLString: pokemonTopLevelEntity.sprites.front_default!,
//					pokemonName: pokemonTopLevelEntity.name!,
//					pokemonIdNumber: pokemonTopLevelEntity.id!
//				)
//
//				return Observable.from(singlePokeInfo)
//			}
//
//	}
	
	
}
