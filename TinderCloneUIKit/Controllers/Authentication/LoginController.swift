//
//  LoginController.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 18.05.2023.
//

import UIKit
import JGProgressHUD

protocol AuthenticationDelegate: AnyObject {
    func authenticationCompleted()
}
class LoginController: UIViewController {
    
    //MARK: -  Properties
    
    weak var delegate: AuthenticationDelegate?
     
    private var loginViewModel = LoginViewModel()
    
    private let iconImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "app_icon").withRenderingMode(.alwaysTemplate)
        iv.tintColor = .white
        return iv
    }()
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    private let passwordTextField = CustomTextField(placeholder: "Password", isSecureText: true)
    
    private let authButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Log in", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        return button
    }()
    
    private let goToRegistrationButton = TextButton(title: "Don't have an account?", boldTitle: "Sign Up")

    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureActions()
        configureTextFieldObservers()
    }
    
    //MARK: -  Actions
    
    func configureActions() {
        authButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        goToRegistrationButton.addTarget(self, action: #selector(handleShowRegistration), for: .touchUpInside)
    }
    
    @objc fileprivate func handleLogin(){
        
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: view)
        
        guard let email = emailTextField.text else { return }
        guard let password = emailTextField.text else { return }
        AuthService.userLogin(withEmail: email, password: password) { authResult, error in
            if let error {
                print("DEBUG: Error while user sigin, \(error.localizedDescription)")
                hud.dismiss()
                return
            }
            hud.dismiss()
            self.delegate?.authenticationCompleted()
        }
    }
    
    @objc fileprivate func handleShowRegistration(){
        let controller = RegistrationController()
        controller.delegate = delegate
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc fileprivate func textDidChange(sender: UITextField){
        if sender == emailTextField {
            loginViewModel.email = sender.text
        }else{
            loginViewModel.password = sender.text
        }
        checkFormStatus()
    }
    //MARK: - TextField Observers
    
    func configureTextFieldObservers(){
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }

    
    //MARK: - Helpers
    func checkFormStatus() {
        if loginViewModel.formIsValid {
            authButton.isEnabled = true
            authButton.backgroundColor = #colorLiteral(red: 0.8567113876, green: 0, blue: 0.3137886524, alpha: 1)
        }else {
            authButton.isEnabled = false
            authButton.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)

        }
    }
    
    func configureUI() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        configureGradientLayer()
        
        view.addSubview(iconImageView)
        iconImageView.centerX(inView: view)
        iconImageView.setDimensions(height: 100, width: 100)
        iconImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, padding: .init(top: 32, left: 32, bottom: 32, right: 32))
        
        let stack = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,authButton])
        stack.axis = .vertical
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.anchor(top: iconImageView.bottomAnchor,leading: view.leadingAnchor,trailing: view.trailingAnchor,padding: .init(top: 24, left: 32, bottom: 0, right: 32))
        
        view.addSubview(goToRegistrationButton)
        goToRegistrationButton.anchor(leading: view.leadingAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor,trailing: view.trailingAnchor)
    }
    

}
