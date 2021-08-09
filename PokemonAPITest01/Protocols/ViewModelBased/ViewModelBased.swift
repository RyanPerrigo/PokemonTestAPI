//
//  ViewModelBased.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 7/20/21.
//

import Foundation
import Reusable

protocol ViewModel {
	
}

protocol ViewModelBased {
	associatedtype ViewModelType = ViewModel
	var viewModel: ViewModelType? {get set}
}

extension ViewModelBased where Self: StoryboardBased & UIViewController {
	
	static func instantiate<ViewModelType>(withViewModel viewModel: ViewModelType) -> Self where ViewModelType == Self.ViewModelType  {
		var viewController = Self.instantiate()
		viewController.viewModel = viewModel
		return viewController
	}
	
}
