//
//  ViewController.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 7/20/21.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa

class MainVC: UIViewController, ViewModelBased, StoryboardBased {
	
	@IBOutlet weak var searchButton: UIButton!
	
	var coordinator: MainCoordinator?
	var viewModel: MainVCM?
	let disposeBag = DisposeBag()

	@IBOutlet weak var dynamicCollectionView: DynamicCollectionView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		searchButton.setTitle("Search For Pokemon", for: .normal)
		
		searchButton.rx.tap.subscribe { _ in
			self.coordinator?.eventOccured(with: .startGame)
		}
		viewModel?.getStateObservable().subscribe(onNext: { (holderModels) in
			self.dynamicCollectionView.pushImmutableList(holderModels: holderModels)
		})
		.disposed(by: disposeBag)
		// Do any additional setup after loading the view.
		viewModel?.pushInitialScreenState()
		
	}
	
	
}

