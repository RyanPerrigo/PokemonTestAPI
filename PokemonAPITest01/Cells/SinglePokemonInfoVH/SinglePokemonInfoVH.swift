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
    @IBOutlet weak var specialAttack: UILabel!
    @IBOutlet weak var specAttackValue: UILabel!
    @IBOutlet weak var specialDefence: UILabel!
    @IBOutlet weak var specDefenceValue: UILabel!
    @IBOutlet weak var speed: UILabel!
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
		
        let imageUrl = URL(string: viewModel.topLevelPokeEntity.sprites.other.home.frontDefault)
      
		pokemonImage.kf.setImage(with: imageUrl)
		pokemonImage.clipsToBounds = true
        pokemonImage.contentMode = .scaleAspectFill
        
        pokemonName.attributedText = NSAttributedString(
            string: viewModel.topLevelPokeEntity.name!.capitalized,
            attributes: [
                .font: UIFont.systemFont(ofSize: 25, weight: .bold),
                .foregroundColor : UIColor.red,
                
                
            ])
		
        
		pokemonIDNumber.text =  String(viewModel.topLevelPokeEntity.id!)
		pokemonIDNumber.textColor = .red
		
		statsLabel.text = "Basic Stats"
		statsLabel.textColor = .red
        statsLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
		
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
        bindLabelAttributes(lables: [
            hp,
            hpValue,
            attack,
            attackValue,
            defence,
            defenceValue,
            specialAttack,
            specAttackValue,
            specialDefence,
            specDefenceValue,
            speed,
            speedValue
        ])
        evolutionsButton.backgroundColor = .black
        evolutionsButton.shadowDecorate()
        evolutionsButton.setAttributedTitle(NSAttributedString(
            string: "Evolutions",
            attributes: [
                .font:UIFont.systemFont(ofSize: 12, weight: .semibold),
                .foregroundColor: UIColor.white
                        ]
        ),for: .normal)
        evolutionsButton.layer.cornerRadius = 8
        evolutionsButton.layer.borderWidth = 0.5
        evolutionsButton.layer.borderColor = UIColor.white.cgColor
        evolutionsButton.contentEdgeInsets.left = 10
        evolutionsButton.contentEdgeInsets.right = 10
		evolutionsButton.rx.tap.subscribe { _ in
			print("evolutionsButton tapped")
			viewModel.onEvolutionTapped()
		}
		.disposed(by: disposeBag)
	}
    func bindLabelAttributes(lables: [UILabel]) {
        lables.forEach { singleLabel in
            singleLabel.textColor = .white
            singleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        }
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

extension UIButton {
    
    func shadowDecorate() {
        let radius: CGFloat = 10
       layer.cornerRadius = radius
        
    
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.4, height: 0.3)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.6
        layer.masksToBounds = false
        layer.cornerRadius = radius
    }
}
