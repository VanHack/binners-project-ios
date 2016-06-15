//
//  BPServerResponseParser.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 3/28/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit
import MapKit


class BPParser {
    
    class func parseTokenFromServerResponse(object:AnyObject) throws -> String {
        
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
    
    class func parseDateFromServer(dateString:String) throws -> NSDate {
        
        let dateFor: NSDateFormatter = NSDateFormatter()
        dateFor.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.'000Z'"
        
        guard let date = dateFor.dateFromString(dateString) else {
            throw Error.InvalidDateFormat(msg:"Invalid date format")
        }
        
       return date

    }
    
    class func parsePickupFrom(object:AnyObject) throws ->BPPickup {
        
        let pickup = BPPickup()
        let address = BPAddress()
        
        pickup.address = address
        
        pickup.id = object["_id"] as! String
        pickup.instructions = object["instructions"] as! String
        
        pickup.date = try parseDateFromServer(object["time"] as! String)
        
        let items = object["items"] as AnyObject
        let quantityDic = items[0] as AnyObject
        let quantity = quantityDic["quantity"] as! String
        let reedemable = BPReedemable(quantity: quantity)
        pickup.reedemable = reedemable
        
        address.formattedAddress = ((object["address"] as AnyObject) ["street"] as! String)
        
        let addressDic = object["address"] as AnyObject
        let locationDic = addressDic["location"] as AnyObject
        let coordinates = locationDic["coordinates"] as! [Double]
        
        address.location = CLLocationCoordinate2D(latitude: coordinates[0], longitude: coordinates[1])
        
        return pickup

    }
    
}
