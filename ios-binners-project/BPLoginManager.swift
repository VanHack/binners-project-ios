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
    
    static let sharedInstance = BPLoginManager()
    
    
    func fetchFBInfo(completion:(inner:() throws -> AnyObject) ->Void) throws {
        
        guard let auth = authFacebook else {
            
            throw Error.FacebookAuthMissing(errorMsg: "FB auth can't be nil")
        }
        
        let finalUrl = BPURLBuilder.buildFBUserLoginURL(auth)
        let manager = AFHTTPSessionManager()
        
            
        try BPServerRequestManager.sharedInstance.execute(.GET, urlString: finalUrl, manager: manager, param: nil,completion:completion)

        
    }
    
    
}