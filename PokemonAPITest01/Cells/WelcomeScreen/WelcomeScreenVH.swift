//
//  WelcomeScreenVH.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 7/21/21.
//

import UIKit
import Kingfisher

class WelcomeScreenVH: UICollectionViewCell, BaseviewHolder {

	
	@IBOutlet weak var topLevelView: UIView!
	@IBOutlet weak var welcomeLabel: UILabel!
	@IBOutlet weak var quizLabel: UILabel!
	
	@IBOutlet weak var pokeLogoImage: UIImageView!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	func bindData(data: BaseViewHolderModel) {
		
		
		pokeLogoImage.image = UIImage(named: "pokemonLogoImage")
		
		let labels: [UILabel] = [welcomeLabel,quizLabel]
		
		changeLabelColor(labels: labels)
		
		topLevelView.backgroundColor = UIColor.black
		topLevelView.layer.cornerRadius = 25
		
		self.layoutMargins.top = 100
		self.layoutMargins.bottom = 25
		self.layer.borderWidth = 1
		self.layer.borderColor = UIColor.white.cgColor
		self.layer.cornerRadius = 25
	}
	
	func changeLabelColor(labels:[UILabel]) {
		labels.forEach { label in
			label.textColor = .red
			label.font = UIFont.boldSystemFont(ofSize: 18)
		}
	}
}

struct WelcomeScreenVHM: BaseViewHolderModel {
	
	
	func provideNibName() -> String {
		"WelcomeScreenVH"
	}
	
	func provideCellSize() -> CGSize {
		return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.4)
	}
	
	func createCustomCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
		collectionView.dequeueReusableCell(withReuseIdentifier: provideNibName(), for: indexPath)
	}
	
	
}
