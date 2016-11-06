//
//  BPPickup.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 3/14/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.

import UIKit
import MapKit
import AFNetworking

typealias PickupSucessBlock = (([BPPickup]) -> Void)

final class BPPickup {

    var reedemable: BPReedemable!
    var date: Date!
    var instructions: String!
    var address: BPAddress!
    var id: String!
    var rating: BPRating?
    var binnerID: String?
    var status: PickupStatus = .onGoing
    
    init(id: String?,
         instructions: String,
         date: Date,
         reedemable: BPReedemable,
         address: BPAddress,
         status:PickupStatus ) {
        
        self.id = id
        self.instructions = instructions
        self.date = date
        self.reedemable = reedemable
        self.address = address
        self.status = status
    }
    
    init() {}
    
}

extension BPPickup : Mappable {
    
    static func mapToModel(withData object: AnyObject) -> BPPickup? {
        
        guard let addressJson = object["address"] as? [AnyHashable : Any] else {
            return nil
        }
        
        guard
        let id = object["_id"] as? String,
        let instructions = object["instructions"] as? String,
        let items = object["items"]! as? NSArray,
        let date = object["time"] as? String,
        let status = object["status"] as? String else {
                return nil
        }
        guard
        let quantityDic = items[0] as? NSDictionary,
        let quantity = quantityDic["quantity"] as? String else {
                return nil
        }
        guard
            let addressString = addressJson["street"] as? String else {
                return nil
        }
        
        guard let locationDic = addressJson["location"] as? [AnyHashable : Any] else {
            return nil
        }

        guard
            let coordinates = locationDic["coordinates"] as? [Double] else {
                return nil
        }
        
        guard let dateObject = Date.parseDateFromServer(date) else {
            return nil
        }
        
        let address = BPAddress()
        let reedemable = BPReedemable(quantity: quantity)
        address.formattedAddress = addressString
        address.location = CLLocationCoordinate2D(latitude: coordinates[0], longitude: coordinates[1])
        
        guard let pickupStatus = PickupStatus(rawValue: status) else {
            return nil
        }
        
        return BPPickup(id: id,
                        instructions: instructions,
                        date: dateObject,
                        reedemable: reedemable,
                        address: address,
                        status: pickupStatus)
        
    }

}

extension BPPickup : Wrappable {
    
     func mapToData() -> AnyObject {
        
        let items = [
            "quantity": reedemable.quantity
        ]
        
        let location = [
            "coordinates": [self.address.location.latitude, self.address.location.longitude]
        ]
        
        let address = [
            "street": self.address.formattedAddress,
            "location": location
        ] as [String : Any]
        
        let pickupDic: [String: Any] = [
            "requester": BPUser.sharedInstance.id,
            "address": address,
            "time": self.date,
            "instructions": self.instructions,
            "items": [items]
        ]
        return pickupDic as AnyObject
    }
}
