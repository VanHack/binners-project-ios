//
//  BPUser.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 2/19/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.

import UIKit
import MapKit
import AFNetworking

private var _userInstance: BPUser!

typealias UserRegistrationSucessBlock = (BPUser) -> Void
typealias UserRegistrationFailureBlock = (ErrorType) -> Void

final class BPUser {
    
    var email:String!
    var id:String!
    var address:String!
    var token:String!
    private static var setupOnceToken: dispatch_once_t = 0
    
    init(token:String, email:String,id:String,address:String?)
    {
        self.token = token
        self.address = address
        self.email = email
        self.id = id
    }
    
    class func setup(object:AnyObject) -> BPUser? {
        
        guard let user = mapToModel(object) else {
            return nil
        }
        
        BPUser.setup(user.token, address: user.address, userID: user.id, email: user.email)
        BPUserDefaults.saveUser(BPUser.sharedInstance())
        return BPUser.sharedInstance()
    
    }
    
    
    class func setup(token:String, address:String?, userID:String, email:String) -> BPUser {
        dispatch_once(&setupOnceToken) {
            _userInstance = BPUser(token: token,email: email, id: userID, address: address)
        }
        return _userInstance
    }
    
    class func sharedInstance() -> BPUser {
        if _userInstance == nil {
            fatalError("User not initialized, call setup() first")
        }
        
        return _userInstance
    }
    
    class func recoverPassword(email: String,
                               onSuccess:OnSuccessBlock,
                               onFailure:OnFailureBlock?) throws {
        
        
        if let finalUrl = BPURLBuilder.getPasswordResetURL(email) {
            
            BPServerRequestManager.sharedInstance.execute(
                .GET,
                url: finalUrl,
                manager: AFHTTPSessionManager(),
                param: nil,onSuccess:onSuccess,onFailure:onFailure)

        }
        
    }
    
    class func revalidateAuthToken( token:String,
                                    onSuccess:OnSuccessBlock,
                                    onFailure:OnFailureBlock?) throws {
        
        if let finalUrl = BPURLBuilder.revalidateTokenURL {
            
            let manager = AFHTTPSessionManager()
            manager.requestSerializer.setValue(token, forHTTPHeaderField: "Authorization")
            
            BPServerRequestManager.sharedInstance.execute(
                .POST,
                url: finalUrl,
                manager: manager,
                param: nil,onSuccess:onSuccess,onFailure: onFailure)
            
        }
        
    }
    
    class func registerResident(
        email:String,
        password:String,
        onSucess:UserRegistrationSucessBlock,
        onFailure:UserRegistrationFailureBlock?) throws {
        
        if let finalUrl = BPURLBuilder.residentUserRegistrationURL {
            
            let body = ["email":email, "password":password,"name":email]
            
            BPServerRequestManager.sharedInstance.execute(
                .POST,
                url: finalUrl,
                manager: AFHTTPSessionManager(),
                param: body,
                onSuccess: {
                    object in
                    
                    if let user = BPUser.setup(object) {
                        onSucess(user)
                    } else {
                        onFailure?(ErrorUser.ErrorCreatingUser)
                    }
                    
                }, onFailure: onFailure)
            
        }
        
    }
    

}

extension BPUser : Mappable {
    
    internal static func mapToModel(object: AnyObject) -> BPUser? {
        
        do {
            let token = try BPParser.parseTokenFromServerResponse(object)
            
            guard
                let user = object["user"],
                let email = user!["email"] as? String,
                let id = user!["_id"] as? String else {
                    return nil
            }
            
            return BPUser(token: token,
                          email: email,
                          id: id,
                          address: nil)
            
        } catch _ {
            return nil
        }

    }
    
}

