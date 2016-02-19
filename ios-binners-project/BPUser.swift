//
//  BPUser.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 2/19/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit

class BPUser{
    
    static let sharedInstance = BPUser()
    
    var email:String?
    var id:String?
    var address:String?
    
    private init(email:String,id:String)
    {
        self.email = email
        self.id = id
    }
    
    private init() {}

    // if the user already exists in our persistent store, we can fetch his info and login without the need of entering information in the username or password field
    func getUserInfoFromLocalPersistenceStorage() -> Bool
    {
        
        // MUST BE SWITCHED TO SOME OTHER WAY WITH ENCRYPTION IN THE FUTURE
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if (userDefaults.objectForKey("User") == nil)
        {
            return false
        }
        else
        {
            let info = userDefaults.objectForKey("User") as! [String:String]
            let email = info["email"]
            let id = info["id"]
            
            self.email = email
            self.id = id
            
            return true
        }
    }
    
    func saveUserInfoLocally(info:[String:String])
    {
        // MUST BE SWITCHED TO SOME OTHER WAY WITH ENCRYPTION IN THE FUTURE
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        let email = info["email"]
        let id = info["id"]
        self.email = email
        self.id = id

        userDefaults.setObject(info, forKey: "User")
        userDefaults.synchronize()
        
    }
    
    func clearUserInfoLocally()
    {
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        NSUserDefaults.standardUserDefaults().synchronize()
    }

}
