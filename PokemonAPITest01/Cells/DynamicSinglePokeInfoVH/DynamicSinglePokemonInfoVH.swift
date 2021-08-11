//
//  SinglePokemonInfoVH.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 8/8/21.
//

import UIKit
import Kingfisher
import RxSwift

class DynamicSinglePokemonInfoVH: UICollectionViewCell, BaseviewHolder {

		
	@IBOutlet weak var topLevelView: UIView!
	@IBOutlet weak var pokemonImage: UIImageView!
	@IBOutlet weak var pokemonName: UILabel!
	@IBOutlet weak var pokemonIDNumber: UILabel!
	
	private let apiManager = APIManager.shared
	private let disposeBag = DisposeBag()
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	func bindData(data: BaseViewHolderModel) {
		
		guard let viewModel = data as? DynamicSinglePokemonInfoVHM else { return}
		
		topLevelView.backgroundColor = .black
		
		apiManager.decodeEndpointObservable(endpointURL: viewModel.pokemonDetailUrl, responseEntityType: PokemonTopLevelEntity.self)
			.subscribe(onNext: { [self] topLevelEntityResponse in
				
				DispatchQueue.main.async {
					let imageUrl = URL(string: topLevelEntityResponse.sprites.front_default!)
					pokemonImage.kf.setImage(with: imageUrl)
					pokemonImage.clipsToBounds = true
					
					pokemonName.textColor = .red
					pokemonName.text = topLevelEntityResponse.name!
					
					pokemonIDNumber.text = String(topLevelEntityResponse.id!)
					pokemonIDNumber.textColor = .red
				}
				
				
			})
			.disposed(by: disposeBag)
		
		
	}
}

struct DynamicSinglePokemonInfoVHM: BaseViewHolderModel {
	
	let pokemonDetailUrl: String
	
	func provideNibName() -> String {
		"DynamicSinglePokemonInfoVH"
	}
	
	func provideCellSize() -> CGSize {
		CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.45)
	}
	
	func createCustomCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
		collectionView.dequeueReusableCell(withReuseIdentifier: provideNibName(), for: indexPath)
	}
	
	
}
