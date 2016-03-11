//
//  BPLocation.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 3/11/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit
import MapKit

class BPLocation: NSObject {
    
    var name:String
    var address:String
    var longitude:CLLocationDegrees
    var latitude:CLLocationDegrees
    
    
    init(name:String,address:String,longitude:CLLocationDegrees,latitude:CLLocationDegrees) {
        
        self.name = name
        self.address = address
        self.longitude = longitude
        self.latitude = latitude
        
    }

}
