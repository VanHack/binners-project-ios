//
//  BPUserDefaults.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 22/10/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import Foundation

class BPUserDefaults {
    
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
    
    class func addAddressToHistory(address:BPAddress) {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let codedAddressList = userDefaults.objectForKey("addressList") as? NSArray  {
            
            let codedAddressMutableList = NSMutableArray(array: codedAddressList)
            
            if let historyList =
                BPEncoder.convertNSArrayWithDataToSwiftArray(codedAddressList)
                    as? [BPAddress] {
                
                if !historyList.contains({ addressIt in return addressIt == address}) {
                    let encodedAddress = NSKeyedArchiver.archivedDataWithRootObject(address)
                    
                    if codedAddressMutableList.count >= 5 {
                        codedAddressMutableList.removeObjectAtIndex(codedAddressMutableList.count - 1)
                        codedAddressMutableList.insertObject(encodedAddress, atIndex: 0)
                    } else {
                        codedAddressMutableList.insertObject(encodedAddress, atIndex: 0)
                    }
                    
                    userDefaults.setObject(codedAddressMutableList, forKey: "addressList")
                }

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

    class func saveUser(user:BPUser) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(user.email, forKey: "email")
        userDefaults.setObject(user.address, forKey: "address")
        userDefaults.setObject(user.id, forKey: "id")
        userDefaults.setObject(user.token, forKey: "token")
        userDefaults.synchronize()
    }
    
    class func loadPickupAdressHistory() -> [BPAddress]? {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let addressListEncoded = userDefaults.objectForKey("addressList") as? NSArray {
            return BPEncoder.convertNSArrayWithDataToSwiftArray(addressListEncoded) as? [BPAddress]
        }
        return nil
    }
    
    
    
}