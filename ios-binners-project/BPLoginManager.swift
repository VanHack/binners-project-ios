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
    
    
    func fetchFBInfo(completion:(value:AnyObject?,error:ErrorType?)->Void)
    {
        guard let auth = authFacebook else {
            
            completion(value: nil, error: Error.FacebookAuthMissing(errorMsg: "FB auth can't be nil"))
            return
            
        }
        
        let finalUrl = BPURLBuilder.buildFBUserLoginURL(auth)
        let manager = AFHTTPSessionManager()
        
        do
        {
            
            BPServerRequestManager.sharedInstance.execute(.GET, urlString: finalUrl, manager: manager, param: nil) {
                
                value,error in
                completion(value: value, error: error)
                
            }
            
            
        }
        
    }
    
    
}