//
//  SinglePokemonVCM.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 8/7/21.
//

import Foundation
import RxSwift


class SinglePokemonDetailVM: ViewModel {
	
    enum ViewState {
        case loading
        case success(holderModels:[BaseViewHolderModel])
        case error(String)
    }
	let apiManager: APIManager
	let topLevelPokeEntity: PokemonTopLevelEntity?
	let pokeUrl: String?
	var navToEvolutionsClicked: ((String) -> Void)?
	private let disposeBag = DisposeBag()
	
	
	
	init(
		apiManager:APIManager,
		 topLevelPokeEntity:PokemonTopLevelEntity?,
		 pokeUrl:String?
	){
		self.apiManager = apiManager
		self.topLevelPokeEntity = topLevelPokeEntity
		self.pokeUrl = pokeUrl
	}
	
	private let screenState: BehaviorSubject<ViewState> = BehaviorSubject(value: .loading)
	
	
	func screenStateObservable() -> Observable<ViewState> {
		return screenState.asObservable()
	}
    func viewStateObservable() -> Observable<ViewState>{
        Observable.merge(
            screenStateObservable(),
            populateViewModels()
        )
    }
    
    
	func populateViewModels() -> Observable<ViewState> {

        if self.topLevelPokeEntity != nil {
            print("Binding Top Level Entity!")

            let holderModel = SinglePokemonInfoVHM(
                topLevelPokeEntity: topLevelPokeEntity!,
                onEvolutionTapped: {
                    print("onEvolutionTapped callback")
                    self.navToEvolutionsClicked?(self.topLevelPokeEntity!.species.url)
                })
            let spriteModels: [BaseViewHolderModel] = getSprites(spritesObject: self.topLevelPokeEntity!.sprites).map { spriteURL in
                return ImageVHM(imageURL: spriteURL)
            }
            let spritesView = HorizontalCVCVHM(holderModels: spriteModels)
            let returnModels: [BaseViewHolderModel] = [holderModel,spritesView]
            return Observable.just(ViewState.success(holderModels: returnModels))
        } else if pokeUrl != nil {
            
            return apiManager.decodeEndpointObservable(
                endpointURL: pokeUrl!,
                responseEntityType: PokemonTopLevelEntity.self, errorCallback: {
                    debugPrint("Some api Response Error being handled in singlePokemonDetailVM")
                }
            )
                .flatMap { pokemonTopLevelEntity -> Observable<[BaseViewHolderModel]> in

                    let holderModel = SinglePokemonInfoVHM(
                        topLevelPokeEntity: pokemonTopLevelEntity,
                        onEvolutionTapped: {
                            self.navToEvolutionsClicked?(pokemonTopLevelEntity.species.url)
                        }
                    )
                    let spriteModels: [BaseViewHolderModel] = self.getSprites(
                            spritesObject: pokemonTopLevelEntity.sprites).map { spriteURL in
                        return ImageVHM(imageURL: spriteURL)
                    }
                    let spritesView = HorizontalCVCVHM(holderModels: spriteModels)
                    let holderModels:[BaseViewHolderModel] = [holderModel,spritesView]
                    return Observable.from(optional: holderModels)

                }.flatMap({ holderModels -> Observable<ViewState> in
                    return Observable.just(ViewState.success(holderModels: holderModels))
                })

        } else {
            return Observable.just(ViewState.error("Failed to load holder models properly in single pokemon detail vm"))
        }
    }
		
        func getSprites(spritesObject: spritesObject) -> [String] {
            var sprites: [String?] = []
            sprites.append(spritesObject.other.home.frontDefault)
            sprites.append(spritesObject.other.dream_world?.front_default)
            sprites.append(spritesObject.other.dream_world?.front_female)
            sprites.append(spritesObject.other.officialArtwork?.front_default)
            sprites.append(spritesObject.front_female)
            sprites.append(spritesObject.back_female)
            sprites.append(spritesObject.front_default)
            sprites.append(spritesObject.back_default)
            sprites.append(spritesObject.front_shiny)
            sprites.append(spritesObject.back_shiny)
            sprites.append(spritesObject.front_shiny_female)
            sprites.append(spritesObject.back_shiny_female)
            
            
            let unwrappedStrings: [String] = sprites.map({ optionalString -> String in
                guard let safeString = optionalString else {return Const.defaultNoURL}
                
                return safeString
            })
           let returnSprites = unwrappedStrings.filter({$0 != Const.defaultNoURL})
            return returnSprites
            
        }
		
}
