//
//  SingleLabelVH.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 8/7/21.
//

import UIKit

class SingleLabelVH: UICollectionViewCell, BaseviewHolder {

	@IBOutlet weak var topLevelView: UIView!
	@IBOutlet weak var label: UILabel!
	private var onViewTappedListener: (()->Void)?
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	func bindData(data: BaseViewHolderModel) {
		let viewModel = data as? SingleLabelVHM
		topLevelView.backgroundColor = .black
		label.textColor = .red
		label.text = viewModel?.labelText
		onViewTappedListener = {
			viewModel?.onViewTapped()
		}
		let tap = UITapGestureRecognizer(target: self, action: #selector(onViewTapped))
		self.addGestureRecognizer(tap)
	}
	@objc func onViewTapped(){
		onViewTappedListener?()
	}
}

struct SingleLabelVHM: BaseViewHolderModel {
	
	var labelText: String
	var onViewTapped:()->Void
	
	func provideNibName() -> String {
		"SingleLabelVH"
	}
	
	func provideCellSize() -> CGSize {
		return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.15)
	}
	
	func createCustomCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
		collectionView.dequeueReusableCell(withReuseIdentifier: provideNibName(), for: indexPath)
	}
	
	
}
