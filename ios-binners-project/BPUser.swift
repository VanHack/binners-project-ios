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

final class BPUser {
    
    var email:String!
    var id:String!
    var address:String!
    var token:String!
    static let sharedInstance = BPUser()
    
    init() {}
    
    func initialize(_ token: String, email: String, id: String, address: String?)
    {
        self.token = token
        self.address = address
        self.email = email
        self.id = id
    }
    
    func initialize(_ object:AnyObject) throws {
        
        guard let _ = BPUser.mapToModel(withData: object) else {
           throw BPError.userError
        }
    }
    
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
            
            let body = ["email":email, "password":password,"name":email] as AnyObject
            
            BPServerRequestManager.sharedInstance.execute(
                .post,
                url: finalUrl,
                manager: AFHTTPSessionManager(),
                param: body,
                onSuccess: { (object: AnyObject) in
                    
                    do {
                        try BPUser.sharedInstance.initialize(object)
                        onSucess(BPUser.sharedInstance)
                        BPUserDefaults.saveUser(BPUser.sharedInstance)
                    } catch let error {
                        onFailure?(error as! BPError)
                    }
                    
                }, onFailure: onFailure)
            
        }
        
    }
    

}

extension BPUser : Mappable {
    
    static func mapToModel(withData object: AnyObject) -> BPUser? {
        
        guard let userJson = object["user"] as? [AnyHashable: Any],
            let token = object["token"] as? String else  {
                return nil
        }
        guard
            let email = userJson["email"] as? String,
            let id = userJson["_id"] as? String else {
                return nil
        }
        
        let user = BPUser.sharedInstance
        user.initialize(token, email: email, id: id, address: nil)
        return user
        }
    
}

