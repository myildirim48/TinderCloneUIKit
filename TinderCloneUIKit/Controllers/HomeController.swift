//
//  ViewController.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 11.05.2023.
//

import UIKit

class HomeController: UIViewController {
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let buttonStackView = HomeButtonControlsStackView()

    let cardViewModels = ([
        User(name: "Jane", age: 23, profession: "DJ At", imageNames: ["jane1","jane2","jane3"]),
        User(name: "Kelly", age: 19, profession: "Waitress", imageNames: ["kelly1", "kelly2", "kelly3"]),
        Advertiser(title: "Slide out menu", brandName: "Lets Build That App", posterPhotoName: "slide_out_menu_poster")
    ]  as [ProducesCardViewModel]).map { produce -> CardViewModel in
        return produce.toCardViewModel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        
        setupLayout()
        setupDummyCard()
        
    }
    
   @objc func handleSettings() {
        let registrationController = RegistrationController()
       present(registrationController, animated: true)
    }
    
//MARK: - Fileprivate
    fileprivate func setupLayout() {
        let overallStackView = UIStackView(arrangedSubviews: [topStackView,cardsDeckView,buttonStackView])
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                leading: view.leadingAnchor,
                                bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                trailing: view.trailingAnchor)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        overallStackView.bringSubviewToFront(cardsDeckView)
    }
    
    fileprivate func setupDummyCard(){
        
        cardViewModels.forEach { cardVM in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardVM
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
}

