//
//  BaseViewHolder.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 7/20/21.
//

import UIKit


protocol BaseviewHolder: UICollectionViewCell  {
	func bindData(data: BaseViewHolderModel)
}

protocol BaseViewHolderModel {
	func provideNibName() -> String
	func provideCellSize() -> CGSize
	func createCustomCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
}
