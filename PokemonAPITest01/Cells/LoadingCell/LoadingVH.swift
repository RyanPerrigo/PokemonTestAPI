//
//  LoadingVH.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 8/10/21.
//

import UIKit

class LoadingVH: UICollectionViewCell, BaseviewHolder {
	
	@IBOutlet weak var topLevelView: UIView!
	@IBOutlet weak var spinner: UIActivityIndicatorView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	func bindData(data: BaseViewHolderModel) {
		
		guard let viewModel = data as? LoadingVHM else {return}
		
		topLevelView.backgroundColor = .black
		
		
		
		spinner.color = .white
		spinner.startAnimating()
//		self.addSubview(spinner)
		
	}
}

struct LoadingVHM: BaseViewHolderModel {
	
	
	func provideNibName() -> String {
		"LoadingVH"
	}
	
	func provideCellSize() -> CGSize {
		return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
	}
	
	func createCustomCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
		collectionView.dequeueReusableCell(withReuseIdentifier: provideNibName(), for: indexPath)
	}
	
	
}
