//
//  BPLoginManager.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 1/29/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import Foundation


class BPLoginManager
{
    var authBinners:String?
    var authFacebook:String?
    var authGoogle:String?
    
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

    
    
    func makeResidentStandardLogin(email:String,password:String,completion:(inner:() throws -> AnyObject) ->Void) throws {
        
        
        let finalUrl = BPURLBuilder.getStandardUserLoginURL()
        let manager = AFHTTPSessionManager()
        let param = ["email":email,"password":password]
        
        try BPServerRequestManager.sharedInstance.execute(.POST, urlString: finalUrl, manager: manager, param: param,completion:completion)
        
        
    }

    
    
}