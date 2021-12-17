//
//  EvolvedPokeVCM.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 8/10/21.
//

import Foundation
import RxSwift


class EvolvedPokeVCM: ViewModel {
	
	
	var urlString: String
	
	init(urlString: String){
		self.urlString = urlString
	}
	private let disposeBag = DisposeBag()
	let screenstate: BehaviorSubject<[BaseViewHolderModel]> = BehaviorSubject(value: [])
	
	func screenStateObservable() -> Observable<[BaseViewHolderModel]> {
		return screenstate.asObservable()
	}
	
	
//	func populateScreenState() {
//		
//		var holderModels:[BaseViewHolderModel] = []
//		
//		APIManager.shared.decodeEndpointObservable(
//			endpointURL: urlString,
//			responseEntityType: PokemonTopLevelEntity.self
//		)
//			.flatMap { PokemonTopLevelEntity -> Observable<[BaseViewHolderModel]>in
//				
//				let viewHolder = SinglePokemonInfoVHM(topLevelPokeEntity: PokemonTopLevelEntity) {
//					print("view Tapped")
//				}
//				holderModels.append(viewHolder)
//				return Observable.just(holderModels)
//			}
//			.subscribe { holderModels in
//				self.screenstate.onNext(holderModels)
//			}
//			.disposed(by: disposeBag)
//
//	}
	
}
