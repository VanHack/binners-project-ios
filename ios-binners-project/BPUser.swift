//
//  BPUser.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 2/19/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//
// swiftlint:disable trailing_whitespace
import UIKit
import MapKit

private var _userInstance: BPUser!

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
    
    class func setup(inner:()throws->AnyObject) throws -> BPUser {

        let value = try inner()
        let user = try mapToModel(value)
        BPUser.setup(user.token,address: user.address, userID: user.id, email: user.email)
        BPUser.sharedInstance().saveUser()
        return BPUser.sharedInstance()
    
    }
    
    class func setup(token:String,address:String?,userID:String,email:String) -> BPUser {
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
    
    class func recoverPassword(
        email: String,
        completion:(inner:() throws -> AnyObject) -> Void) throws {
        
        
        let finalUrl = BPURLBuilder.getPasswordResetURL(email)
        let manager = AFHTTPSessionManager()
        try BPServerRequestManager.sharedInstance.execute(
            .GET,
            urlString: finalUrl,
            manager: manager,
            param: nil,completion:completion)
    }
    
    class func revalidateAuthToken(
        token:String,
        completion:(inner:() throws -> AnyObject) -> Void) throws {
        
        
        let finalUrl = BPURLBuilder.getAuthTokenRevalidateURL()
        let manager = AFHTTPSessionManager()
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "Authorization")
        try BPServerRequestManager.sharedInstance.execute(
            .POST,
            urlString: finalUrl,
            manager: manager,
            param: nil,completion:completion)
    }
    
    class func registerResident(
        email:String,
        password:String,
        completion:(inner:() throws -> BPUser) -> Void) throws {
        
        let finalUrl = BPURLBuilder.getResidentUserRegistrationURL()
        let manager = AFHTTPSessionManager()
        let body = ["email":email, "password":password,"name":email]
        
        try BPServerRequestManager.sharedInstance.execute(
            .POST,
            urlString: finalUrl,
            manager: manager,
            param: body) {
            
            inner in
            
            do {
                let user = try BPUser.setup(inner)
                completion( inner: { return user })
                
            } catch {
                completion( inner: { throw Error.ErrorWithMsg(errorMsg: "Failed to initialize user") })
            }
            
        }

        
    }
    

}

extension BPUser : Mappable {
    
    
    internal static func mapToModel(object: AnyObject) throws -> BPUser {
        
        let token = try BPParser.parseTokenFromServerResponse(object)
        
        guard
        let user = object["user"],
        let email = user!["email"] as? String,
        let id = user!["_id"] as? String else {
            throw Error.ErrorWithMsg(errorMsg: "Invalid data format")
        }
            
        return BPUser(token: token,
                      email: email,
                      id: id,
                      address: nil)

    }
    
}

