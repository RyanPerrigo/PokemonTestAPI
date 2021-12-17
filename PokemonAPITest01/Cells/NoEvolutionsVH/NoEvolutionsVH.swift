//
//  NoEvolutionsVH.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 12/17/21.
//

import UIKit


class NoEvolutionsVH: UICollectionViewCell, BaseviewHolder {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    
    func bindData(data: BaseViewHolderModel) {
        
        image.layer.cornerRadius = 30
        image.clipsToBounds = true
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    
}


struct NoEvolutionsVHM: BaseViewHolderModel {
    
    
    func provideNibName() -> String {
        "NoEvolutionsVH"
    }
    
    func provideCellSize() -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.75)
    }
    
    func createCustomCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(withReuseIdentifier: provideNibName(), for: indexPath)
    }
    
    
}
