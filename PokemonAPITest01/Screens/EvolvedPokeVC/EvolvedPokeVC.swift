//
//  EvolvedPokeVC.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 8/10/21.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable


class EvolvedPokeVC: UIViewController,ViewModelBased,StoryboardBased,Coordinating {
	
	var viewModel: EvolvedPokeVCM?
	var coordinator: MainCoordinator?
	private let disposeBag = DisposeBag()
	
	@IBOutlet weak var dynamicCollectionView: DynamicCollectionView!
	
	
	
	
	override func viewDidLoad() {
		
		viewModel?.screenStateObservable().subscribe(onNext: { holderModels in
			self.dynamicCollectionView.pushImmutableList(holderModels: holderModels)
		})
		.disposed(by: disposeBag)
		
		
		
//		viewModel?.populateScreenState()
	}
	
}
