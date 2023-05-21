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
    
    //MARK: - Properties
    private var user: User?
    private let topStackView = TopNavigationStackView()
    private let deckStackView = UIView()
    private let bottomStackView = HomeButtonControlsStackView()
    
    private var viewModels = [CardViewModel]() {
        didSet{ configureCards() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserLoggedIn()
        configureUI()
        fetchUsers()

        fetchUser()
//        logout()
    }
    
    //MARK: - API
    
    func fetchUsers() {
        Service.fetchUsers { users in
            self.viewModels = users.map({ CardViewModel(user: $0) })
        }
    }
    
    func fetchUser()  {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Service.fetchUser(withUid: uid) { user in
            self.user = user
        }
    }
    
    func checkIfUserLoggedIn(){
        if Auth.auth().currentUser == nil {
            presentLoginController()
        }else {
            
        }
    }
    
    func logout(){
        do {
            try Auth.auth().signOut()
            presentLoginController()
        } catch {
            print("DEBUG: Error while logout")
        }
    }
    
    //MARK: - Helper
    
    func configureCards() {
        viewModels.forEach { cardViewModel in
            let cardView = CardView(viewModel: cardViewModel)
            deckStackView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        topStackView.delegate = self
        
        let stack = UIStackView(arrangedSubviews: [topStackView,deckStackView,bottomStackView])
        stack.axis = .vertical
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        stack.bringSubviewToFront(deckStackView)
    }
    
    func presentLoginController() {
        DispatchQueue.main.async {
            let controller = LoginController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }
}
//MARK: - HomeNavigationStackViewDelegate
extension HomeController: HomeNavigationStackViewDelegate {
    func showSettings() {
        guard let user else { return }
        let controller = SettingsController(user: user)
        controller.delegate = self 
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    func showMessages() {
        let controller = MessagesController()
        present(controller, animated: true)
    }
}

//MARK: - SettingsControllerDelegate

extension HomeController: SettingsControllerDelegate {
    func settingsControllerWanttoLogout(_ controller: SettingsController) {
        controller.dismiss(animated: true)
        logout()
    }
    
    func settingsController(_ controller: SettingsController, wantsToUpdate user: User) {
        controller.dismiss(animated: true)
        self.user = user
    }
}
