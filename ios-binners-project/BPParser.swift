//
//  BPServerResponseParser.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 3/28/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit
import MapKit

protocol Wrappable {
    
    func mapToData() -> AnyObject
}
protocol Mappable {
    
    static func mapToModel(withData object:AnyObject) -> Self?
}
