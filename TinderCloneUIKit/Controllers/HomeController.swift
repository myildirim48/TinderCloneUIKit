//
//  ViewController.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 11.05.2023.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import JGProgressHUD

class HomeController: UIViewController {
    
    private let topStackView = TopNavigationStackView()
    private let deckStackView = UIView()
    private let bottomStackView = HomeButtonControlsStackView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureCards()
    }
    
    //MARK: - Helper
    
    func configureCards() {
        let user1 = User(name: "Jane", age: 22, images: [#imageLiteral(resourceName: "kelly3"), #imageLiteral(resourceName: "kelly1")])
        let user2 = User(name: "Megan", age: 22, images: [#imageLiteral(resourceName: "jane3"), #imageLiteral(resourceName: "jane2")])
        
        let card1 = CardView(viewModel: CardViewModel(user: user1))
        let card2 = CardView(viewModel: CardViewModel(user: user2))
        
        
        deckStackView.addSubview(card1)
        deckStackView.addSubview(card2)
        
        card1.fillSuperview()
        card2.fillSuperview()
        
        
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        let stack = UIStackView(arrangedSubviews: [topStackView,deckStackView,bottomStackView])
        stack.axis = .vertical
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        stack.bringSubviewToFront(deckStackView)
    }
}

