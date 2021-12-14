//
//  MainVCM.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 7/20/21.
//

import Foundation
import RxSwift


class MainVCM: ViewModel {
	
	let apiManager: APIManager
	
	var callbackClosure: ((String) -> Void)?
	private let disposeBag = DisposeBag()
	
	private let displayState: PublishSubject<[BaseViewHolderModel]> = PublishSubject<[BaseViewHolderModel]>()
	
	init(apiManager:APIManager){
		self.apiManager = apiManager
	}
	
	
	func callbackObservable() -> Observable<String> {
		
		return Observable.create { (someObserver) in
			
			self.callbackClosure = { callbackString in
				print("this is also happening")
				someObserver.onNext(callbackString)
				
			}
			
			return Disposables.create()
		}
	}
	
	func myCustomStringObservable(inputString: String) -> Observable<String> {
		Observable.create { someObserver in
			let inputString = "THE OBSERVABLE INPUT WAS \(inputString)"
			someObserver.onNext(inputString)
			return Disposables.create()
		}
	}
	
	func getStateObservable() -> Observable<[BaseViewHolderModel]> {
		return displayState.asObservable()
	}
	
	
	func pushInitialScreenState() {
		
		let holderModels:[BaseViewHolderModel] = [
			WelcomeScreenVHM()
		]
		
		displayState.onNext(holderModels)
	}
	
	func testButton() {
		let array = 0...100
		
		let observableArray = Observable.from(array)
		
		observableArray.flatMap { singleInt -> Observable<String> in
			let string = "Observable.just \(singleInt)"
			
			return  Observable.just(string)
		}
		.flatMap({ observableString in
			self.myCustomStringObservable(inputString: observableString)
		})
		.subscribe { singleObservableString in
			print("Hello \(singleObservableString)")
		}
		.disposed(by: disposeBag)
		
		
	}

}
