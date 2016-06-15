//
//  BPPickup.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 3/14/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit
import MapKit

class BPPickup: NSObject {

    var reedemable:BPReedemable!
    var date:NSDate!
    var instructions:String!
    var address:BPAddress!
    var id:String!
    var rating:BPRating?
    var binnerID:String?
    var status:String? = "Ongoing"
    
    
    func postPickupPictureForPickupId(id:String,completion:(inner:() throws -> AnyObject?) ->Void)throws {
        
        if (reedemable.picture != nil) {
            
            let finalUrl = BPURLBuilder.buildPickupPhotoUploadURL(id)
            let manager = AFHTTPSessionManager()
            
            manager.POST(finalUrl, parameters: nil, constructingBodyWithBlock:{ formData in
                
                let imageData = UIImageJPEGRepresentation(self.reedemable.picture, 0.5);
                formData.appendPartWithFormData(imageData!, name: "pickupImage")
                
                }, success: {sessionDataTask,object in
                    
                    completion(inner: {return object!})
                    
                }, failure: {sessionDataTask,error in
                    
                    completion(inner: {
                        throw try BPErrorManager.processErrorFromServer(error)
                    })
                    
            })
            
        } else {
            completion(inner: {return nil})
        }
        

    }
    
}
