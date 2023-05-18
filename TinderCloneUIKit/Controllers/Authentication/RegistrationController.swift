//
//  RegistrationController.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 18.05.2023.
//

import UIKit
class RegistrationController: UIViewController {
    
    //MARK: - Properties
    
    private var viewModel = RegistrationViewModel()
    
    private let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        
        button.setImage( #imageLiteral(resourceName: "plus_photo"), for: .normal)
        
        return button
    }()
    private let emailTextField = CustomTextField(placeholder: "Email")
    private let fullNameTextField = CustomTextField(placeholder: "Full Name", isSecureText: true)
    private let passwordTextField = CustomTextField(placeholder: "Password", isSecureText: true)
    
    private let registerButton = AuthButton(title: "Register", type: .system)
    private let goToLoginButton = TextButton(title: "Already have an account", boldTitle: "Sign In")
    
    private var profileImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureActions()
        configureTextFieldObservers()
    }
    //MARK: - Actions
    func configureActions()  {
        selectPhotoButton.addTarget(self, action: #selector(handlePhotoSelect), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(handleRegisterUser), for: .touchUpInside)
        goToLoginButton.addTarget(self, action: #selector(handleGoToLogin), for: .touchUpInside)
    }
    
    @objc fileprivate func handlePhotoSelect(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    @objc fileprivate func handleRegisterUser(){
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullName = fullNameTextField.text else { return }
        guard let profileImage else { return }
        let credentials = AuthCredentials(email: email,
                                          password: password,
                                          fullName: fullName,
                                          profileImage: profileImage)
        AuthService.registerUser(withCredential: credentials) { error in
            if let error {
                print("DEBUG: Error while registering user, \(error.localizedDescription)")
                return
            }
            
            print("DEBUG: User registered successfully")
        }
    }
    
    @objc fileprivate func handleGoToLogin(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func textDidChange(sender: UITextField){
        if sender == emailTextField {
            viewModel.email = sender.text
        }else if sender == passwordTextField{
            viewModel.password = sender.text
        }else {
            viewModel.fullName = sender.text
        }
        checkFormStatus()
    }
    
    //MARK: - TextField Observers
    
    func configureTextFieldObservers(){
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }

    
    
    //MARK: - Helpers
    
    func checkFormStatus() {
        if viewModel.formIsValid {
            registerButton.isEnabled = true
            registerButton.backgroundColor = #colorLiteral(red: 0.8567113876, green: 0, blue: 0.3137886524, alpha: 1)
        }else {
            registerButton.isEnabled = false
            registerButton.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)

        }
    }
    
    func configureUI() {
        configureGradientLayer()
        view.addSubview(selectPhotoButton)
        selectPhotoButton.setDimensions(height: 275, width: 275)
        selectPhotoButton.centerX(inView: view)
        selectPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField,
                                                       fullNameTextField,
                                                       passwordTextField,
                                                       registerButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        view.addSubview(stackView)
        
        stackView.anchor(top: selectPhotoButton.bottomAnchor,leading: view.leadingAnchor,trailing: view.trailingAnchor, padding: .init(top: 24, left: 32, bottom: 0, right: 32))
        
        view.addSubview(goToLoginButton)
        goToLoginButton.anchor(leading: view.leadingAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor,trailing: view.trailingAnchor)
    }
}

//MARK: - Delegates

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        profileImage = image
        selectPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        selectPhotoButton.layer.borderColor = UIColor(white: 1, alpha: 1).cgColor
        selectPhotoButton.layer.borderWidth = 3
        selectPhotoButton.layer.cornerRadius = 10
        selectPhotoButton.clipsToBounds = true
        selectPhotoButton.imageView?.contentMode = .scaleAspectFill
        
        dismiss(animated: true)
    }
}
