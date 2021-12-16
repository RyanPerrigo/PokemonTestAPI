//
//  PokeEvolutionOverviewVCM.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 8/9/21.
//

import Foundation
import RxSwift


class PokeEvolutionOverviewVCM: ViewModel {
	
    enum ViewState {
    case success([BaseViewHolderModel])
    case loading
    case start
    }
    
	let speciesUrl: String
	var navToPokeEvoDetailsCallback: ((String)->Void)?
	private let disposeBag = DisposeBag()
	private let apiManager = APIManager.shared
	
	init(speciesUrl: String) {
		self.speciesUrl = speciesUrl
	}
	
	
    func viewStateObservable() -> Observable<ViewState> {
        return Observable.merge(
            getViewStateFromAPICalls()
        )
    }
    var allEvolutionsArray: [String] = []
    
//	func recursiveSearch(evolvesToObject: evolvesToObject) -> [String] {
//
//        if evolvesToObject.evolves_to.isEmpty {
//            allEvolutionsArray.append(evolvesToObject.species.name)
//        }
//        else {
//            allEvolutionsArray.append(evolvesToObject.species.name)
//            evolvesToObject.evolves_to.forEach { object in
//                recursiveSearch(evolvesToObject: object)
//            }
//        }
//
//		return allEvolutionsArray
//	}
    func recursiveSearch(evolvesToObject: EvolvesToObject) -> [String] {
        
        if evolvesToObject.evolves_to.isEmpty {
            allEvolutionsArray.append(evolvesToObject.species.name)
        }
        else {
            allEvolutionsArray.append(evolvesToObject.species.name)
            evolvesToObject.evolves_to.forEach { object in
                recursiveSearch(evolvesToObject: object)
            }
        }
            
        return allEvolutionsArray
    }
	
	func getViewStateFromAPICalls() -> Observable<ViewState> {
        
		return self.apiManager.decodeEndpointObservable(
			endpointURL: self.speciesUrl,
			responseEntityType: SpeciesResponseEntity.self
		)
            .flatMap {
			   SpeciesResponseEntity -> Observable<EvolutionChainTopLevelEntity> in
			   
			   self.apiManager.decodeEndpointObservable(endpointURL: SpeciesResponseEntity.evolution_chain.url, responseEntityType: EvolutionChainTopLevelEntity.self)
		   }
            .flatMap { (evolutionChainTopLevelEntity: EvolutionChainTopLevelEntity) -> Observable<[EvolvesToObject]> in
               return	Observable.just(evolutionChainTopLevelEntity.chain.evolves_to)
           }
           .flatMap { (arrayOfChainObjects: [EvolvesToObject]) -> Observable<[String]>in
               let arrayOfPokemonArrays: [[String]] = arrayOfChainObjects.map { singleEvolvesToObject -> [String] in
                   let PokemonArray:[String] = self.recursiveSearch(evolvesToObject: singleEvolvesToObject)
                   return PokemonArray
               }
               let singlePokemonArray = arrayOfPokemonArrays.reduce([],+)
               return Observable.just(singlePokemonArray)
           }.flatMap { (arrayOfStrings: [String]) -> Observable<[PokemonTopLevelEntity]> in
               
               let apiCalls = arrayOfStrings.map { singleString in
                   self.apiManager.decodeEndpointObservable(endpointURL: Const.getPokemonBaseUrl + singleString, responseEntityType: PokemonTopLevelEntity.self)
               }
               return Observable.zip(apiCalls)
           }
           .flatMap { arrayOfPokemonTopLevelEntity -> Observable<ViewState> in
               
              let holderModels = arrayOfPokemonTopLevelEntity.map { singleTopLevelEntity -> BaseViewHolderModel in
                   let holderModel = SinglePokeVHM(
                    topLevelPokemonEntity: singleTopLevelEntity,
                    urlPlayload: nil,
                    onViewTappedWithPokemonEntity: { passedPokemonTopLevelEntity in
                
                        self.navToPokeEvoDetailsCallback?(Const.getPokemonBaseUrl + singleTopLevelEntity.name!)
                    },
                    onViewTappedWithUrlPayload: {
                        _ in
                    })
                   return holderModel
               }
               return Observable.just(ViewState.success(holderModels))
           }
        
        }
//    func mapArrayOfPokemonToViewState() -> Observable<ViewState> {
//
//        getViewStateFromAPICalls()
//
//    }
        
        
        
//		   .concatMap { (evolvesToObject) -> Observable<[PokemonTopLevelEntity]> in
//
//              let doubleArrayOfStrings = evolvesToObject.evolves_to.map { singleObject in
//                   self.recursiveSearch(evolvesToObject: singleObject)
//               }
//              let allEvolutions = doubleArrayOfStrings.reduce([],+)
//               print("ALL EVOLUTIONS ----- \(allEvolutions)")
//               let apiCalls: [Observable<PokemonTopLevelEntity>] = allEvolutions.map { pokemon in
//                   let pokemonDetailUrl = Const.getPokemonBaseUrl + pokemon
//                   print(pokemon)
//                   return self.apiManager.decodeEndpointObservable(endpointURL: pokemonDetailUrl, responseEntityType: PokemonTopLevelEntity.self)
//               }
//              return Observable.zip(apiCalls)
//           }
//           .flatMap {
//               (pokeArray:[PokemonTopLevelEntity]) -> Observable<ViewState> in
//               let holderModels:[BaseViewHolderModel] = pokeArray.map { topLevelPokeEntity in
//
//                   let singlePokemonHolder = SinglePokeVHM(
//                    topLevelPokemonEntity: topLevelPokeEntity,
//                    urlPlayload: topLevelPokeEntity.species.url) { pokemonTopLevelEntity in
//
//                    } onViewTappedWithUrlPayload: { _ in
//
//                    }
//
//                   return singlePokemonHolder
//               }
//               return Observable.just(ViewState.success(holderModels))
//           }
           
	
//    SinglePokemonInfoVHM(
//     topLevelPokeEntity: topLevelPokeEntity,
//     onEvolutionTapped: {
//
//     })
	
}
