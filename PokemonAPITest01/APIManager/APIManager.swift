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
	
	
	func decodeEndpointObservable<T:Decodable>(
		endpointURL:String,
		responseEntityType: T.Type,
        errorCallback:@escaping()->Void
	) -> Observable<T> {
		
		let session = URLSession.shared
        debugPrint(endpointURL)
        guard let url = URL(string: endpointURL) else {print("Bad URL");errorCallback(); return Observable.empty()}
		
		return Observable.create { observer in
			let task = session.dataTask(with: url) { optionalData, optionalResponse, optionalError in
					
                guard let data = optionalData else {errorCallback();print("ERROR GETTING DATA") ; return}
				
				let decoder = JSONDecoder()
				
                guard let decodedData: T = try? decoder.decode(responseEntityType, from: data) else {debugPrint("ERROR DECODING JSON");errorCallback();return}
				observer.on(.next(decodedData))
				observer.on(.completed)
			}
			
			task.resume()
			return Disposables.create()
		}
			
		
	}
	
	
}
