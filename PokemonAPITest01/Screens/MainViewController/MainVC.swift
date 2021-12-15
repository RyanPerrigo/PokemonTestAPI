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
	@IBOutlet weak var testButton: UIButton!
	
	var coordinator: MainCoordinator?
	var viewModel: MainVCM?
	let disposeBag = DisposeBag()

	@IBOutlet weak var dynamicCollectionView: DynamicCollectionView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		dynamicCollectionView.backgroundColor = .clear
		searchButton.layer.borderWidth = 1
		searchButton.layer.borderColor = UIColor.white.cgColor
		searchButton.setTitleColor(.red, for: .normal)
		searchButton.layer.backgroundColor = UIColor.black.cgColor
		searchButton.titleEdgeInsets.left = 4
		searchButton.titleEdgeInsets.right = 4
		searchButton.layer.cornerRadius = 8
		searchButton.setTitle("Search For Pokemon", for: .normal)
		testButton.titleLabel?.text = "Test Button"
		
		testButton.rx
			.tap
			.debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
			.subscribe { _ in
			self.viewModel?.testButton()
		}
			.disposed(
				by: disposeBag)
		searchButton.rx.tap.subscribe { _ in
			self.coordinator?.eventOccured(with: .startGame)
		}
		.disposed(by: disposeBag)
		viewModel?.getStateObservable().subscribe(onNext: { (holderModels) in
			self.dynamicCollectionView.pushImmutableList(holderModels: holderModels)
		})
		.disposed(by: disposeBag)
		// Do any additional setup after loading the view.
		viewModel?.pushInitialScreenState()

		
		
		viewModel?
			.callbackObservable()
			.subscribe( onNext: { observableString in
				print("OBSERVABLE \(observableString)")
			})
			.disposed(by: disposeBag)
		
	}
	
	
	
}

