//
//  BPMapTasks.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 3/10/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit
import MapKit

class BPMapTasks: NSObject {
    
    let baseURLGeocode = "https://maps.googleapis.com/maps/api/geocode/json?"
    
    var resultsList:[BPLocation] = []
    
    override init() {
        super.init()
    }
    
    
    func geocodeAddress(address: String!, withCompletionHandler completionHandler: ((status: String, success: Bool) -> Void)) {
        
        resultsList.removeAll()
        
        if let lookupAddress = address {
            
            var geocodeURLString = baseURLGeocode + "address=" + lookupAddress + ",Vancouver&components=country:ca&latlng=49.246292,-123.116226"
            geocodeURLString = geocodeURLString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            
            let geocodeURL = NSURL(string: geocodeURLString)
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                let geocodingResultsData = NSData(contentsOfURL: geocodeURL!)
                
                do {
                    let dictionary: Dictionary<NSObject, AnyObject> = try NSJSONSerialization.JSONObjectWithData(geocodingResultsData!, options: NSJSONReadingOptions.MutableContainers) as! Dictionary<NSObject, AnyObject>
                    
                    // Get the response status.
                    let status = dictionary["status"] as! String
                    
                    if status == "OK" {
                        let allResults = dictionary["results"] as! Array<Dictionary<NSObject, AnyObject>>
                        
                        for result in allResults {
                            
                            // Keep the most important values.
                            let address = result["formatted_address"] as! String
                            let geometry = result["geometry"] as! Dictionary<NSObject, AnyObject>
                            let longitude = ((geometry["location"] as! Dictionary<NSObject, AnyObject>)["lng"] as! NSNumber).doubleValue
                            let latitude = ((geometry["location"] as! Dictionary<NSObject, AnyObject>)["lat"] as! NSNumber).doubleValue
                            
                            let location = BPLocation(name: "", address: address, longitude: longitude, latitude: latitude)
                            
                            self.resultsList.append(location)

                        }
                        dispatch_async(dispatch_get_main_queue(), {
                            completionHandler(status: status, success: true)

                            })
                        
                    }
                    else {
                        dispatch_async(dispatch_get_main_queue(), {
                            completionHandler(status: status, success: true)
                            
                            })
                    } 


                }catch let error {
                    completionHandler(status: "error", success: false)

                }
               
                
            })
        } else {
            completionHandler(status: "Not a valid address", success: false)
        }
    }

}
