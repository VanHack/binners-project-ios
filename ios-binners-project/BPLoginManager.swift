//
//  BPLoginManager.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 1/29/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.

import Foundation
import TwitterKit
import AFNetworking
import FBSDKLoginKit
import FBSDKCoreKit
import FBSDKShareKit

typealias OnSucessUserBlock = (BPUser) -> Void

class BPLoginManager {
    var authBinners:String?
    var authGoogle:String?
    var authTwitter:String?
    var authSecretTwitter:String?
    let facebookPermissions = ["public_profile", "email"]
    
    static let sharedInstance = BPLoginManager()
    
    
    func authenticateFBUserOnBinnersServer(
        fbToken:String,
        onSuccess:OnSucessUserBlock,
        onFailure:OnFailureBlock?) {
        
        if let finalUrl = BPURLBuilder.buildFBUserLoginURL(fbToken) {
            
            BPServerRequestManager.sharedInstance.execute(
                .GET,
                url: finalUrl,
                manager: AFHTTPSessionManager(),
                param: nil,
                onSuccess: {
                    
                    object in
                    
                    if let user = BPUser.setup(object) {
                        onSuccess(user)
                    }
                    
                },onFailure: {
                    error in
                    onFailure?(error)
            })

        }
    }
    
    func authenticateUserOnFBAndBinnersServer(
        onSuccess:OnSucessUserBlock,onFailure:OnFailureBlock?) {
        
        let fbloginManager = FBSDKLoginManager()
        fbloginManager.logInWithReadPermissions(
            facebookPermissions,
            handler: {(result: FBSDKLoginManagerLoginResult!, error: NSError!) -> Void in
                
                if error != nil {
                    // Process error
                    self.removeFbData()
                } else if result.isCancelled {
                    self.removeFbData()
                } else {
                    //Success
                    if result.grantedPermissions.contains("email") &&
                        result.grantedPermissions.contains("public_profile") {

                        let fbToken = FBSDKAccessToken.currentAccessToken().tokenString
                        self.authenticateFBUserOnBinnersServer(fbToken,onSuccess: onSuccess,onFailure: onFailure)
                        
                    } else {
                        onFailure?(error)
                    }
                }
        })
        
    }
    
    func removeFbData() {
        //Remove FB Data
        let fbManager = FBSDKLoginManager()
        fbManager.logOut()
        FBSDKAccessToken.setCurrentAccessToken(nil)
    }
    
    func authenticateGoogleUserOnBinnersServer(
        onSuccess:OnSucessUserBlock,onFailure:OnFailureBlock?) throws {
        
        guard let auth = authGoogle else {
            throw Error.ErrorWithMsg(errorMsg: "Google auth can't be nil")
        }
        
        if let finalUrl = BPURLBuilder.buildGoogleUserLoginURL(auth) {
            
            BPServerRequestManager.sharedInstance.execute(
                .GET,
                url: finalUrl,
                manager: AFHTTPSessionManager(),
                param: nil,
                onSuccess: {
                    
                    object in
                    
                    if let user = BPUser.setup(object) {
                        onSuccess(user)
                    }
                    
                }, onFailure: {
                    _ in
                    onFailure?(Error.ErrorWithMsg(errorMsg: "Failed to initialize user"))
                    
            })

            
        }
    }
    
    func authenticateUserOnTwitterAndBinnersServer(onSuccess:OnSucessUserBlock,onFailure:OnFailureBlock?) {
        
        Twitter.sharedInstance().logInWithCompletion({
            session, error in
            if let unwrappedSession = session {
                
                self.authTwitter = unwrappedSession.authToken
                self.authSecretTwitter = unwrappedSession.authTokenSecret
                
                 do {
                    try self.authenticateTwitterUserOnBinnersServer(onSuccess,onFailure: onFailure)
                
                 } catch {
                    onFailure?(Error.ErrorWithMsg(errorMsg: "Failed to login on twitter"))
                }
            }
        })
        
        
    }
    
    func authenticateTwitterUserOnBinnersServer(onSuccess:OnSucessUserBlock,onFailure:OnFailureBlock?) throws {
        
        guard let auth = authTwitter else {
            throw Error.ErrorWithMsg(errorMsg: "Twitter auth can't be nil")
        }
        
        guard let authSecret = authSecretTwitter else {
            throw Error.ErrorWithMsg(errorMsg: "Twitter auth token secret can't be nil")
        }
        
        if let finalUrl = BPURLBuilder.buildTwitterUserLoginURL(auth, accessSecret: authSecret) {
            
            //TODO: Waiting for the API endpoint for twitter auth
            BPServerRequestManager.sharedInstance.execute(
                .GET,
                url: finalUrl,
                manager: AFHTTPSessionManager(),
                param: nil,
                onSuccess: {
                    
                    object in
                    
                    if let user = BPUser.setup(object) {
                        onSuccess(user)
                    }
                    
                }, onFailure: {
                    _ in
                    onFailure?(Error.ErrorWithMsg(errorMsg: "Failed to initialize user"))
                    
            })
            
            print("loggin out for test purposes")
            
            if let session = Twitter.sharedInstance().sessionStore.session() {
                Twitter.sharedInstance().sessionStore.logOutUserID(session.userID)
                print("logged out")
            }

        }
    }

    func makeResidentStandardLogin(
        email:String,
        password:String,
        onSuccess:OnSucessUserBlock,
        onFailure:OnFailureBlock?) {
        
        if let finalUrl = BPURLBuilder.standardLoginURL {
            
            let param = ["email":email,"password":password]
            
            BPServerRequestManager.sharedInstance.execute(
                .POST,
                url: finalUrl,
                manager: AFHTTPSessionManager(),
                param: param,
                onSuccess: {
                    
                    object in
                    
                    if let user = BPUser.setup(object) {
                        onSuccess(user)
                    }
                    
                }, onFailure: {
                    _ in
                    onFailure?(Error.ErrorWithMsg(errorMsg: "Failed to initialize user"))
                    
            })
            
        }

    }
    

}