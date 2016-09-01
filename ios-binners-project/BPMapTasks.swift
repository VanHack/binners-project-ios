//
//  BPMapTasks.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 3/10/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.

import UIKit
import MapKit

class BPMapTasks: NSObject {
    
    let baseURLGeocode = "https://maps.googleapis.com/maps/api/geocode/json?"
    
    var resultsList: [BPAddress] = []
    
    override init() {
        super.init()
    }
    
    
    func geocodeAddress(
        address: String!,
        withCompletionHandler
        completionHandler: ((status: String, success: Bool) -> Void)) {
        
        resultsList.removeAll()
        
        if let lookupAddress = address {
            
            var geocodeURLString =
                baseURLGeocode +
                "address=" +
                lookupAddress + ",Vancouver&components=country:ca&latlng=49.246292,-123.116226"
            geocodeURLString =
                geocodeURLString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            
            let geocodeURL = NSURL(string: geocodeURLString)
            
            dispatch_async(dispatch_get_global_queue(
                DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    () -> Void in
                    
                let geocodingResultsData = NSData(contentsOfURL: geocodeURL!)
                
                do {
                    try self.parseGeocodeData(
                        geocodingResultsData!,
                        completionHandler: completionHandler)
                    
                } catch _ {
                    completionHandler(status: "Error", success: false)

                }
               
                
            })
        } else {
            completionHandler(status: "Not a valid address", success: false)
        }
    }
    
    
    func parseGeocodeData(
        data: NSData,
        completionHandler: ((status: String, success: Bool) -> Void)) throws {
        
        guard
            let dictionary =
            try NSJSONSerialization.JSONObjectWithData(
                data, options: NSJSONReadingOptions.MutableContainers)
                as? Dictionary<NSObject, AnyObject>,
            let status = dictionary["status"] as? String else {
                
                completionHandler(status:"Error getting data from maps", success: false)
                return
        }
        
        // Get the response status.
        
        if status == "OK" {
            
            guard let allResults = dictionary["results"]
                as? Array<Dictionary<NSObject, AnyObject>> else {
                    completionHandler(status:"Error getting data from maps", success: false)
                    return
            }
            
            for result in allResults {
                
                guard
                    let formattedAddress = result["formatted_address"] as? String,
                    let geometry = result["geometry"] as? Dictionary<NSObject, AnyObject>,
                    let coordinates = geometry["location"] as?
                        Dictionary<NSObject, AnyObject>,
                    let longitude = coordinates["lng"] as? Double,
                    let latitude = coordinates["lat"] as? Double else {
                        completionHandler(
                            status:"Error getting data from maps",
                            success: false)
                        return
                }
                
                let location = CLLocationCoordinate2DMake(latitude, longitude)
                let address = BPAddress()
                address.formattedAddress = formattedAddress
                address.location = location
                
                self.resultsList.append(address)
                
            }
            
        }
        dispatch_async(dispatch_get_main_queue(), {
            completionHandler(status: status, success: true)
            
        })

        
        
    }

}
