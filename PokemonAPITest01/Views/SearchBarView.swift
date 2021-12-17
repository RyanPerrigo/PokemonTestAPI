//
//  SearchBarView.swift
//  PokemonAPITest01
//
//  Created by Ryan Perrigo on 12/16/21.
//


import UIKit
import RxSwift

@IBDesignable
class SearchBarView: UIView {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!
    private var onTextEnteredCallback: ((String)->Void)?
    private var onSearchClickedCallback:(()->Void)?
    private let disposeBag = DisposeBag()
    
    private let nibName = "SearchBarView"
    private var contentView: UIView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 70)
    }
    
    private func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
        button.contentEdgeInsets.left = 10
        button.contentEdgeInsets.right = 10
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.white.cgColor
        button.shadowDecorate()
        button.setAttributedTitle(NSAttributedString(string: "Search", attributes: [
            .font:UIFont.systemFont(ofSize: 10, weight: .semibold),
            .foregroundColor: UIColor.white
            ]
        ),
            for: .normal)
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onSearchClicked)))
        
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search For a Pokemon",
            attributes: [
                .font:UIFont.systemFont(ofSize: 12, weight: .light),
                .foregroundColor : UIColor.systemGray
            ])
        textField.addTarget(self, action: #selector(self.ontextEntered), for: .editingChanged)
    }
    @objc private func ontextEntered() {
        guard let safeText = textField.text else {return}
        onTextEnteredCallback?(safeText)
    }
    @objc private func onSearchClicked() {
        onSearchClickedCallback?()
    }
    private func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    func setViewActions(onTextEntered:@escaping(String)->Void, onSearchClicked:@escaping()->Void) {
        self.onTextEnteredCallback = onTextEntered
        self.onSearchClickedCallback = onSearchClicked
    }
}
