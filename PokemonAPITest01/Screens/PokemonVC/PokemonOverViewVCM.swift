//
//  PokemonVCM.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 8/7/21.
//

import Foundation
import RxSwift


class PokemonOverViewVCM: ViewModel {
	
	enum PokemonVCState{
		case loading
		case success(holderModels: [BaseViewHolderModel])
		case nextPageLoading
		case nextPageLoadSuccess(holderModels: [BaseViewHolderModel])
		case error
	}
	
	private let apiManager: APIManager
	private let disposeBag = DisposeBag()
	
	private let screenState: BehaviorSubject<PokemonVCState> = BehaviorSubject(value: .loading)
	var navigateToSinglePokeDetailCallback: ((_ topLevelPokeEntity: PokemonTopLevelEntity?)->Void)?
	
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
		
		
		
	}
	
	//the bad way -- takes logic and makes individual api calls within each individual VHM
	func generateRxViewHolderModels()  {
		apiManager
			.decodeEndpointObservable(
				endpointURL: Const.getPokemonEnpoint,
				responseEntityType: GetPokemonEntity.self
			)
			.subscribe(onNext: { (getPokemonResponseEntity) in
				
				let dynamicRxHolderModels = getPokemonResponseEntity.results.map { resultsObject in
					DynamicSinglePokemonInfoVHM(pokemonDetailUrl: resultsObject.url)
				}
				
				self.screenState.onNext(.success(holderModels: dynamicRxHolderModels))
			})
			.disposed(by: disposeBag)
	}
	
	
	func populateFlatMapObservableChain() {
		
		apiManager
			.decodeEndpointObservable(
				endpointURL: Const.getPokemonEnpoint,
				responseEntityType: GetPokemonEntity.self
			)
			.concatMap { (getPokemonResponseEntity) in
				
				
				return Observable.from(getPokemonResponseEntity.results) //breaks array into array of indy observables
			}
			.concatMap { (resultsObject: resultsObject) -> Observable<PokemonTopLevelEntity> in
				return self.apiManager.decodeEndpointObservable(endpointURL: resultsObject.url, responseEntityType: PokemonTopLevelEntity.self)
			}
			.concatMap { (pokemonTopLevelEntity) -> Observable<SinglePokeVHM> in
				
				
				let singlePokeHolderModel = SinglePokeVHM(
					topLevelPokemonEntity: pokemonTopLevelEntity
				)
				{ passedTopLevelPokeEntity in
					self.navigateToSinglePokeDetailCallback?(passedTopLevelPokeEntity)
				} onViewTappedWithUrlPayload: { optionalString in
					print("string passed")
					
				}
				
				return Observable.just(singlePokeHolderModel)
			}
			.toArray()
			.subscribe(onSuccess: { allHolders in
				self.screenState.onNext(.success(holderModels: allHolders))
			})
			.disposed(by: disposeBag)
		
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
