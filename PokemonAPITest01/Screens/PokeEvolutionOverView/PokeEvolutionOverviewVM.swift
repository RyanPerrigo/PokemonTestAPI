//
//  PokeEvolutionOverviewVCM.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 8/9/21.
//

import Foundation
import RxSwift


class PokeEvolutionOverviewVM: ViewModel {
    
    enum ViewState {
        case success([BaseViewHolderModel])
        case loading
        case start
        case empty
    }
    
    let speciesUrl: String
    var navToPokeEvoDetailsCallback: ((String)->Void)?
    private let viewStateSubject: BehaviorSubject<ViewState>
    private let disposeBag = DisposeBag()
    private let apiManager = APIManager.shared
    
    init(speciesUrl: String) {
        self.speciesUrl = speciesUrl
        self.viewStateSubject = BehaviorSubject<ViewState>(value: .start)
    }
    
    
    func viewStateObservable() -> Observable<ViewState> {
        return Observable.merge(
            getViewStateFromAPICalls(),
            viewStateSubjectObservable()
        )
    }
    var allEvolutionsArray: [String] = []
    
    func viewStateSubjectObservable() -> Observable<ViewState> {
        return viewStateSubject.asObservable()
    }
    func recursiveSearch(evolvesToObject: EvolvesToObject) -> [String] {
        
        allEvolutionsArray.append(evolvesToObject.species.name)
        
        if !evolvesToObject.evolves_to.isEmpty {
            
            evolvesToObject.evolves_to.forEach { object in
                
                recursiveSearch(evolvesToObject: object)
                
            }
        }
        
        return allEvolutionsArray
    }
    /// Makes nested api calls to return an observable View State with associated Base View Holder Models
    func getViewStateFromAPICalls() -> Observable<ViewState> {
        var filteredHolderModels: [SinglePokeVHM] = []
        // api returns nested data, in a recursive structure
        return self.apiManager.decodeEndpointObservable(
            endpointURL: self.speciesUrl,
            responseEntityType: SpeciesResponseEntity.self,
            errorCallback: {
                debugPrint("ERROR GETTING SPECIES RESPONSE ENTITY IN POKE EVOLUTION VM")
            }
        )
            .flatMap {
                SpeciesResponseEntity -> Observable<EvolutionChainTopLevelEntity> in
                
                self.apiManager.decodeEndpointObservable(endpointURL: SpeciesResponseEntity.evolution_chain.url, responseEntityType: EvolutionChainTopLevelEntity.self, errorCallback: {
                    debugPrint("ERROR GETTING EVOLUTION CHAIN TOP LEVEL ENTITY IN POKE EVOLUTION OVERVIEW VM")
                })
            }
            .flatMap { (evolutionChainTopLevelEntity: EvolutionChainTopLevelEntity) -> Observable<[String]> in
                self.allEvolutionsArray.append(evolutionChainTopLevelEntity.chain.species.name)
                let arrayOfPokemonArrays = evolutionChainTopLevelEntity.chain.evolves_to.map { evolvesToObject -> [String]in
                    return self.recursiveSearch(evolvesToObject: evolvesToObject)
                }
                let singlePokemonArray = arrayOfPokemonArrays.reduce([],+)
                return Observable.just(singlePokemonArray)
            }.flatMap { (arrayOfStrings: [String]) -> Observable<[PokemonTopLevelEntity]> in
                
                let dedupedStrings: Set<String> = Set(arrayOfStrings)
                let dedupedArray = Array(dedupedStrings)
                
                if dedupedArray.isEmpty {
                    self.viewStateSubject.onNext(.empty)
                    print("NO STRINGS TO PASS INTO API CALL?!?!")
                    return Observable.empty()
                }
                let apiCalls = dedupedArray.map { singleString in
                    self.apiManager.decodeEndpointObservable(endpointURL: Const.getPokemonBaseUrl + singleString, responseEntityType: PokemonTopLevelEntity.self,
                                                             errorCallback: {
                        debugPrint("ERROR GETTING POKEMON TOP LEVEL ENTITY IN POKEMON EVOLTUTION OVERVIEW VM")
                    })
                }
                return Observable.zip(apiCalls)
            }
            .flatMap { arrayOfPokemonTopLevelEntity -> Observable<ViewState> in
                
                
                
                let holderModels = arrayOfPokemonTopLevelEntity.map { singleTopLevelEntity -> SinglePokeVHM in
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
                
                
                if holderModels.isEmpty {
                    return Observable.just(ViewState.empty)
                }
                else {
                    return Observable.just(ViewState.success(holderModels))
                }
                
            }
        
    }
    
    
}
