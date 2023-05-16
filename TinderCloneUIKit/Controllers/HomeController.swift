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
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let buttonControllers = HomeButtonControlsStackView()
    
    //    let cardViewModels = ([
    //        User(name: "Jane", age: 23, profession: "DJ At", imageNames: ["jane1","jane2","jane3"]),
    //        User(name: "Kelly", age: 19, profession: "Waitress", imageNames: ["kelly1", "kelly2", "kelly3"]),
    //        Advertiser(title: "Slide out menu", brandName: "Lets Build That App", posterPhotoName: "slide_out_menu_poster")
    //    ]  as [ProducesCardViewModel]).map { produce -> CardViewModel in
    //        return produce.toCardViewModel()
    //    }
    
    var cardViewModels = [CardViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        buttonControllers.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        
        
        setupLayout()
        
        setupFirestoreUserCards()
        fetchUsersFromFirestore()
    }
    
    @objc fileprivate func handleRefresh(){
        fetchUsersFromFirestore()
    }
    
    var lastFetchedUser: User?
    
    fileprivate func fetchUsersFromFirestore() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetching Users.."
        hud.show(in: view)
        let userQuery = Firestore.firestore().collection("users").order(by: "uid").start(after: [lastFetchedUser?.uid ?? ""]).limit(to: 2)
        
        userQuery
            .getDocuments { snaphsot, error in
                if let error {
                    print("DEBUG: Error while fetching data from firestore \(error.localizedDescription)")
                }
                
                snaphsot?.documents.forEach({ docSnapshot in
                    hud.dismiss()
                    let userDictionary = docSnapshot.data()
                    let user = User(dictionary: userDictionary)
                    self.cardViewModels.append(user.toCardViewModel())
                    self.lastFetchedUser = user
                    self.setupCard(user: user)
                })
                
            }
    }
    fileprivate func setupCard(user:User){
        let cardView = CardView(frame: .zero)
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
    }
    
    @objc func handleSettings() {
        let settingsController = SettingsController()
        let navController = UINavigationController(rootViewController: settingsController)
        present(navController, animated: true)
    }
    
    //MARK: - Fileprivate
    fileprivate func setupLayout() {
        view.backgroundColor = .white
        let overallStackView = UIStackView(arrangedSubviews: [topStackView,cardsDeckView,buttonControllers])
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
    
    fileprivate func setupFirestoreUserCards(){
        
        cardViewModels.forEach { cardVM in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardVM
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
}

