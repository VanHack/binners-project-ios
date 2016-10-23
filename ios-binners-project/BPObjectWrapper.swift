//
//  BPObjectWrapper.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 5/11/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit

class BPObjectWrapper {
    
    var header:String?
    var body:AnyObject?
    
    func wrapObject(_ object:AnyObject) {
        
        if let pickup = object as? BPPickup {
            
            body = pickup.mapToData()
            header = BPUser.sharedInstance.token
        }
    }
}
