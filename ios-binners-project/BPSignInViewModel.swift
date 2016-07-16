//
//  BPSignInViewModel.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 7/14/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit

protocol SignInDelegate {
    
    func didSignIn(success:Bool,errorMsg: String?)
}

class BPSignInViewModel : BPLoginViewModel {
    
    var signInDelegate:SignInDelegate?

    func validatePasswords(passwod: String?,confirmPassword: String?) -> BPLoginViewModel.ValidationStatus {
        
        switch validatePassword(passwod) {
        case .Failed(let msg):
            return .Failed(msg)
        default: break
        }
        
        switch validatePassword(confirmPassword) {
        case .Failed(let msg):
            return .Failed(msg)
        default: return .Passed
        }

    }
    
    func signInUser(email: String, password: String) throws {
        
        try BPUser.registerResident(email, password: password) {
            
            inner in
            
            do {
                self.signInDelegate?.didSignIn(true, errorMsg:nil)
                
            } catch let error as NSError {
                self.signInDelegate?.didSignIn(false, errorMsg: error.description)
            }
            
        }
        
    }
    
}
