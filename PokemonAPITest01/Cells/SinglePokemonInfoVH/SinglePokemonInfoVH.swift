//
//  SinglePokemonInfoVH.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 8/8/21.
//

import UIKit
import Kingfisher
import RxSwift

class SinglePokemonInfoVH: UICollectionViewCell, BaseviewHolder {

	private let disposeBag = DisposeBag()
	
	@IBOutlet weak var evolutionsButton: UIButton!
	@IBOutlet weak var topLevelView: UIView!
	@IBOutlet weak var pokemonImage: UIImageView!
	@IBOutlet weak var pokemonName: UILabel!
	@IBOutlet weak var pokemonIDNumber: UILabel!
	@IBOutlet weak var statsLabel: UILabel!
	@IBOutlet weak var hpValue: UILabel!
	@IBOutlet weak var attackValue: UILabel!
	@IBOutlet weak var defenceValue: UILabel!
	@IBOutlet weak var specAttackValue: UILabel!
	@IBOutlet weak var specDefenceValue: UILabel!
	@IBOutlet weak var speedValue: UILabel!
	@IBOutlet weak var hp: UILabel!
	@IBOutlet weak var attack: UILabel!
	@IBOutlet weak var defence: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	func bindData(data: BaseViewHolderModel) {
		
		guard let viewModel = data as? SinglePokemonInfoVHM else { return}
	
		self.layoutMargins.top = 5
		self.layoutMargins.bottom = 5
		topLevelView.backgroundColor = .darkGray
		topLevelView.layer.cornerRadius = 8
		
		let imageUrl = URL(string: viewModel.topLevelPokeEntity.sprites.front_default!)
		pokemonImage.kf.setImage(with: imageUrl)
		pokemonImage.clipsToBounds = true
		
		pokemonName.textColor = .red
		pokemonName.text = viewModel.topLevelPokeEntity.name!.capitalized
		
		pokemonIDNumber.text = String(viewModel.topLevelPokeEntity.id!)
		pokemonIDNumber.textColor = .red
		
		statsLabel.text = "Stats"
		statsLabel.textColor = .red
		statsLabel.font = UIFont.boldSystemFont(ofSize: 20)
		
		viewModel.topLevelPokeEntity.stats.forEach { statsObject in
			
			switch statsObject.stat.name {
			case "hp":
				hpValue.text = String(statsObject.base_stat)
			case "attack":
				attackValue.text = String(statsObject.base_stat)
			case "defense":
				defenceValue.text = String(statsObject.base_stat)
			case "special-attack":
				specAttackValue.text = String(statsObject.base_stat)
			case "special-defense":
				specDefenceValue.text = String(statsObject.base_stat)
			case "speed":
				speedValue.text = String(statsObject.base_stat)
			default: print("invalid Stat passed into View Holder")
			}
			
		}
		
		evolutionsButton.rx.tap.subscribe { _ in
			print("evolutionsButton tapped")
			viewModel.onEvolutionTapped()
		}
		.disposed(by: disposeBag)
	}
}

struct SinglePokemonInfoVHM: BaseViewHolderModel {
	
	let topLevelPokeEntity : PokemonTopLevelEntity
	let onEvolutionTapped: () -> Void
	
	func provideNibName() -> String {
		"SinglePokemonInfoVH"
	}
	
	func provideCellSize() -> CGSize {
		CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.7)
	}
	
	func createCustomCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
		collectionView.dequeueReusableCell(withReuseIdentifier: provideNibName(), for: indexPath)
	}
	
	
}
