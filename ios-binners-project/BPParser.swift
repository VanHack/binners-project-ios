//
//  BPServerResponseParser.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 3/28/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit



class BPParser {
    
    class func parseTokenFromServerResponse(object:AnyObject) throws ->String {
        
        if object["token"] != nil {
            return object["token"] as! String
        } else {
            throw Error.InvalidDataFormat(errorMsg: "Invalid data format")

        }
    }
    
    class func parseUserFrom(object:AnyObject) throws -> BPUser {
        
        let token = try parseTokenFromServerResponse(object)
        
        if let user = object["user"] {
            
            return BPUser(token: token,
                          email: user!["email"] as! String,
                          id: user!["_id"] as! String,
                          address: nil)

        } else {
            throw Error.InvalidDataFormat(errorMsg: "Invalid data format")
        }
        
        
    }
    
}
