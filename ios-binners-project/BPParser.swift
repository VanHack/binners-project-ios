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
    
    func mapToData() throws -> AnyObject
}
protocol Mappable {
    
    static func mapToModel(object:AnyObject) throws -> Self?
}

struct BPParser {
    
    static func parseTokenFromServerResponse(object:AnyObject) throws -> String {
        
        guard let token = object["token"] as? String else {
            throw ErrorServer.CouldNotGetToken
        }
        return token
    }
    
    static func parseDateFromServer(dateString:String) -> NSDate? {
        
        let dateFor: NSDateFormatter = NSDateFormatter()
        dateFor.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.'000Z'"
        
        guard let date = dateFor.dateFromString(dateString) else {
            return nil
        }
        
       return date

    }
    
}
