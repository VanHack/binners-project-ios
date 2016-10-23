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
        let userDefaults = UserDefaults.standard
        
        guard
            let email = userDefaults.string(forKey: "email"),
            let id = userDefaults.string(forKey: "id"),
            let token = userDefaults.string(forKey: "token") else {
                return nil
        }
        let address = userDefaults.string(forKey: "address")
        
        BPUser.sharedInstance.initialize(token,email: email, id: id, address: address)
        return BPUser.sharedInstance
    }
    
    class func addAddressToHistory(_ address:BPAddress) {
        
        let userDefaults = UserDefaults.standard
        
        if let codedAddressList = userDefaults.object(forKey: "addressList") as? NSArray  {
            
            let codedAddressMutableList = NSMutableArray(array: codedAddressList)
            
            if let historyList =
                BPEncoder.convertNSArrayWithDataToSwiftArray(codedAddressList)
                    as? [BPAddress] {
                
                if !historyList.contains(where: { addressIt in return addressIt == address}) {
                    let encodedAddress = NSKeyedArchiver.archivedData(withRootObject: address)
                    
                    if codedAddressMutableList.count >= 5 {
                        codedAddressMutableList.removeObject(at: codedAddressMutableList.count - 1)
                        codedAddressMutableList.insert(encodedAddress, at: 0)
                    } else {
                        codedAddressMutableList.insert(encodedAddress, at: 0)
                    }
                    
                    userDefaults.set(codedAddressMutableList, forKey: "addressList")
                }

            }
            
            
        } else {
            let addressList = NSArray(array: [NSKeyedArchiver.archivedData(withRootObject: address)])
            userDefaults.setValue(addressList, forKey: "addressList")
        }
    }
    
    class func clearUserInfoLocally() {
        let appDomain = Bundle.main.bundleIdentifier
        UserDefaults.standard.removePersistentDomain(forName: appDomain!)
        UserDefaults.standard.synchronize()
    }

    class func saveUser(_ user:BPUser) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(user.email, forKey: "email")
        userDefaults.set(user.address, forKey: "address")
        userDefaults.set(user.id, forKey: "id")
        userDefaults.set(user.token, forKey: "token")
        userDefaults.synchronize()
    }
    
    class func loadPickupAdressHistory() -> [BPAddress]? {
        
        let userDefaults = UserDefaults.standard
        
        if let addressListEncoded = userDefaults.object(forKey: "addressList") as? NSArray {
            return BPEncoder.convertNSArrayWithDataToSwiftArray(addressListEncoded) as? [BPAddress]
        }
        return nil
    }
    
    
    
}
