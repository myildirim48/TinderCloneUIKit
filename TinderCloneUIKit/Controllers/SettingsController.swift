//
//  SettingController.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 16.05.2023.
//

import UIKit
import Firebase
import JGProgressHUD
import FirebaseStorage

class CustomImagePickerController: UIImagePickerController {
    var imageButton: UIButton?
}

class SettingsController: UITableViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //    Instance Properties
    lazy var image1Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image2Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image3Button = createButton(selector: #selector(handleSelectPhoto))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
        tableView.tableHeaderView = header
        tableView.tableHeaderView?.layoutIfNeeded()
        

        fetchCurrentUser()
    }
    
    //MARK: - User
    var user: User?
    
    fileprivate func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid)
            .getDocument { snapshot, error in
                if let error {
                    print("DEBUG: Error at fetchUser, \(error.localizedDescription)")
                    return
                }
                guard let dictionary = snapshot?.data() else { return }
                self.user = User(dictionary: dictionary)
                self.loadUserPhotos()
                self.tableView.reloadData()
            }
    }
    
    fileprivate func loadUserPhotos() {
        guard let imageUrl = user?.imageUrl1 else { return }
        Task {
            let image = await ImageFetcher.shared.downloadImage(from: imageUrl)
            self.image1Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
    }
    
    //MARK: - Select photo
    
    @objc fileprivate func handleSelectPhoto(button: UIButton){
        let imagePicker = CustomImagePickerController()
        imagePicker.delegate = self
        imagePicker.imageButton = button
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        let imageButton = (picker as? CustomImagePickerController)?.imageButton
        imageButton?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true)
        
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Uploading image..."
        hud.show(in: view)
        
        let fileName = UUID().uuidString
        guard let uploadData = selectedImage?.jpegData(compressionQuality: 0.75) else { return }
        let reference = Storage.storage().reference(withPath: "/images/\(fileName)")
        reference.putData(uploadData) { _, error in
            
            
            if let error {
                print("DEBUG: Error while uploading photo, \(error.localizedDescription)")
                hud.dismiss()
                return
            }
            
            reference.downloadURL { url, error in
                hud.dismiss()
                if let error {
                    print("DEBUG: Failed while downloading url, \(error.localizedDescription)")
                    return
                }
                
                if imageButton == self.image1Button {
                    self.user?.imageUrl1 = url?.absoluteString
                } else if imageButton == self.image2Button {
                    self.user?.imageUrl2 = url?.absoluteString
                }else {
                    self.user?.imageUrl3 = url?.absoluteString
                }
            }
        }
    }
    
    //MARK: - UIButtons
    
    func createButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }
    
    
    //MARK: - TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 5 {
            let ageRangeCell = AgeRangeCell(style: .default, reuseIdentifier: nil)
            ageRangeCell.minSlider.addTarget(self, action: #selector(handleMinAgeChanged), for: .valueChanged)
            ageRangeCell.maxSlider.addTarget(self, action: #selector(handleMaxAgeChanged), for: .valueChanged)
            ageRangeCell.maxLabel.text = "Min \(user?.maxSeekingAge ?? -1)"
            ageRangeCell.minLabel.text = "Max \(user?.minSeekingAge ?? -1)"
            return ageRangeCell
        }
        
        let cell = SettingsCell(style: .default, reuseIdentifier: nil)
        
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Enter Name"
            cell.textField.text = user?.name
            cell.textField.addTarget(self, action: #selector(handleNameChanged), for: .editingChanged)
        case 2:
            cell.textField.placeholder = "Enter Profession"
            cell.textField.text = user?.profession
            cell.textField.addTarget(self, action: #selector(handleProfessionChanged), for: .editingChanged)
        case 3:
            cell.textField.placeholder = "Enter Age"
            if let age = user?.age {
                cell.textField.text = String(age)
            }
            cell.textField.addTarget(self, action: #selector(handleAgeChanged), for: .editingChanged)
        default:
            cell.textField.placeholder = "Enter Bio"
            
        }
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    //MARK: -  AgeRange Func
    @objc fileprivate func handleMinAgeChanged(slider: UISlider) {
        let indexPath = IndexPath(row: 0, section: 5)
        let ageRangeCell = tableView.cellForRow(at: indexPath) as! AgeRangeCell
        ageRangeCell.minLabel.text = "Min \(Int(ageRangeCell.minSlider.value))"
        
        self.user?.minSeekingAge = Int(slider.value)
    }
    @objc fileprivate func handleMaxAgeChanged(slider: UISlider) {
        let indexPath = IndexPath(row: 0, section: 5)
        let ageRangeCell = tableView.cellForRow(at: indexPath) as! AgeRangeCell
        ageRangeCell.maxLabel.text = "Max \(Int(ageRangeCell.maxSlider.value))"
        
        self.user?.maxSeekingAge = Int(slider.value)
    }
    
    //MARK: - Textfield Funcs
    @objc fileprivate func handleNameChanged(textField: UITextField){
        self.user?.name = textField.text
    }
    @objc fileprivate func handleProfessionChanged(textField: UITextField){
        self.user?.profession = textField.text
    }
    @objc fileprivate func handleAgeChanged(textField: UITextField){
        self.user?.age = Int(textField.text ?? "")
    }
    
    //MARK: - Header
    class HeaderLabel: UILabel {
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.insetBy(dx: 16, dy: 0))
        }
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return header
        }
        let headerLabel = HeaderLabel()
        switch section {
        case 1:
            headerLabel.text = "Name"
        case 2:
            headerLabel.text = "Profession"
        case 3:
            headerLabel.text = "Age"
        case 4:
            headerLabel.text = "Bio"

        default:
            headerLabel.text = "Seeking Age Range"
        }
        headerLabel.font = UIFont.boldSystemFont(ofSize: 16)
        return headerLabel
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 300
        }
        return 40
    }

    lazy var header: UIView = {
        let header = UIView()
        
        header.addSubview(image1Button)
        let padding: CGFloat = 16
        image1Button.anchor(top: header.topAnchor, leading: header.leadingAnchor, bottom: header.bottomAnchor, trailing: nil, padding: .init(top: padding, left: padding, bottom: padding, right: 0))
        image1Button.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.5).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [image2Button,image3Button])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = padding
        
        header.addSubview(stackView)
        stackView.anchor(top: header.topAnchor, leading: image1Button.trailingAnchor, bottom: header.bottomAnchor, trailing: header.trailingAnchor,padding: .init(top: padding, left: padding, bottom: padding, right: padding))
        return header
    }()
    
    //MARK: -  Navigation Items
    fileprivate func setupNavigationItems() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave)),
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))]
    }
    
    @objc fileprivate func handleLogout(){
        
    }
    @objc fileprivate func handleSave(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let docData: [String:Any] = [
            "uid": uid,
            "fullName": user?.name ?? "",
            "imgUrl1": user?.imageUrl1 ?? "",
            "imgUrl2": user?.imageUrl2 ?? "",
            "imgUrl3": user?.imageUrl3 ?? "",
            "age": user?.age ?? -1,
            "profession": user?.profession ?? "",
            "minSeekingAge": user?.minSeekingAge ?? -1,
            "maxSeekingAge": user?.maxSeekingAge ?? -1]
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving settings"
        hud.show(in: view)
        
        Firestore.firestore().collection("users").document(uid)
            .setData(docData) { err in
                hud.dismiss()
                if let err {
                    print(err)
                    return
                }
                print("DEBUG: Saved user details")
            }
    }
    @objc fileprivate func handleCancel(){
        dismiss(animated: true)
    }
    
}
