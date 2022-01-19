//
//  ImageVH.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 1/17/22.
//

import UIKit
import Kingfisher

class ImageVH: UICollectionViewCell, BaseviewHolder {

    @IBOutlet weak var image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func bindData(data: BaseViewHolderModel) {
        let vModel = data as! ImageVHM
        let url = URL(string: vModel.imageURL)
        
        image.kf.setImage(with: url)
    }
    
}


struct ImageVHM: BaseViewHolderModel {
    let imageURL: String
    
    func provideNibName() -> String {
        "ImageVH"
    }
    
    func provideCellSize() -> CGSize {
        return CGSize(width: 130, height: 130)
    }
    
    func createCustomCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        
        collectionView.dequeueReusableCell(
            withReuseIdentifier: provideNibName(),
            for: indexPath
        )
    }
    
    
    
}
