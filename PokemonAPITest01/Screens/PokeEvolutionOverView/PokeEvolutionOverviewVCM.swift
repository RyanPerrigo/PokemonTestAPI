//
//  PokeEvolutionOverviewVCM.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 8/9/21.
//

import Foundation
import RxSwift


class PokeEvolutionOverviewVCM: ViewModel {
	
	let speciesUrl: String
	var navToPokeEvoDetailsCallback: ((String)->Void)?
	private let disposeBag = DisposeBag()
	private let apiManager = APIManager.shared
	
	init(speciesUrl: String) {
		self.speciesUrl = speciesUrl
	}
	
	let screenState: BehaviorSubject<[BaseViewHolderModel]> = BehaviorSubject(value: [])
	
	
	func screenStateObservable () -> Observable<[BaseViewHolderModel]> {
		return screenState.asObservable()
	}
	
	func populateHolderModels() {
		self.apiManager.decodeEndpointObservable(
			endpointURL: self.speciesUrl,
			responseEntityType: SpeciesResponseEntity.self
		).flatMap {
			   SpeciesResponseEntity -> Observable<EvolutionChainTopLevelEntity> in
			   
			   self.apiManager.decodeEndpointObservable(endpointURL: SpeciesResponseEntity.evolution_chain.url, responseEntityType: EvolutionChainTopLevelEntity.self)
		   }
		   .flatMap { evolutionChainTopLevelEntity in
			   return	Observable.from(evolutionChainTopLevelEntity.chain.evolves_to)
		   }
		   .concatMap { (evolvesToObject) -> Observable<PokemonTopLevelEntity> in
			   
			   let evolvedPokeName = evolvesToObject.species.name
			   let pokemonDetailUrl = Const.getPokemonBaseUrl + evolvedPokeName
			   return self.apiManager.decodeEndpointObservable(endpointURL: pokemonDetailUrl, responseEntityType: PokemonTopLevelEntity.self)
		   }
		   .concatMap { (evolvedPokeTopLevelEntity) -> Observable<SinglePokeVHM> in
			   let holderModel = SinglePokeVHM(topLevelPokemonEntity: evolvedPokeTopLevelEntity) { _ in
				
				self.navToPokeEvoDetailsCallback?(Const.getPokemonBaseUrl + evolvedPokeTopLevelEntity.name!)
			} onViewTappedWithUrlPayload: { optionalString in
				// confused much ?!
			}
			return Observable.just(holderModel)
		   }
		   .toArray()
			.subscribe( onSuccess: { evolvedPokemonHolderModels in
			   self.screenState.onNext(evolvedPokemonHolderModels)
		   }
			)
		.disposed(by: disposeBag)
	}
	
	
	
}
