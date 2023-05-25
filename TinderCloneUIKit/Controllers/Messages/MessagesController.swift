//
//  MessagesController.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 19.05.2023.
//

import UIKit

class MessagesController: UITableViewController {

    //MARK: -  Properties
    
    private let user: User
    private let headerView = MatchHeaderView()
    
    
    //MARK: -  Lifecycle
    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }

    override func viewDidLoad() {
        configureTableView()
        configureNavbar()
        fetchMatches()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: -  Helpers

    func configureTableView() {
        tableView.rowHeight = 80
        tableView.tableFooterView = UIView()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "")
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
        tableView.tableHeaderView = headerView
        headerView.delegate = self
        
    }
    
    func configureNavbar() {
        let leftButton = UIImageView()
        leftButton.setDimensions(height: 28, width: 28)
        leftButton.isUserInteractionEnabled = true
        leftButton.image = #imageLiteral(resourceName: "app_icon").withRenderingMode(.alwaysTemplate)
        leftButton.tintColor = .gray
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
        leftButton.addGestureRecognizer(tap)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        
        let icon = UIImageView(image: #imageLiteral(resourceName: "top_right_messages"))
        icon.tintColor = .systemPink
        navigationItem.titleView = icon
    }
    //MARK: - API
    
    func fetchMatches() {
        Service.fetchMatches { matches in
            self.headerView.matches = matches
        }
    }
    
    //MARK: - Actions
    
    @objc func handleDismiss(){
        dismiss(animated: true)
    }
}

//MARK: - Tableview DataSource
extension MessagesController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "",for: indexPath)
        return cell
    }
}

//MARK: - TableView Delegate
extension MessagesController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.9921568627, green: 0.3568627451, blue: 0.3725490196, alpha: 1)
        label.text = "Messages"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        
        view.addSubview(label)
        label.centerY(inView: view, leftAnchor: view.leadingAnchor, paddingLeft: 12)
        return view
    }
}

//MARK: - MatchHeader Delegate
extension MessagesController: MatchHeaderDelegate {
    func matchHeader(_ header: MatchHeaderView, wantsToSendMessageTo uid: String) {
        Service.fetchUser(withUid: uid) { user in
            print("DEBUG: Fetched user for meessage, \(user.fullName)")
        }
    }
}
