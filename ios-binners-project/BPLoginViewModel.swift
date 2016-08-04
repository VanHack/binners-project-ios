//
//  LoginViewModel.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 7/8/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit

protocol LoginDelegate {
    
    func didLogin(success:Bool, errorMsg:String?)
}
protocol ForgotPasswordDelegate {
    
    func didSendEmail(success:Bool, errorMsg:String?)
}


class BPLoginViewModel {
    
    var loginManager = BPLoginManager.sharedInstance
    var loginDelegate:LoginDelegate?
    var passwordForgotDelegate:ForgotPasswordDelegate?
    
    enum ValidationStatus {
        case Passed
        case Failed(String)
    }
    
    init() {
        GIDSignIn.sharedInstance().delegate = self
    }
    
    
    func validate(userEmail: String?,password: String?) -> ValidationStatus {
        
        switch validateEmail(userEmail) {
        case .Failed(let msg):
            return .Failed(msg)
        default: break
        }
        
        switch validatePassword(password) {
        case .Failed(let msg):
            return .Failed(msg)
        default: return .Passed
        }
    }
    
    func validatePassword(password: String?) -> ValidationStatus {
        
        guard let password = password else {
            return .Failed("Password can't be empty")
        }
        
        if password.stringByReplacingOccurrencesOfString(" ", withString: "") == "" {
            
            return .Failed("Password can't be empty")
        }
        
        return .Passed
    }
    
    func validateEmail(userEmail: String?) -> ValidationStatus {
        
        guard let userEmail = userEmail else {
                return .Failed("Username can't be empty")
        }
        
        if userEmail.stringByReplacingOccurrencesOfString(" ", withString: "") == "" ||
            !userEmail.containsString("@") {
            return .Failed("Email is invalid")
        }
        return .Passed

    }
    
    func loginResident(email:String, password: String) throws {
        
            
        try loginManager.makeResidentStandardLogin(email, password: password, completion: {
            
            (inner:() throws -> BPUser) in
            
            do {
                try inner()
                self.loginDelegate?.didLogin(true,errorMsg: nil)
                
            } catch _ {
                self.loginDelegate?.didLogin(false,errorMsg:"Could not login")
            }
            
            
        })
        
    }
    
    
    func authenticateUserWithGoogleLogin(user: GIDGoogleUser!) throws {
        
        loginManager.authGoogle = user.authentication.accessToken
        try loginManager.authenticateGoogleUserOnBinnersServer() {
            
            (inner:() throws -> BPUser) in
            
            do {
                try inner()
                self.loginDelegate?.didLogin(true,errorMsg: nil)
                
            } catch let error as NSError {
                self.loginDelegate?.didLogin(false,errorMsg:error.localizedDescription)
            }
            
        }
        
    }
    
    func authenticateUserWithFacebook() {
        
         loginManager.authenticateUserOnFBAndBinnersServer() {
            
            (inner:() throws -> BPUser) in
            
            do {
                try inner()
                self.loginDelegate?.didLogin(true,errorMsg: nil)
                
            } catch _ {
                self.loginDelegate?.didLogin(false,errorMsg:"Could not login with google")
            }
            
        }
        
    }
    
    
    func authenticateUserWithTwitter() {
        
        loginManager.authenticateUserOnTwitterAndBinnersServer() {
            
            (inner:() throws -> BPUser) in
            
            do {
                try inner()
                self.loginDelegate?.didLogin(true,errorMsg: nil)
                
            } catch _ {
                self.loginDelegate?.didLogin(false,errorMsg:"Could not login with google")
            }
            
        }
        
    }
    
    func sendPasswordForgottenEmail(email: String) throws {
        
        try BPUser.recoverPassword(email) {
            
            inner in
            
            do {
                try inner()
                self.passwordForgotDelegate?.didSendEmail(true, errorMsg: nil)
            } catch let error as NSError {
                self.passwordForgotDelegate?.didSendEmail(false, errorMsg: error.localizedDescription)
            }
        }
        
    }

}

extension BPLoginViewModel : GIDSignInDelegate {
    
    @objc func signIn(signIn: GIDSignIn!,
                didSignInForUser user: GIDGoogleUser!,
                                 withError error: NSError!) {
        if error == nil {
            
            do {
                try self.authenticateUserWithGoogleLogin(user)
            } catch let error as NSError {
                self.loginDelegate?.didLogin(false,errorMsg:error.localizedDescription)
            }
        } else {
            self.loginDelegate?.didLogin(false,errorMsg:error.localizedDescription)
        }
        
    }

    
    
}
