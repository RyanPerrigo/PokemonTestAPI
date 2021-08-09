//
//  WelcomeScreenVH.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 7/21/21.
//

import UIKit

class WelcomeScreenVH: UICollectionViewCell, BaseviewHolder {

	
	@IBOutlet weak var topLevelView: UIView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	func bindData(data: BaseViewHolderModel) {
		topLevelView.backgroundColor = UIColor.blue
		topLevelView.layer.cornerRadius = 25
	}
	
}

struct WelcomeScreenVHM: BaseViewHolderModel {
	
	
	func provideNibName() -> String {
		"WelcomeScreenVH"
	}
	
	func provideCellSize() -> CGSize {
		return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.2)
	}
	
	func createCustomCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
		collectionView.dequeueReusableCell(withReuseIdentifier: provideNibName(), for: indexPath)
	}
	
	
}
