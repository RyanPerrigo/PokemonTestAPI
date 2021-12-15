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
    private var viewModelStateSubject: BehaviorSubject<PokemonOverviewModelState>
    let lastCellCallbackSubject = PublishSubject<Void>()
	
	var navigateToSinglePokeDetailCallback: ((_ topLevelPokeEntity: PokemonTopLevelEntity?)->Void)?
	
	
	func screenStateObservable() -> Observable<PokemonVCState> {
        return Observable.merge(

            mapNextURLResultsToHolderModels(),
            mapBottomScrollEventToViewState()
        )
	}
	
	init(apiManager:APIManager){
		self.apiManager = apiManager
        
        self.viewModelStateSubject = BehaviorSubject<PokemonOverviewModelState>(value: PokemonOverviewModelState(
            holderModels: [],
            nextURL: Const.getPokemonEnpoint
        ))
        
       
	}
    
    func mapBottomScrollEventToViewState() -> Observable<PokemonVCState> {
        return lastCellCallbackSubject.flatMap { _ in
            return self.mapNextURLResultsToHolderModels()
        }
    }
	
	
	//the bad way -- takes logic and makes individual api calls within each individual VHM
//	func generateRxViewHolderModels()  {
//		apiManager
//			.decodeEndpointObservable(
//				endpointURL: Const.getPokemonEnpoint,
//				responseEntityType: GetPokemonEntity.self
//			)
//			.subscribe(onNext: { (getPokemonResponseEntity) in
//
//				let dynamicRxHolderModels = getPokemonResponseEntity.results.map { resultsObject in
//					DynamicSinglePokemonInfoVHM(pokemonDetailUrl: resultsObject.url)
//				}
//
//				self.screenState.onNext(.success(holderModels: dynamicRxHolderModels))
//			})
//			.disposed(by: disposeBag)
//	}
	
	
//	func populateFlatMapObservableChain() -> Observable<PokemonVCState> {
//
//		return apiManager
//			.decodeEndpointObservable(
//				endpointURL: Const.getPokemonEnpoint,
//				responseEntityType: GetPokemonEntity.self
//			)
//			.concatMap { (getPokemonResponseEntity) -> Observable<ResultsObject> in
//
//                self.updateViewModelStateSubject(nextURL: getPokemonResponseEntity.next)
//
//				return Observable.from(getPokemonResponseEntity.results) //breaks array into array of indy observables
//			}
//			.concatMap { (resultsObject: ResultsObject) -> Observable<PokemonTopLevelEntity> in
//				return self.apiManager.decodeEndpointObservable(endpointURL: resultsObject.url, responseEntityType: PokemonTopLevelEntity.self)
//			}
//			.concatMap { (pokemonTopLevelEntity) -> Observable<SinglePokeVHM> in
//
//
//				let singlePokeHolderModel = SinglePokeVHM(
//					topLevelPokemonEntity: pokemonTopLevelEntity
//				)
//				{ passedTopLevelPokeEntity in
//					self.navigateToSinglePokeDetailCallback?(passedTopLevelPokeEntity)
//				} onViewTappedWithUrlPayload: { optionalString in
//					print("string passed")
//
//				}
//
//				return Observable.just(singlePokeHolderModel)
//			}
//			.toArray()
//            .asObservable()
//            .flatMap { allHolders -> Observable<PokemonVCState> in
//                return Observable.just(.success(holderModels: allHolders))
//            }
//
//	}
	
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
	
    private func mapNextURLResultsToHolderModels() -> Observable<PokemonVCState>{
        let modelState = try! viewModelStateSubject.value()
        debugPrint("next url \(modelState.nextURL)")
        
       return apiManager.decodeEndpointObservable(
            endpointURL: modelState.nextURL,
            responseEntityType: GetPokemonRootEntity.self
        )
        .flatMap { (getPokemonEntity:GetPokemonRootEntity) -> Observable<[IndividualPokemonEntity]> in

            self.updateViewModelStateSubject(nextURL: getPokemonEntity.next)
            return Observable.from(getPokemonEntity.results)

        }
        .flatMap { entities -> Observable<[PokemonTopLevelEntity]> in
            
            
            let observableUrls = entities.map { indyEntity in
                
                return self.apiManager.decodeEndpointObservable(
                               endpointURL: indyEntity.url,
                               responseEntityType: PokemonTopLevelEntity.self
                           )
            }
            
            let zip = Observable.zip(observableUrls)
            return zip
            
        }
        .flatMap { topLevelEntities -> Observable<PokemonVCState> in
            
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
            
            return Observable.just(PokemonVCState.success(holderModels: newModels))
            
        }
        
        
          
    }
    func onScrollToBottomDetected() {
        debugPrint("Bottom Scroll!!!!")
        lastCellCallbackSubject.onNext(Void())
    }
}
