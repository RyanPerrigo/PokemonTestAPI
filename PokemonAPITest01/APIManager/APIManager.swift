//
//  APIManager.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 8/7/21.
//

import Foundation
import RxSwift

class APIManager {
	
	static let shared = APIManager()
	
	func decodeEndpoint<T:Decodable>(
		endpointURL:String,
		responseEntityType: T.Type,
		onDecodedCallback: ((T) -> Void)?
	) {
		let session = URLSession.shared
		
		guard let url = URL(string: endpointURL) else {print("badURL"); return}
		
		let task = session.dataTask(with: url) { optionalData, optionalResponse, optionalError in
				
			guard let data = optionalData else {print("ERROR GETTING DATA") ; return}
			
			let decoder = JSONDecoder()
			
			guard let decodedData: T = try? decoder.decode(responseEntityType, from: data) else {fatalError("ERROR DECODING JSON")}
			onDecodedCallback?(decodedData)
	
		}
		
			task.resume()
		
	}
	
	func decodeEndpointObservable<T:Decodable>(
		endpointURL:String,
		responseEntityType: T.Type
	) -> Observable<T> {
		
		let session = URLSession.shared
		
		guard let url = URL(string: endpointURL) else {print("badURL"); return Observable.empty()}
		
		return Observable.create { observer in
			let task = session.dataTask(with: url) { optionalData, optionalResponse, optionalError in
					
				guard let data = optionalData else {print("ERROR GETTING DATA") ; return}
				
				let decoder = JSONDecoder()
				
				guard let decodedData: T = try? decoder.decode(responseEntityType, from: data) else {fatalError("ERROR DECODING JSON")}
				observer.on(.next(decodedData))
				observer.on(.completed)
			}
			
			task.resume()
			return Disposables.create()
		}
			
		
	}
	
	
}
