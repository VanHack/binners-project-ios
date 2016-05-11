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
            
            body = wrapPickupToHeader(pickup)
            header = BPUser.sharedInstance.getUserAuthToken()
            
        } else {
            throw Error.InvalidObjectWrapper(errorMsg: "Invalid object wrapping")
        }
    }
    
    
    private func wrapPickupToHeader(pickup:BPPickup) -> AnyObject {
        
        let items = [
            "quantity": String(pickup.reedemable.quantity)
        ]
        
        let location = [
            "coordinates": [pickup.address.location.latitude,pickup.address.location.longitude]
        ]
        
        let address = [
            "street": pickup.address.formattedAddress,
            "location": location
        ]
        
        let pickupDic = [
            "requester": BPUser.sharedInstance.id!,
            "address": address,
            "time": pickup.date,
            "instructions": pickup.instructions,
            "items": [items]
        ]

        return pickupDic
        
    }

}
