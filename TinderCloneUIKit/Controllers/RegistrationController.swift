//
//  RegistrationController.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 13.05.2023.
//

import UIKit

class RegistrationController: UIViewController {

    
    let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize:32,weight: .heavy)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 275).isActive = true
        button.layer.cornerRadius = 16
        return button
    }()
    
    let fullNameTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter your fullname"
        return tf
    }()
    
    let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter Email"
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    let passwordTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter password"
        tf.isSecureTextEntry = true
        return tf
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientLayer()
        
        let stackView = UIStackView(arrangedSubviews: [selectPhotoButton,fullNameTextField,emailTextField,passwordTextField])
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    fileprivate func setupGradientLayer(){
        let gradientLayer = CAGradientLayer()
        let topColor = #colorLiteral(red: 1, green: 0.4528897405, blue: 0.4463171959, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.9285591245, green: 0.1666099727, blue: 0.5210822225, alpha: 1)
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
    
}
