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
    
    func wrapObject(object:AnyObject) throws {
        
        if let pickup = object as? BPPickup {
            
            body = try pickup.mapToData()
            header = BPUser.sharedInstance().token
            
        } else {
            throw Error.ErrorWithMsg(errorMsg: "Invalid object wrapping")
        }
    }

}
