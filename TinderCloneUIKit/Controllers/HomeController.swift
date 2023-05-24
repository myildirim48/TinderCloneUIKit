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
    
    private var topCardView: CardView?
    private var cardViews = [CardView]()
    
    private var viewModels = [CardViewModel]() {
        didSet{ configureCards() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserLoggedIn()
        configureUI()
        fetchCurrentUserAndCards()
    }
    
    //MARK: - API
    
    func fetchUsers(forCurrentuser user: User) {
        Service.fetchUsers(forCurrentuser: user) { users in
            self.viewModels = users.map({ CardViewModel(user: $0) })
            
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
    
    func fetchCurrentUserAndCards() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Service.fetchUser(withUid: uid) { user in
            self.user = user
            self.fetchUsers(forCurrentuser: user)
        }
    }
    
    func saveSwipeAndCheckForMatch(forUser user: User, didLike: Bool) {
        Service.saveSwipe(forUser: user, isLike: didLike) { error in
            self.topCardView = self.cardViews.last
            
            guard didLike == true else { return }
            
            Service.checkIfUserMatchExist(forUser: user) { didMatch in
                print("DEBUG: Match")
                self.presentMatchView(forUser: user)
            }
        }
    }
    //MARK: - Helpers
    
    func configureCards() {
        viewModels.forEach { cardViewModel in
            let cardView = CardView(viewModel: cardViewModel)
            cardView.delegate = self
            //            cardViews.append(cardView)
            deckStackView.addSubview(cardView)
            cardView.fillSuperview()
        }
        
        cardViews = deckStackView.subviews.map({ ($0 as? CardView)! })
        topCardView = cardViews.last
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        topStackView.delegate = self
        bottomStackView.delegate = self
        
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
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }
    
    func presentMatchView(forUser user: User) {
        guard let currentUser = self.user else { return }
        let viewModel = MatchViewModel(currentUser:  currentUser, matchedUser: user)
        let matchView = MatchView(viewModel: viewModel)
        matchView.delegate = self
        view.addSubview(matchView)
        matchView.fillSuperview()
        
    }
    
    func performSwipAnimation(shouldLike: Bool) {
        let translation: CGFloat = shouldLike ? 700 : -700
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut) {
            self.topCardView?.frame = CGRect(x: translation, y: 0,
                                             width: (self.topCardView?.frame.width)!,
                                             height: (self.topCardView?.frame.height)!)
        } completion: {  _ in
            self.topCardView?.removeFromSuperview()
            guard !self.cardViews.isEmpty else { return }
            self.cardViews.remove(at: self.cardViews.count - 1)
            self.topCardView = self.cardViews.last
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
        self.user = user
        controller.dismiss(animated: true)
    }
}

//MARK: - CardView Delegate

extension HomeController: CardViewDelegate {
    func cardView(_ view: CardView, didLikeUser: Bool) {
        view.removeFromSuperview()
        self.cardViews.removeAll { view == $0 }
        
        guard let user = topCardView?.viewModel.user else { return }
        saveSwipeAndCheckForMatch(forUser: user, didLike: didLikeUser)
        self.topCardView = cardViews.last
    }
    
    func cardView(_ view: CardView, wantsToShowProfilefor user: User) {
        let controller = ProfileController(user: user)
        controller.modalPresentationStyle = .fullScreen
        controller.delegate = self //CardViewDelegate
        present(controller, animated: true)
    }
}

//MARK: - HomeButtonControls Delegate

extension HomeController: HomeButtonControlsDelegate{
    func handleLike() {
        guard let topCard = topCardView else { return }
        performSwipAnimation(shouldLike: true)
        saveSwipeAndCheckForMatch(forUser: topCard.viewModel.user, didLike: true)
    }
    
    func handleDislike() {
        guard let topCard = topCardView else { return }
        performSwipAnimation(shouldLike: false)
        Service.saveSwipe(forUser: topCard.viewModel.user, isLike: false, completion: nil)
    }
    
    func handleRefresh() {
        print("Refresh")
    }
}


//MARK: -  ProfileController Delegate
extension HomeController: ProfileControllerDelegate{
    
    func profileController(_ controller: ProfileController, didLikeUser user: User) {
        controller.dismiss(animated: true) {
            self.performSwipAnimation(shouldLike: true)
            self.saveSwipeAndCheckForMatch(forUser: user, didLike: true)
        }
    }
    
    func profileController(_ controller: ProfileController, didDislikeUser user: User) {
        controller.dismiss(animated: true) {
            self.performSwipAnimation(shouldLike: false)
            Service.saveSwipe(forUser: user, isLike: false, completion: nil)
        }
    }
}

//MARK: -  Authentication Delegate
extension HomeController: AuthenticationDelegate {
    func authenticationCompleted() {
        dismiss(animated: true)
        fetchCurrentUserAndCards()
    }
}

//MARK: - MatchView Delegate
extension HomeController: MatchViewDelegate {
    func matchView(_ view: MatchView, wantsToSendMessageTo user: User) {
        print("DEBUG: Start converstation with \(user.fullName)")
    }
}
