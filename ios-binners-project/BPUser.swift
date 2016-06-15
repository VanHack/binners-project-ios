//
//  BPUser.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 2/19/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit
import MapKit

private var _userInstance: BPUser!

class BPUser {
    
    var email:String!
    var id:String!
    var address:String!
    var token:String!
    private static var setupOnceToken: dispatch_once_t = 0
    
    init(token:String,email:String,id:String,address:String?)
    {
        self.token = token
        self.address = address
        self.email = email
        self.id = id
    }
    
    class func setupFromFunc(inner:()throws->AnyObject) throws {

        let value = try inner()
        let user = try BPParser.parseUserFrom(value)
        BPUser.setup(user.token, address: user.address, userID: user.id, email: user.email)
    
    }
    
    class func setup(token:String,address:String?,userID:String,email:String) -> BPUser {
        dispatch_once(&setupOnceToken) {
            _userInstance = BPUser(token: token, email: email, id: userID, address: address)
        }
        return _userInstance
    }
    
    class func sharedInstance() throws -> BPUser {
        if _userInstance == nil {
            throw Error.UserNotInitializedError(msg:"User not initialized, call setup() first")
        }
        
        return _userInstance
    }
    
    func loadPickupAdressHistory() -> [BPAddress]? {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let addressListEncoded = userDefaults.objectForKey("addressList") as? NSArray {
            return BPEncoder.convertNSArrayWithDataToSwiftArray(addressListEncoded) as? [BPAddress]
        }
        return nil
    }
    
    func addAddressToHistory(address:BPAddress) {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()

        if let codedAddressList = userDefaults.objectForKey("addressList") as? NSArray  {
            
            let codedAddressMutableList = NSMutableArray(array: codedAddressList)
            
            let historyList = BPEncoder.convertNSArrayWithDataToSwiftArray(codedAddressList) as! [BPAddress]
            
            if !historyList.contains({addressIt in return addressIt == address}) {
                let encodedAddress = NSKeyedArchiver.archivedDataWithRootObject(address)
                
                if codedAddressMutableList.count >= 5 {
                    codedAddressMutableList.removeObjectAtIndex(codedAddressMutableList.count - 1)
                    codedAddressMutableList.insertObject(encodedAddress, atIndex: 0)
                }else {
                    codedAddressMutableList.insertObject(encodedAddress, atIndex: 0)
                }

                userDefaults.setObject(codedAddressMutableList, forKey: "addressList")
            }
            
        } else {
            let addressList = NSArray(array: [NSKeyedArchiver.archivedDataWithRootObject(address)])
            userDefaults.setValue(addressList, forKey: "addressList")
        }
    }

    class func getUserAuthToken() -> String? {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        return userDefaults.stringForKey("token")
        
    }
    
    func saveAuthToken() {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if self.token != nil {
            userDefaults.setObject(self.token, forKey: "token")
            userDefaults.synchronize()
        }
        
    }

    
    func getPickUpHistoryLocations() -> [String] {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if (userDefaults.objectForKey("PickupAdressesHistory") == nil)
        {
            return []
        }
        else
        {
            let history = userDefaults.objectForKey("PickupAdressesHistory") as! [String]

            return history
        }

    }
    
    func savePickUpLocationInHistory(location:String) {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        var history = getPickUpHistoryLocations()
        
        history.append(location)
        
        userDefaults.setObject(history, forKey: "PickupAdressesHistory")
        userDefaults.synchronize()

    }
    
    func clearUserInfoLocally() throws
    {
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        NSUserDefaults.standardUserDefaults().synchronize()
        let persistence = RLMRealm.defaultRealm()
        
        persistence.beginWriteTransaction()
        persistence.deleteAllObjects()
        
        do {
            try persistence.commitWriteTransaction()

        }catch _ {
            throw Error.DataBaseError(errorMsg: "Error saving to database")
        }
        
    }
    
    func fetchOnGoingPickups(completion:(inner:()throws->[BPPickup])->Void)throws {
        
        guard token != nil else {
            throw Error.InvalidAuthToken(msg: "Invalid user token")

        }
        
        let url = BPURLBuilder.getGetPickupsURL()
        let manager = AFHTTPSessionManager()
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "Authorization")

        try BPServerRequestManager.sharedInstance.execute(.GET, urlString: url, manager: manager, param: nil, completion: {
        pickupsFunc in
            
            completion( inner: {
            
                let pickupsListDictionary = try pickupsFunc() as! [[String:AnyObject]]
                print(pickupsListDictionary)
                
                let pickups = try pickupsListDictionary.map({ dictionary -> BPPickup in return try BPParser.parsePickupFrom(dictionary) })
                
            return pickups
            })
        
            
        })
        
        
    }
    
    func postPickupInBackgroundWithBock(pickup:BPPickup,completion:(inner:()throws->AnyObject)->Void)throws {
        
        let wrapper = BPObjectWrapper()
        try wrapper.wrapObject(pickup)
        
        let url = BPURLBuilder.getPostPickupURL()
        let manager = AFHTTPSessionManager()
        
        assert(wrapper.header != nil)
        
        manager.requestSerializer.setValue(wrapper.header!, forHTTPHeaderField: "Authorization")
        
        try BPServerRequestManager.sharedInstance.execute(.POST, urlString: url, manager: manager, param: wrapper.body, completion: completion)
        
        
    }
    
    

}

