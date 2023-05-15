//
//  RegistrationController.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 13.05.2023.
//

import UIKit
import Firebase
import FirebaseStorage
import JGProgressHUD

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        registraionViewModel.bindableImage.value = image
        
        dismiss(animated: true)
    }
}

class RegistrationController: UIViewController {
    let gradientLayer = CAGradientLayer()

    
    let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize:32,weight: .heavy)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 275).isActive = true
        button.layer.cornerRadius = 16
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(selectPhoto), for: .touchUpInside)
        return button
    }()
    
    @objc func selectPhoto(){
        let imagePicketController = UIImagePickerController()
        imagePicketController.delegate = self
        present(imagePicketController, animated: true)
    }
    
    
    let fullNameTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter your fullname"
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter Email"
        tf.keyboardType = .emailAddress
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)

        return tf
    }()
    
    let passwordTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter password"
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16,weight: .heavy)
        button.backgroundColor = .lightGray
        button.setTitleColor(.darkGray, for: .disabled)
        button.isEnabled = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.layer.cornerRadius = 22
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    let registeringUHD = JGProgressHUD(style: .dark)
    
    @objc fileprivate func handleRegister(){
        self.handleTapDissmis()
        registraionViewModel.performRegistration { [weak self] err in
            guard let self else { return }
            if let err {
                showHUDWithEror(error: err)
                return
            }
        }
    }
    

    fileprivate func showHUDWithEror(error: Error) {
        registeringUHD.dismiss(animated: true)
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed Registration"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientLayer()
        
        setupLayout()
        
        setupNotificationObservers()
        
        setupTapGesture()
        
        setupRegistrationViewModelObserver()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        NotificationCenter.default.removeObserver(self)
    }
    
    
    //MARK: - private
    let registraionViewModel = RegistrationViewModel()
    
    fileprivate func setupRegistrationViewModelObserver() {
        
        registraionViewModel.bindableIsFormValid.bind {[weak self] isformValid in
            guard let self else { return }
            guard let isformValid else { return }
            registerButton.isEnabled = isformValid

            if isformValid {
                registerButton.backgroundColor = #colorLiteral(red: 0.8235294118, green: 0, blue: 0.3254901961, alpha: 1)
                registerButton.setTitleColor(.white, for: .normal)
            } else {
                registerButton.backgroundColor = .lightGray
                registerButton.setTitleColor(.gray, for: .normal)
            }
        }
        
        registraionViewModel.bindableIsRegistering.bind { [weak self] isRegistering in
            
            guard let self else { return }
            
            if isRegistering == true {
                registeringUHD.textLabel.text = "Regsiter"
                registeringUHD.show(in: view)
            }else {
                registeringUHD.dismiss(animated: true)
            }
        }
        
        registraionViewModel.bindableImage.bind { image in
            self.selectPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)

        }
    }
    
    @objc fileprivate func handleTextChange(textfield: UITextField) {
        if textfield == fullNameTextField {
            registraionViewModel.fullName = textfield.text
        } else if textfield == emailTextField {
            registraionViewModel.email = textfield.text
        } else {
            registraionViewModel.password = textfield.text
        }
    }
    
    fileprivate func setupTapGesture(){
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDissmis)))
    }
    
    @objc fileprivate func handleTapDissmis(){
        self.view.endEditing(true)

    }

    fileprivate func setupNotificationObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc fileprivate func handleKeyboardHide(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.view.transform = .identity
        }
    }
    @objc fileprivate func handleKeyboardShow(notification: Notification){
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        print(keyboardFrame)
        let bottomSpace = view.frame.height - overallStackView.frame.origin.y - overallStackView.frame.height
        let difference = keyboardFrame.height - bottomSpace
        print(bottomSpace)
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
        
    }
    lazy var verticalStackView : UIStackView = {
       let sv =  UIStackView(arrangedSubviews: [fullNameTextField,
                                                emailTextField,
                                                passwordTextField,
                                                registerButton])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    }()
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if self.traitCollection.verticalSizeClass == .compact {
            overallStackView.axis = .horizontal
            
        }else {
            overallStackView.axis = .vertical
        }
    }
    lazy var overallStackView = UIStackView(arrangedSubviews: [selectPhotoButton, verticalStackView])
    fileprivate func setupLayout() {
      
        view.addSubview(overallStackView)
        overallStackView.axis = .vertical
        selectPhotoButton.widthAnchor.constraint(equalToConstant: 275).isActive = true
        overallStackView.spacing = 8
        overallStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        overallStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    fileprivate func setupGradientLayer(){
        let topColor = #colorLiteral(red: 1, green: 0.4528897405, blue: 0.4463171959, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.9285591245, green: 0.1666099727, blue: 0.5210822225, alpha: 1)
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
    
}
