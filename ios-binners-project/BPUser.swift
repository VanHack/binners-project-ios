//
//  BPUser.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 2/19/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit

class BPUser : RLMObject {
    
    static let sharedInstance = BPUser()
    
    dynamic var email:String?
    dynamic var id:String?
    dynamic var address:String?
    
    init(email:String,id:String,address:String?)
    {
        super.init()
        self.email = email
        self.id = id
        self.address = address
    }
    
     override init() {
        super.init()
    }
    
//    func = (argument:BPUser) {
//    
//    self.id = arugment.id
//    }

    // if the user already exists in our persistent store, we can fetch his info and login without the need of entering information in the username or password field
    func getUserFromLocalPersistenceStorage() -> Bool
    {
        let user:BPUser? = BPUser.objectsWithPredicate(NSPredicate(format: "id == \(self.id)")).firstObject() as? BPUser
        
        if let user = user {
            
            self.id = user.id
            self.address = user.address
            self.email = user.email
            return true
            
        } else {
            return false
        }
        
    }
    
    
    func saveUserLocally() throws
    {
        let persistence = RLMRealm.defaultRealm()
        
        do {
            let user:BPUser? = BPUser.objectsWithPredicate(NSPredicate(format: "id == \(self.id)")).firstObject() as? BPUser
            
            if var user = user {
                
                persistence.beginWriteTransaction()
                user = self
                try persistence.commitWriteTransaction()
                
            } else {
                
                try persistence.transactionWithBlock({
                    _ in
                    persistence.addObject(self)
                    
                })
            }
            
            

        }catch _ {
            throw Error.DataBaseError(errorMsg: "Error saving to database")
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
    

}

