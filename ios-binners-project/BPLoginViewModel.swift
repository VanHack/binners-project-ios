//
//  LoginViewModel.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 7/8/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit

protocol LoginDelegate {
    
    func didLogin(_ success:Bool, errorMsg:String?)
}
protocol ForgotPasswordDelegate {
    
    func didSendEmail(_ success:Bool, errorMsg:String?)
}


class BPLoginViewModel : NSObject {
    
    var loginManager = BPLoginManager.sharedInstance
    var loginDelegate:LoginDelegate?
    var passwordForgotDelegate:ForgotPasswordDelegate?
    
    enum ValidationStatus {
        case passed
        case failed(String)
    }
    
    override init() {
        super.init()
        GIDSignIn.sharedInstance().delegate = self
    }
    
    
    func validate(_ userEmail: String?,password: String?) -> ValidationStatus {
        
        switch validateEmail(userEmail) {
        case .failed(let msg):
            return .failed(msg)
        default: break
        }
        
        switch validatePassword(password) {
        case .failed(let msg):
            return .failed(msg)
        default: return .passed
        }
    }
    
    func validatePassword(_ password: String?) -> ValidationStatus {
        
        guard let password = password else {
            return .failed("Password can't be empty")
        }
        
        if password.replacingOccurrences(of: " ", with: "") == "" {
            
            return .failed("Password can't be empty")
        }
        
        return .passed
    }
    
    func validateEmail(_ userEmail: String?) -> ValidationStatus {
        
        guard let userEmail = userEmail else {
                return .failed("Username can't be empty")
        }
        
        if userEmail.replacingOccurrences(of: " ", with: "") == "" ||
            !userEmail.contains("@") {
            return .failed("Email is invalid")
        }
        return .passed

    }
    
    func loginResident(_ email:String, password: String) {
        
            
        loginManager.makeResidentStandardLogin(
            email,
            password: password,
            onSuccess: {
            
            user in
                self.loginDelegate?.didLogin(true,errorMsg: nil)
                
            },onFailure: {
        
            error in
                self.loginDelegate?.didLogin(false,errorMsg:"Could not login")
        
            })
        
    }
    
    
    func authenticateUserWithGoogleLogin(_ user: GIDGoogleUser!) throws {
        
        loginManager.authGoogle = user.authentication.accessToken
        try loginManager.authenticateGoogleUserOnBinnersServer(
            {
            user in
                self.loginDelegate?.didLogin(true,errorMsg: nil)
        
        },onFailure: {
            (error: BPError) in
                self.loginDelegate?.didLogin(false, errorMsg: error.errorMsg())
        
        })
    }
    
    func authenticateUserWithFacebook() {
        
        loginManager.authenticateUserOnFBAndBinnersServer(
            {
            user in
            self.loginDelegate?.didLogin(true,errorMsg: nil)
        
        
        },onFailure: {
            error in
            self.loginDelegate?.didLogin(false,errorMsg:"Could not login with facebook")
        })
        
    }
    
    
    func authenticateUserWithTwitter() {
        
        loginManager.authenticateUserOnTwitterAndBinnersServer({
            user in
            self.loginDelegate?.didLogin(true,errorMsg: nil)
        
        },onFailure: {
            error in
            self.loginDelegate?.didLogin(false,errorMsg:"Could not login with google")
        
        })
        
    }
    
    func sendPasswordForgottenEmail(_ email: String) {
        
        BPUser.recoverPassword(
            email,
            onSuccess:{
                object in
                    self.passwordForgotDelegate?.didSendEmail(true, errorMsg: nil)
            },onFailure:{
                (error: BPError) in
                
                self.loginDelegate?.didLogin(false, errorMsg: error.errorMsg())
                
            })
        
    }

}

extension BPLoginViewModel : GIDSignInDelegate {
    
    @objc func sign(_ signIn: GIDSignIn!,
                didSignInFor user: GIDGoogleUser!,
                                 withError error: Error!) {
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
