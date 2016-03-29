//
//  BPServerResponseParser.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 3/28/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit

class BPServerResponseParser {
    
    class func processResponse(object:AnyObject) throws -> AnyObject? {
        
        if object["user"] != nil {
            
            return processUserResponse(object["user"])
            
        }
        else {
            throw Error.InvalidErrorType(erroMSg: "Invalid data format")
        }
        
    }
    
    class func parseTokenFromServerResponse(object:AnyObject) throws ->String {
        
        if object["token"] != nil {
            return object["token"] as! String
        } else {
            throw Error.InvalidErrorType(erroMSg: "Invalid data format")

        }
    }
    
    class func processUserResponse(object:AnyObject) -> BPUser {
        
        let user = BPUser(email: object["email"] as! String,
                          id: object["_id"] as! String,
                          address:object["addresses"] as? String)
        
        return user
    }
}
