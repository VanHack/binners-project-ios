//
//  BPUserService.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 05/11/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import Foundation
import AFNetworking

class BPUserService {
    
    class func recoverPassword(_ email: String,
                               onSuccess:@escaping OnSuccessBlock,
                               onFailure:OnFailureBlock?) {
        
        
        if let finalUrl = BPURLBuilder.getPasswordResetURL(email) {
            
            BPServerRequestManager.sharedInstance.execute(
                .get,
                url: finalUrl,
                manager: AFHTTPSessionManager(),
                param: nil,onSuccess:onSuccess,onFailure:onFailure)
            
        }
        
    }
    
    class func revalidateAuthToken( _ token:String,
                                    onSuccess:@escaping OnSuccessBlock,
                                    onFailure:OnFailureBlock?) {
        
        if let finalUrl = BPURLBuilder.revalidateTokenURL {
            
            let manager = AFHTTPSessionManager()
            manager.requestSerializer.setValue(token, forHTTPHeaderField: "Authorization")
            
            BPServerRequestManager.sharedInstance.execute(
                .post,
                url: finalUrl,
                manager: manager,
                param: nil,onSuccess:onSuccess,onFailure: onFailure)
            
        }
        
    }
    
    class func registerResident(
        _ email:String,
        password:String,
        onSucess:@escaping UserRegistrationSucessBlock,
        onFailure:OnFailureBlock?) {
        
        if let finalUrl = BPURLBuilder.residentUserRegistrationURL {
            
            let body = ["email": email, "password": password,"name": email] as AnyObject
            
            BPServerRequestManager.sharedInstance.execute(
                .post,
                url: finalUrl,
                manager: AFHTTPSessionManager(),
                param: body,
                onSuccess: { (object: AnyObject) in
                    
                    do {
                        try BPUser.sharedInstance.initialize(object)
                        onSucess(BPUser.sharedInstance)
                    } catch let error {
                        onFailure?(error as! BPError)
                    }
                    
            }, onFailure: onFailure)
            
        }
        
    }

    
    
}
