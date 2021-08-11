//
//  SingleLabelVH.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 8/7/21.
//

import UIKit
import Kingfisher

class SinglePokeVH: UICollectionViewCell, BaseviewHolder {
	

	@IBOutlet weak var pokeImage: UIImageView!
	@IBOutlet weak var topLevelView: UIView!
	@IBOutlet weak var label: UILabel!
	private var onViewTappedListener: (()->Void)?
	private var onViewTappedWithURL: (()->Void)?
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	func bindData(data: BaseViewHolderModel) {
		
		
		guard let viewModel = data as? SinglePokeVHM else {return}
		
		self.layoutMargins.bottom = 10
		self.layoutMargins.top = 10
		self.layer.borderWidth = 1
		self.layer.borderColor = UIColor.white.cgColor
		self.layer.cornerRadius = 8
		topLevelView.layoutMargins.top = 10
		topLevelView.layoutMargins.bottom = 10
		topLevelView.backgroundColor = .black
		topLevelView.layer.cornerRadius = 8
		
		let imageUrl = URL(string: viewModel.topLevelPokemonEntity.sprites.front_default!)
			pokeImage.kf.setImage(with: imageUrl )
		pokeImage.clipsToBounds = true
		
		label.textColor = .red
		label.text = viewModel.topLevelPokemonEntity.name!.capitalized
		
		onViewTappedListener = {
			viewModel.onViewTappedWithPokemonEntity(viewModel.topLevelPokemonEntity)
		}
		onViewTappedWithURL = {
			viewModel.onViewTappedWithUrlPayload(viewModel.urlPlayload)
		}
		let tap = UITapGestureRecognizer(target: self, action: #selector(onViewTapped))
		self.addGestureRecognizer(tap)
		
		
	}
	
	
	@objc func onViewTapped(){
		onViewTappedListener?()
	}
}

struct SinglePokeVHM: BaseViewHolderModel {
	
	var topLevelPokemonEntity: PokemonTopLevelEntity
	var urlPlayload: String?
	var onViewTappedWithPokemonEntity: (PokemonTopLevelEntity) -> Void
	var onViewTappedWithUrlPayload: (String?) -> Void
	
	func provideNibName() -> String {
		"SinglePokeVH"
	}
	
	func provideCellSize() -> CGSize {
		return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.15)
	}
	
	func createCustomCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
		collectionView.dequeueReusableCell(withReuseIdentifier: provideNibName(), for: indexPath)
	}
	
	
}
