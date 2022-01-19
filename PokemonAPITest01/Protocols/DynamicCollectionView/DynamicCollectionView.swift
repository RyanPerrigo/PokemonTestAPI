//
//  DynamicCollectionView.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 7/20/21.
//



import UIKit

class DynamicCollectionView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	
	let nibName: String = "DynamicCollectionView"
	var contentView: UIView?
	
	
	
	@IBOutlet weak var innerCollectionView: UICollectionView!
	
	private var holderData: [BaseViewHolderModel] = []
	
    private var lastCellHasAppearedListener : (()->Void)?
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	func commonInit() {
		guard let view = loadViewFromNib() else {return}
		view.frame = self.bounds
		self.addSubview(view)
		contentView = view
		innerCollectionView.delegate = self
		innerCollectionView.dataSource = self
	}
	
	func loadViewFromNib() -> UIView? {
		let bundle = Bundle(for: type(of: self))
		let nib = UINib(nibName: nibName, bundle: bundle)
		return nib.instantiate(withOwner: self, options: nil).first as? UIView
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return holderData[indexPath.item].provideCellSize()
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return holderData.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cellModel = holderData[indexPath.item]
		
		let dynamicCell = cellModel.createCustomCell(collectionView: collectionView, indexPath: indexPath) as! BaseviewHolder
		
		dynamicCell.bindData(data: cellModel)
		
		return dynamicCell
		
	}
	
	func pushImmutableList(holderModels: [BaseViewHolderModel]) {
		
		DispatchQueue.main.async {
			holderModels.forEach { cellModel in
				
				let nibCellForRegistration = UINib(nibName: cellModel.provideNibName(), bundle: nil)
				self.innerCollectionView.register(nibCellForRegistration, forCellWithReuseIdentifier: cellModel.provideNibName())
				
				
			}
			self.holderData = holderModels
			self.innerCollectionView.reloadData()
		}
	}
	
    func setLastCellDisplayedListener(listener: @escaping () -> Void) {
        self.lastCellHasAppearedListener = listener
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if holderData.count != 0 {
            
            if (indexPath.item == holderData.count - 1) {
                lastCellHasAppearedListener?()
            }
        }
//        paginationListener?(indexPath.item)
        
        
    }
    
    
}

