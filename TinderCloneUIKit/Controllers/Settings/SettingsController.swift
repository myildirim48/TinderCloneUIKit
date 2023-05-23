//
//  SettingsController.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 19.05.2023.
//

import UIKit
import JGProgressHUD

protocol SettingsControllerDelegate:AnyObject {
    func settingsController(_ controller: SettingsController, wantsToUpdate user: User)
    func settingsControllerWanttoLogout(_ controller: SettingsController)
}
class SettingsController: UITableViewController {

    //MARK: -  Properties
    
    private var user: User
    
    weak var delegate: SettingsControllerDelegate?
    
    private lazy var headerView = SettingsHeader(user: user)
    private let footerView = SettingsFooter()
    private let imagepicker = UIImagePickerController()
    private var imageIndex = 0
    
    //MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()


    }
    
    //MARK: - Helpers
    
    func setHedaerImage(_ image: UIImage?) {
        headerView.buttons[imageIndex].setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    func setupUI() {
        headerView.delegate = self
        imagepicker.delegate = self
        
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        
        tableView.separatorStyle = .none
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = footerView
        tableView.backgroundColor = .systemGroupedBackground
        tableView.isUserInteractionEnabled = true
        tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.reuseIdentifier)
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 88)
        
        footerView.deleagate = self
    }

    //MARK: -  API
    func uploadImage(image: UIImage)  {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving Image..."
        hud.show(in: view)
        
        Service.uploadImage(image: image) { imgUrl in
            self.user.imageUrls.append(imgUrl)
            hud.dismiss()
        }
    }
    
    //MARK: - Actions
    
    @objc fileprivate func handleCancel(){
        dismiss(animated: true)
    }
    
    @objc fileprivate func handleDone(){
        view.endEditing(true)
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving Data..."
        hud.show(in: view)
        
        
        Service.saveUserData(user: user) { _ in
            hud.dismiss()
            self.delegate?.settingsController(self, wantsToUpdate: self.user)
        }
    }
}

//MARK: - UITableViewDataSource
extension SettingsController{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.reuseIdentifier, for: indexPath) as! SettingsCell
        guard let section = SettingsSection(rawValue: indexPath.section) else { return cell}
        let viewModel = SettingsViewModel(user: user, section: section)
        cell.viewModel = viewModel
        cell.delegate = self
        return cell
    }
}
//MARK: - UITableViewDelegate
extension SettingsController{
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = SettingsSection(rawValue: section) else { return nil }
        return section.description
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = SettingsSection(rawValue: indexPath.section) else { return 0 }
        
        return section == .ageRange ? 96 : 44
    }
}
//MARK: - Settings Header Delegate

extension SettingsController: SettingsHeaderDelegate{
    func settingsHeader(_ header: SettingsHeader, didselect index: Int) {
        self.imageIndex = index
     present(imagepicker, animated: true)
    }
}

//MARK: - ImagePicker Controller
extension SettingsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        
        uploadImage(image: selectedImage)
        setHedaerImage(selectedImage)
        dismiss(animated: true)
    }
}

//MARK: - SettingsCellDelegate
extension SettingsController: SettingsCellDelegate {
    
    func settingsCell(_ cell: SettingsCell, wantsToUpdateAgeRange sender: UISlider) {
        if sender == cell.minAgeSlider {
            user.minSeekingAge = Int(sender.value)
        }else {
            user.maxSeekingAge = Int(sender.value)
        }
    }
    func settingsCell(_ cell: SettingsCell, wantsToUpdateUserWith value: String, for section: SettingsSection) {
        switch section {
        case .name:
            user.fullName = value
        case .profession:
            user.profession = value
        case .age:
            user.age = Int(value) ?? 0
        case .bio:
            user.bio = value
        case .ageRange:
            break
        }
        
        print("DEBUG: User, \(user)")
    }
}

extension SettingsController: SettingsFooterDelegate {
    func handleLogout() {
        delegate?.settingsControllerWanttoLogout(self)
    }
}
