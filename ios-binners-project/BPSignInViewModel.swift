//
//  BPSignInViewModel.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 7/14/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit

protocol SignInDelegate {
    
    func didSignIn(_ success:Bool,errorMsg: String?)
}

class BPSignInViewModel : BPLoginViewModel {
    
    var signInDelegate:SignInDelegate?

    func validatePasswords(_ passwod: String?,confirmPassword: String?) -> BPLoginViewModel.ValidationStatus {
        
        switch validatePassword(passwod) {
        case .failed(let msg):
            return .failed(msg)
        default: break
        }
        
        return validatePassword(confirmPassword)

    }
    
    func signInUser(_ email: String, password: String) {
        
        BPUserService.registerResident(
            email,
            password: password,
            onSucess: { (user: BPUser) in
                self.signInDelegate?.didSignIn(true, errorMsg:nil)
        
            },onFailure: { (error: BPError) in
                
                self.signInDelegate?.didSignIn(false, errorMsg: error.errorMsg())
        
            })
    }
    
}
