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
    
    class func loadUser() -> BPUser? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        guard
        let email = userDefaults.stringForKey("email"),
        let id = userDefaults.stringForKey("id"),
        let token = userDefaults.stringForKey("token") else {
                return nil
        }
        let address = userDefaults.stringForKey("address")
        return BPUser.setup(token,address: address, userID: id, email: email)
    }
    
    func saveUser() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(email, forKey: "email")
        userDefaults.setObject(address, forKey: "address")
        userDefaults.setObject(id, forKey: "id")
        userDefaults.setObject(token, forKey: "token")
        userDefaults.synchronize()
    }
    
    class func setup(object:AnyObject) -> BPUser? {
        
        guard let user = mapToModel(object) else {
            return nil
        }
        
        BPUser.setup(user.token, address: user.address, userID: user.id, email: user.email)
        BPUser.sharedInstance().saveUser()
        return BPUser.sharedInstance()
    
    }
    
    
    class func setup( token:String, address:String?, userID:String, email:String) -> BPUser {
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
    
    class func loadPickupAdressHistory() throws -> [BPAddress]? {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let addressListEncoded = userDefaults.objectForKey("addressList") as? NSArray {
            return try BPEncoder.convertNSArrayWithDataToSwiftArray(addressListEncoded) as? [BPAddress]
        }
        return nil
    }
    
    class func addAddressToHistory(address:BPAddress) throws {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()

        if let codedAddressList = userDefaults.objectForKey("addressList") as? NSArray  {
            
            let codedAddressMutableList = NSMutableArray(array: codedAddressList)
            
            guard let historyList =
                try BPEncoder.convertNSArrayWithDataToSwiftArray(codedAddressList)
                    as? [BPAddress] else {
                fatalError("could not convert array")
            }
            
            if !historyList.contains({addressIt in return addressIt == address}) {
                let encodedAddress = NSKeyedArchiver.archivedDataWithRootObject(address)
                
                if codedAddressMutableList.count >= 5 {
                    codedAddressMutableList.removeObjectAtIndex(codedAddressMutableList.count - 1)
                    codedAddressMutableList.insertObject(encodedAddress, atIndex: 0)
                } else {
                    codedAddressMutableList.insertObject(encodedAddress, atIndex: 0)
                }

                userDefaults.setObject(codedAddressMutableList, forKey: "addressList")
            }
            
        } else {
            let addressList = NSArray(array: [NSKeyedArchiver.archivedDataWithRootObject(address)])
            userDefaults.setValue(addressList, forKey: "addressList")
        }
    }

    class func clearUserInfoLocally() {
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        NSUserDefaults.standardUserDefaults().synchronize()
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

