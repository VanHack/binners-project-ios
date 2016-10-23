//
//  BPMapTasks.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 3/10/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.

import UIKit
import MapKit

class BPMapTasks {
    
    let baseURLGeocode = "https://maps.googleapis.com/maps/api/geocode/json?"
    
    var resultsList: [BPAddress] = []
    
    func geocodeAddress(
        _ address: String!,
        withCompletionHandler
        completionHandler: @escaping ((_ status: String, _ success: Bool) -> Void)) {
        
        resultsList.removeAll()
        
        if let lookupAddress = address {
            
            var geocodeURLString =
                baseURLGeocode +
                "address=" +
                lookupAddress + ",Vancouver&components=country:ca&latlng=49.246292,-123.116226"
            geocodeURLString =
                geocodeURLString.addingPercentEscapes(using: String.Encoding.utf8)!
            
            let geocodeURL = URL(string: geocodeURLString)
            let geocodingResultsData = try? Data(contentsOf: geocodeURL!)
            
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async(execute: { () -> Void in
                
                do {
                    try self.parseGeocodeData(
                        geocodingResultsData!,
                        completionHandler: completionHandler)
                    
                } catch _ {
                    completionHandler("Error", false)
                }
               
                
            })
        } else {
            completionHandler("Not a valid address", false)
        }
    }
    
    
    func parseGeocodeData( _ data: Data,
                           completionHandler: @escaping ((_ status: String, _ success: Bool) -> Void)) throws {
        
        let dictionary = try JSONSerialization.jsonObject(
            with: data,
            options: JSONSerialization.ReadingOptions.mutableContainers)
            as AnyObject
        
        if let status = dictionary["status"] as? String {
            
            if status == "OK" {
                
                if let allResults = dictionary["results"]
                    as? Array<Dictionary<String, AnyObject>> {
                    
                    for result in allResults {
                        
                        guard
                            let formattedAddress = result["formatted_address"] as? String,
                            let geometry = result["geometry"] as? Dictionary<String, AnyObject>,
                            let coordinates = geometry["location"] as?
                                Dictionary<String, AnyObject>,
                            let longitude = coordinates["lng"] as? Double,
                            let latitude = coordinates["lat"] as? Double else {
                                completionHandler(
                                    "Error getting data from maps",
                                    false)
                                return
                        }
                        
                        let location = CLLocationCoordinate2DMake(latitude, longitude)
                        let address = BPAddress()
                        address.formattedAddress = formattedAddress
                        address.location = location
                        
                        self.resultsList.append(address)
                        
                    }
                    
                }
                DispatchQueue.main.async(execute: {
                    completionHandler(status, true)
                })
            }
            else {
                DispatchQueue.main.async(execute: {
                    completionHandler(status, false)
                })

            }
        }
        
    }

}
