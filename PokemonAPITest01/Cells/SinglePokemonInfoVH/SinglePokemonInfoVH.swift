//
//  SinglePokemonInfoVH.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 8/8/21.
//

import UIKit
import Kingfisher

class SinglePokemonInfoVH: UICollectionViewCell, BaseviewHolder {

	@IBOutlet weak var topLevelView: UIView!
	@IBOutlet weak var pokemonImage: UIImageView!
	@IBOutlet weak var pokemonName: UILabel!
	@IBOutlet weak var pokemonIDNumber: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	func bindData(data: BaseViewHolderModel) {
		
		guard let viewModel = data as? SinglePokemonInfoVHM else { return}
		
		topLevelView.backgroundColor = .black
		
		let imageUrl = URL(string: viewModel.imageURLString)
		pokemonImage.kf.setImage(with: imageUrl)
		pokemonImage.clipsToBounds = true
		
		pokemonName.textColor = .red
		pokemonName.text = viewModel.pokemonName
		
		pokemonIDNumber.text = String(viewModel.pokemonIdNumber)
		pokemonIDNumber.textColor = .red
	}
}

struct SinglePokemonInfoVHM: BaseViewHolderModel {
	let imageURLString: String
	let pokemonName: String
	let pokemonIdNumber: Int
	
	func provideNibName() -> String {
		"SinglePokemonInfoVH"
	}
	
	func provideCellSize() -> CGSize {
		CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.45)
	}
	
	func createCustomCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
		collectionView.dequeueReusableCell(withReuseIdentifier: provideNibName(), for: indexPath)
	}
	
	
}
