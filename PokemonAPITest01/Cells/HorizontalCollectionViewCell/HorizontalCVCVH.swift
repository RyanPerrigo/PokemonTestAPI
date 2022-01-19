//
//  HorizontalCVCVH.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 1/17/22.
//

import UIKit

class HorizontalCVCVH: UICollectionViewCell, BaseviewHolder {

    @IBOutlet weak var dynaCollectionView: DynamicCollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func bindData(data: BaseViewHolderModel) {
        let vModel = data as! HorizontalCVCVHM
        
        if let layout = dynaCollectionView.innerCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        dynaCollectionView.pushImmutableList(holderModels: vModel.holderModels)
    }
    
    
}

struct HorizontalCVCVHM: BaseViewHolderModel {
    
    let holderModels: [BaseViewHolderModel]
    
    func provideNibName() -> String {
        "HorizontalCVCVH"
    }
    
    func provideCellSize() -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 150)
    }
    
    func createCustomCell(
        collectionView: UICollectionView,
        indexPath: IndexPath) -> UICollectionViewCell {
        
        collectionView.dequeueReusableCell(withReuseIdentifier: provideNibName(), for: indexPath)
    }
    
    
}
