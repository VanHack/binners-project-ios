//
//  BPAddress.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 3/14/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.

import UIKit
import MapKit


class BPAddress: NSObject, NSCoding {

    var formattedAddress: String!
    var location: CLLocationCoordinate2D!
    
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        
        guard
        let formattedAddress = decoder.decodeObject(forKey: "formattedAddress") as? String,
        let latitude = decoder.decodeObject(forKey: "latitude") as? Double,
        let longitude = decoder.decodeObject(forKey: "longitude") as? Double else {
            
            fatalError("Could not decode object")
        }

        
        self.formattedAddress = formattedAddress
        self.location = CLLocationCoordinate2DMake(latitude, longitude)

    }
    
    func encode(with coder: NSCoder) {
        coder.encode(formattedAddress, forKey: "formattedAddress")
        coder.encode(location.latitude, forKey: "latitude")
        coder.encode(location.longitude, forKey: "longitude")
    }

}
func == (lhs:BPAddress, rhs:BPAddress) -> Bool {
    
    return (lhs.location.latitude == rhs.location.latitude) &&
        (lhs.location.longitude == rhs.location.longitude)
    
}
