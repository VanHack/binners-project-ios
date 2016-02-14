//
//  BPLoginManager.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 1/29/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import Foundation
import TwitterKit


class BPLoginManager
{
    var authBinners:String?
    var authFacebook:String?
    var authGoogle:String?
    var authTwitter:String?
    var authSecretTwitter:String?
    
    static let sharedInstance = BPLoginManager()
    
    
    func authenticateFBUserOnBinnersServer(completion:(inner:() throws -> AnyObject) ->Void) throws {
        
        guard let auth = authFacebook else {
            
            throw Error.FacebookAuthMissing(errorMsg: "FB auth can't be nil")
        }
        
        let finalUrl = BPURLBuilder.buildFBUserLoginURL(auth)
        let manager = AFHTTPSessionManager()
        
            
        try BPServerRequestManager.sharedInstance.execute(.GET, urlString: finalUrl, manager: manager, param: nil,completion:completion)

        
    }
    
    func authenticateGoogleUserOnBinnersServer(completion:(inner:() throws -> AnyObject) ->Void) throws {
        
        guard let auth = authGoogle else {
            
            throw Error.GoogleAuthMissing(errorMsg: "Google auth can't be nil")
        }
        
        let finalUrl = BPURLBuilder.buildGoogleUserLoginURL(auth)
        let manager = AFHTTPSessionManager()
        
        
        try BPServerRequestManager.sharedInstance.execute(.GET, urlString: finalUrl, manager: manager, param: nil,completion:completion)
        
        
    }
    
    func authenticateTwitterUserOnBinnersServer(completion:(inner:() throws -> AnyObject) -> Void) throws {
        
        guard let auth = authTwitter else {
            throw Error.TwitterAuthMissing(errorMsg: "Twitter auth can't be nil")
        }
        
        guard let authSecret = authSecretTwitter else {
            throw Error.TwitterAuthMissing(errorMsg: "Twitter auth token secret can't be nil")
        }
        
        let finalUrl = BPURLBuilder.buildTwitterUserLoginURL(auth, accessSecret: authSecret)
        let manager = AFHTTPSessionManager()
        
        //TODO: Waiting for the API endpoint for twitter auth
        try BPServerRequestManager.sharedInstance.execute(.GET, urlString: finalUrl, manager: manager, param: nil, completion: completion)
        
        print("loggin out for test purposes")
        
        if let session = Twitter.sharedInstance().sessionStore.session() {
            Twitter.sharedInstance().sessionStore.logOutUserID(session.userID)
            print("logged out")
        }
    }

    func makeResidentStandardLogin(email:String,password:String,completion:(inner:() throws -> AnyObject) ->Void) throws {
        
        
        let finalUrl = BPURLBuilder.getStandardUserLoginURL()
        let manager = AFHTTPSessionManager()
        let param = ["email":email,"password":password]
        
        try BPServerRequestManager.sharedInstance.execute(.POST, urlString: finalUrl, manager: manager, param: param,completion:completion)
        
        
    }
    
    func registerResident(email:String,password:String,completion:(inner:() throws -> AnyObject) ->Void) throws {
        
        
        let finalUrl = BPURLBuilder.getResidentUserRegistrationURL()
        let manager = AFHTTPSessionManager()
        let param = ["email":email,"password":password]
        
        try BPServerRequestManager.sharedInstance.execute(.POST, urlString: finalUrl, manager: manager, param: param,completion:completion)
        
        
    }

    
    
}