//
//  AuthViewModel.swift
//  TinderCloneUIKit
//
//  Created by YILDIRIM on 18.05.2023.
//

import Foundation

protocol AuthenticationViewModel {
    var formIsValid: Bool { get }
}

struct LoginViewModel: AuthenticationViewModel {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false &&
        password?.isEmpty == false
    }
}

struct RegistrationViewModel: AuthenticationViewModel {
    var email: String?
    var password: String?
    var fullName: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false &&
        password?.isEmpty == false &&
        fullName?.isEmpty == false
    }
}
