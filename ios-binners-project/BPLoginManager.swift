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
        _ fbToken:String,
        onSuccess:@escaping OnSucessUserBlock,
        onFailure:OnFailureBlock?) {
        
        if let finalUrl = URL(binnersPath: .facebook(accessToken: fbToken)) {
            
            BPServerRequestManager.sharedInstance.execute(
                .get,
                url: finalUrl,
                manager: AFHTTPSessionManager(),
                param: nil,
                onSuccess: {
                    
                    object in
                    
                    do {
                        try BPUser.sharedInstance.initialize(object)
                        onSuccess(BPUser.sharedInstance)
                    } catch let error {
                        onFailure?(error as! BPError)
                    }
                    
                },onFailure: onFailure)

        }
    }
    
    func authenticateUserOnFBAndBinnersServer(
        _ onSuccess: @escaping OnSucessUserBlock, onFailure: OnFailureBlock?) {
        
        let fbloginManager = FBSDKLoginManager()
        
        fbloginManager.logIn(
            withReadPermissions: facebookPermissions,
            handler: { (result: FBSDKLoginManagerLoginResult?, error: Error?) -> Void in
                
                if error != nil {
                    // Process error
                    self.removeFbData()
                     onFailure?(BPError.serverError(error!))
                } else if result!.isCancelled {
                    self.removeFbData()
                } else {
                    //Success
                    if result!.grantedPermissions.contains("email") &&
                        result!.grantedPermissions.contains("public_profile") {

                        if let fbToken = FBSDKAccessToken.current().tokenString {
                            self.authenticateFBUserOnBinnersServer(fbToken,onSuccess: onSuccess,onFailure: onFailure)
                        }
                        
                    } else {
                        onFailure?(BPError.fbPublicProfileNotProvided)
                    }
                }
        })
        
    }
    
    func removeFbData() {
        let fbManager = FBSDKLoginManager()
        fbManager.logOut()
        FBSDKAccessToken.setCurrent(nil)
    }
    
    func authenticateGoogleUserOnBinnersServer(
        _ onSuccess:@escaping OnSucessUserBlock,onFailure:OnFailureBlock?) throws {
        
        guard let auth = authGoogle else {
            throw BPError.googleAuthMissing
        }
        
        if let finalUrl = URL(binnersPath: .google(accessToken: auth)) {
            
            BPServerRequestManager.sharedInstance.execute(
                .get,
                url: finalUrl,
                manager: AFHTTPSessionManager(),
                param: nil,
                onSuccess: {
                    
                    object in
                    
                    do {
                        try BPUser.sharedInstance.initialize(object)
                        onSuccess(BPUser.sharedInstance)
                    } catch let error {
                        onFailure?(error as! BPError)
                    }
                    
                }, onFailure: onFailure)

        }
    }
    
    func authenticateUserOnTwitterAndBinnersServer(_ onSuccess:@escaping OnSucessUserBlock,onFailure:OnFailureBlock?) {
        
        Twitter.sharedInstance().logIn(completion: {
            session, error in
            if let unwrappedSession = session {
                
                self.authTwitter = unwrappedSession.authToken
                self.authSecretTwitter = unwrappedSession.authTokenSecret
                
                 do {
                    try self.authenticateTwitterUserOnBinnersServer(onSuccess,onFailure: onFailure)
                
                 } catch {
                    onFailure?(BPError.twitterAuthMissing)
                }
            }
        })
        
        
    }
    
    func authenticateTwitterUserOnBinnersServer(_ onSuccess:@escaping OnSucessUserBlock,onFailure:OnFailureBlock?) throws {
        
        guard let auth = authTwitter else {
            throw BPError.twitterAuthMissing
        }
        
        guard let authSecret = authSecretTwitter else {
            throw BPError.twitterAuthMissing
        }
        
        if let finalUrl = URL(binnersPath: .twitter(accessToken: auth, accessSecret: authSecret)) {
            
            //TODO: Waiting for the API endpoint for twitter auth
            BPServerRequestManager.sharedInstance.execute(
                .get,
                url: finalUrl,
                manager: AFHTTPSessionManager(),
                param: nil,
                onSuccess: {
                    
                    object in
                    
                    do {
                        try BPUser.sharedInstance.initialize(object)
                        onSuccess(BPUser.sharedInstance)
                    } catch let error {
                        onFailure?(error as! BPError)
                    }
                    
                }, onFailure: onFailure)
            
            print("loggin out for test purposes")
            
            if let session = Twitter.sharedInstance().sessionStore.session() {
                Twitter.sharedInstance().sessionStore.logOutUserID(session.userID)
                print("logged out")
            }

        }
    }

    func makeResidentStandardLogin(
        _ email:String,
        password:String,
        onSuccess:@escaping OnSucessUserBlock,
        onFailure:OnFailureBlock?) {
        
        if let finalUrl = URL(binnersPath: .standardLogin) {
            
            let param = ["email":email,"password":password] as AnyObject
            
            BPServerRequestManager.sharedInstance.execute(
                .post,
                url: finalUrl,
                manager: AFHTTPSessionManager(),
                param: param,
                onSuccess: {
                    
                    object in
                    
                    do {
                        try BPUser.sharedInstance.initialize(object)
                        onSuccess(BPUser.sharedInstance)
                    } catch let error {
                        onFailure?(error as! BPError)
                    }
                    
                }, onFailure: {
                    error in
                    onFailure?(error)
                    
            })
            
        }

    }
    

}
