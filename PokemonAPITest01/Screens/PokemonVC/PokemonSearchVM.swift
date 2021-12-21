//
//  PokemonVCM.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 8/7/21.
//

import Foundation
import RxSwift


struct PokemonOverviewModelState {
    let holderModels: [BaseViewHolderModel]
    let nextURL: String
}

class PokemonSearchVM: ViewModel {
	
	enum ViewState{
		case loading
        case onSearchClicked(PokemonTopLevelEntity)
		case success(holderModels: [BaseViewHolderModel])
		case nextPageLoading
		case nextPageLoadSuccess(holderModels: [BaseViewHolderModel])
		case error
	}
	
	private let apiManager: APIManager
	private let disposeBag = DisposeBag()
    private var viewModelStateSubject: BehaviorSubject<PokemonOverviewModelState>
   private let lastCellCallbackSubject = PublishSubject<Void>()
   private let onSearchClickedEventSubject = PublishSubject<String>()
   private let allPokemonSearchSubject: BehaviorSubject<[IndividualPokemonEntity]> = BehaviorSubject<[IndividualPokemonEntity]>(value: [])
    private let searchTableViewDataSubject: BehaviorSubject<[String]> = BehaviorSubject<[String]>(value: [])
    
    
	
	var navigateToSinglePokeDetailCallback: ((_ topLevelPokeEntity: PokemonTopLevelEntity?)->Void)?
	
	
	func screenStateObservable() -> Observable<ViewState> {
        return Observable.merge(

            mapNextURLResultsToHolderModels(),
            mapBottomScrollEventToViewState(),
            mapSearchClickedEventToViewState()
            
            
        )
	}
	
	init(apiManager:APIManager){
		self.apiManager = apiManager
        
        if let path = Bundle.main.path(forResource: "all-pokemon", ofType: "json") {
            do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                
                let decoder = JSONDecoder()
                if let jsonData = try? decoder.decode(GetPokemonRootEntity.self, from: data) {
                    debugPrint(jsonData)
                    allPokemonSearchSubject.onNext(jsonData.results)
                } else {
                    debugPrint("ERROR decoding data from json file ")
                }
              } catch {
                   
              }
        }
        self.viewModelStateSubject = BehaviorSubject<PokemonOverviewModelState>(value: PokemonOverviewModelState(
            holderModels: [],
            nextURL: Const.getPokemonEnpoint
        ))
        
       
	}
    func searchTableDataSourceObservable() -> Observable<[String]> {
        return searchTableViewDataSubject.asObservable()
    }
    func getPokemonAutoCompleteResults() -> [String] {
        return try! searchTableViewDataSubject.value()
    }
    func setPokemonSearchResults(results: [String]?) {
        if let safeResults = results {
            searchTableViewDataSubject.onNext(safeResults)
        }
    }
    func getAllPokemonArray() -> [String] {
        let allPokemon = try! allPokemonSearchSubject.value()
        let pokemonNames = allPokemon.map { individualPokemonEntity in
            individualPokemonEntity.name
        }
        return pokemonNames
    }
    
    func mapBottomScrollEventToViewState() -> Observable<ViewState> {
        return lastCellCallbackSubject.flatMap { _ in
            return self.mapNextURLResultsToHolderModels()
        }
    }
	
	
    private func updateViewModelStateSubject(
        holderModels: [BaseViewHolderModel]? = nil,
        nextURL: String? = nil
    )  {
        
            let oldState = try! viewModelStateSubject.value()
            
            let newState = PokemonOverviewModelState(
                holderModels: holderModels ?? oldState.holderModels,
                nextURL: nextURL ?? oldState.nextURL
            )
            
            viewModelStateSubject.onNext(newState)
    }
	
    private func mapNextURLResultsToHolderModels() -> Observable<ViewState>{
        let modelState = try! viewModelStateSubject.value()
        debugPrint("next url \(modelState.nextURL)")
        
       return apiManager.decodeEndpointObservable(
            endpointURL: modelState.nextURL,
            responseEntityType: GetPokemonRootEntity.self,
            errorCallback: {
                debugPrint("ERROR GETTING POKEMON ROOT ENTITY IN POKEMON OVERVIEW VM")
            }
        )
        .flatMap { (getPokemonEntity:GetPokemonRootEntity) -> Observable<[IndividualPokemonEntity]> in

            self.updateViewModelStateSubject(nextURL: getPokemonEntity.next)
            return Observable.from(getPokemonEntity.results)

        }
        .flatMap { entities -> Observable<[PokemonTopLevelEntity]> in
            
            
            let observableUrls = entities.map { indyEntity in
                
                return self.apiManager.decodeEndpointObservable(
                               endpointURL: indyEntity.url,
                               responseEntityType: PokemonTopLevelEntity.self, errorCallback: {
                                   debugPrint("ERROR GETTING TOP LEVEL POKEMON ENTITY IN POKEMON OVERVIEW VM")
                               }
                           )
            }
            
            let zip = Observable.zip(observableUrls)
            return zip
            
        }
        .flatMap { topLevelEntities -> Observable<ViewState> in
            
            let holderModels = topLevelEntities
                .map { topLevelEntity in
                return SinglePokeVHM(
                               topLevelPokemonEntity: topLevelEntity,
                               urlPlayload: nil,
                               onViewTappedWithPokemonEntity: { passedTopLevelEntity in
                                   self.navigateToSinglePokeDetailCallback?(passedTopLevelEntity)
                               },
                               onViewTappedWithUrlPayload: {
                                   optionalURL in
               
                               }
                )
               
            }
            
            let newModels = modelState.holderModels + holderModels
            self.updateViewModelStateSubject(holderModels: newModels)
            
            return Observable.just(ViewState.success(holderModels: newModels))
            
        }
        
        
          
    }
    
    func mapSearchClickedEventToViewState() -> Observable<ViewState> {
        return onSearchClickedEventSubject.flatMap { searchText -> Observable<ViewState> in
            return self.mapSearchClickedToViewState(searchString: searchText)
        }
    }
    private func mapSearchClickedToViewState(searchString: String) -> Observable<ViewState>{
       
//       guard let searchString = try? searchTextSubject.value() else {return Observable.empty()}
        if !searchString.isEmpty {
            
                return  self.apiManager.decodeEndpointObservable(endpointURL: Const.getPokemonBaseUrl + searchString, responseEntityType: PokemonTopLevelEntity.self, errorCallback: {
                    debugPrint("Pokemon name -- \(searchString)")
                    debugPrint("NO POKEMON FOUND")
                }).flatMap { pokemonTopLevelEntity in
                return Observable.just(ViewState.onSearchClicked(pokemonTopLevelEntity))
            }
        }
        else {
            return Observable.empty()
        }
    }
    func onSearchClicked(searchText: String) {
        onSearchClickedEventSubject.onNext(searchText)
    }
    func onScrollToBottomDetected() {
        debugPrint("Bottom Scroll!!!!")
        lastCellCallbackSubject.onNext(Void())
    }
}
