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

class BPUser : RLMObject {
    
    dynamic var email:String!
    dynamic var id:String!
    dynamic var address:String!
    dynamic var token:String!
    private static var setupOnceToken: dispatch_once_t = 0
    
    init(token:String,email:String,id:String,address:String?)
    {
        super.init()
        self.token = token
        self.address = address
        self.email = email
        self.id = id
    }
    
     override init() {
        super.init()
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


    func getUserFromLocalPersistenceStorage() -> BPUser?
    {
        return BPUser.allObjects().firstObject() as? BPUser
        
    }
    
    
    func saveUserLocally() throws
    {
        let persistence = RLMRealm.defaultRealm()
        
        do {
            let user:BPUser? = BPUser.objectsWithPredicate(NSPredicate(format: "id = \(self.id!)")).firstObject() as? BPUser
            
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
    
    class func getUserAuthToken() -> String? {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        return userDefaults.stringForKey("token")
        
    }
    
    func saveAuthToken() {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.setObject(self.token, forKey: "token")
        userDefaults.synchronize()

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
    
    func fetchOnGoingPickups(completion:(pickups:[BPPickup]?,error:ErrorType?)->Void) {
        
        var pickups = [BPPickup]()
        
        let pickup = BPPickup()
        pickup.address = BPAddress()
        pickup.date = NSDate()
        pickup.instructions = "Don't do anything"
        pickup.address.location = CLLocationCoordinate2D(latitude: 49.2827, longitude: -123.1207)
        
        for _ in 0...5{
            
            pickups.append(pickup)
        }
        
        completion(pickups: pickups,error: nil)
        
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

