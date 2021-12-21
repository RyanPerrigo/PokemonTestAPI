//
//  PokemonVC.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 8/7/21.
//

import RxSwift
import RxCocoa
import Reusable

class PokemonSearchVC: UIViewController, ViewModelBased, StoryboardBased, UITableViewDelegate, UITableViewDataSource {
	
    @IBOutlet weak var topLevelStackView: UIStackView!
    @IBOutlet weak var dynamicCollectionView: DynamicCollectionView!
	
    var coordinator: MainCoordinator?
	var viewModel: PokemonSearchVM?
	let disposeBag = DisposeBag()
	
	
	override func viewDidLoad() {
		
		print("viewDidLoad()")
        let tableView = UITableView()
		
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
		viewModel?.navigateToSinglePokeDetailCallback = { toplevelEntity in
			
			self.coordinator?
				.eventOccured(with: .singlePokemonClicked(
					toplevelEntity,
					nil
				))
		}
		let searchBar = SearchBarView()
       
        searchBar.setViewActions(
            onTextEntered: { textString in
                if textString.isEmpty {
                    self.topLevelStackView.removeArrangedSubview(tableView)
                }
            }, onSearchClicked: { textFieldText in
            print("Search clicked \(textFieldText)")
                self.viewModel?.onSearchClicked(searchText: textFieldText)
        },
            allPokemonArray: viewModel!.getAllPokemonArray(),
            allMatchesCallBack: { allMatchesArray in
                
                if !allMatchesArray.isEmpty {
                    self.viewModel?.setPokemonSearchResults(results: allMatchesArray)
                    self.topLevelStackView.insertArrangedSubview(tableView, at: 1)
                }
        }
                                 
        )
        viewModel?.searchTableDataSourceObservable().subscribe(onNext: { arrayOfResults in
            tableView.reloadData()
        })
            .disposed(
                by: disposeBag)
        self.topLevelStackView.insertArrangedSubview(searchBar, at: 0)
        
		viewModel?
			.screenStateObservable()
			.subscribe(onNext: { (screenState) in
				
				switch(screenState) {
				
				case .loading:
					
					let spinnerModel = LoadingVHM()
					
					self.dynamicCollectionView.pushImmutableList(holderModels: [spinnerModel])
				case let .success(holderModels):
					
					self.dynamicCollectionView.pushImmutableList(holderModels: holderModels)
					
				case .error:
					print("Error")
				//display error state
				
				case .nextPageLoading:
					
					print("somethingElse")
				case .nextPageLoadSuccess(holderModels: let holderModels):
                    
                    self.dynamicCollectionView.pushImmutableList(holderModels: holderModels)
					print("something\(holderModels)")
                case .onSearchClicked(let pokemonTopLevelEntity):
                 
                    DispatchQueue.main.async {
                        self.dismiss(animated: false)
                        self.coordinator?
                            .eventOccured(with: .singlePokemonClicked(
                                pokemonTopLevelEntity,
                                nil
                            ))
                    }
                    
				}
				
			},
                       onError: {error in
                debugPrint(error)
            })
			.disposed(by: disposeBag)
		
        dynamicCollectionView.setLastCellDisplayedListener {
            debugPrint("Bottom Detected!!!")
            self.viewModel?.onScrollToBottomDetected()
        }
	}
        // TABLE VIEW DELEGATE METHODS
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel!.getPokemonAutoCompleteResults().count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        cell.textLabel?.text = viewModel?.getPokemonAutoCompleteResults()[indexPath.row]
        return cell
        
    }
}
