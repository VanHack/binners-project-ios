//
//  BPPickup.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 3/14/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.

import UIKit
import MapKit
import AFNetworking



final class BPPickup : AnyObject {

    var reedemable: BPReedemable!
    var date: NSDate!
    var instructions: String!
    var address: BPAddress!
    var id: String!
    var rating: BPRating?
    var binnerID: String?
    var status: String? = "Ongoing"
    
    init(id: String?, instructions: String, date: NSDate, reedemable: BPReedemable, address: BPAddress) {
        
        self.id = id
        self.instructions = instructions
        self.date = date
        self.reedemable = reedemable
        self.address = address
    }
    
    init() {}
    
    func postPickup(onSuccess:OnSuccessBlock, onFailure:OnFailureBlock) throws {
        
        let wrapper = BPObjectWrapper()
        try wrapper.wrapObject(self)
        
        let url = BPURLBuilder.getPostPickupURL()
        let manager = AFHTTPSessionManager()
        
        manager.requestSerializer.setValue(wrapper.header!, forHTTPHeaderField: "Authorization")
        
        try BPServerRequestManager.sharedInstance.execute(
            .POST,
            urlString: url,
            manager: manager,
            param: wrapper.body,
            onSuccess: onSuccess,
            onFailure: onFailure)
        
        
    }
    
    class func fetchOnGoingPickups(onSuccess:( [BPPickup]) -> Void, onFailure: (ErrorType) -> Void ) throws {
        
        guard let token = BPUser.sharedInstance().token else {
            throw Error.ErrorWithMsg(errorMsg: "Invalid user token")
            
        }
        
        let url = BPURLBuilder.getGetPickupsURL()
        let manager = AFHTTPSessionManager()
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "Authorization")
        
        try BPServerRequestManager.sharedInstance.execute(
            .GET,
            urlString: url,
            manager: manager,
            param: nil,
            onSuccess: {
                
            object in
            
            completion( inner: {
                
                guard let pickupsListDictionary = object as? [[String:AnyObject]] else {
                    throw Error.ErrorConvertingFile
                }
                
                let pickups = try pickupsListDictionary.map( {
                    dictionary -> BPPickup in
                    return BPPickup.mapToModel(dictionary)
                })
                return pickups
            })
            
            
        })
        
        
    }

    
    func postPickupPictureForPickupId(completion:(inner:() throws -> AnyObject?) ->Void)throws {
        
        if (reedemable.picture != nil) {
            
            let finalUrl = BPURLBuilder.buildPickupPhotoUploadURL(id)
            let manager = AFHTTPSessionManager()
            
            manager.POST(finalUrl, parameters: nil, constructingBodyWithBlock: { formData in
                
                let imageData = UIImageJPEGRepresentation(self.reedemable.picture, 0.5)
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

extension BPPickup : Mappable {
    
    static func mapToModel(object: AnyObject) -> BPPickup? {
        
        
        guard
        let id = object["_id"] as? String,
        let instructions = object["instructions"] as? String,
        let items = object["items"]!,
        let date = object["time"] as? String,
        let addressJson = object["address"]! else {
                return nil
        }
        guard
        let quantityDic = items[0],
        let quantity = quantityDic["quantity"] as? String else {
                return nil
        }
        guard
            let addressString = addressJson["street"] as? String else {
                return nil
        }
        
        guard
            let locationDic = addressJson["location"]! else {
                return nil
        }
        guard
            let coordinates = locationDic["coordinates"] as? [Double] else {
                return nil
        }
        
        guard let dateObject = BPParser.parseDateFromServer(date) else {
            return nil
        }
        
        let address = BPAddress()
        let reedemable = BPReedemable(quantity: quantity)
        address.formattedAddress = addressString
        address.location = CLLocationCoordinate2D(latitude: coordinates[0], longitude: coordinates[1])
        
        return BPPickup(id: id,
                        instructions: instructions,
                        date: dateObject,
                        reedemable: reedemable,
                        address: address)
        
    }

}

extension BPPickup : Wrappable {
    
     func mapToData() throws -> AnyObject {
        
        let items = [
            "quantity": String(reedemable.quantity)
        ]
        
        let location = [
            "coordinates": [self.address.location.latitude, self.address.location.longitude]
        ]
        
        let address = [
            "street": self.address.formattedAddress,
            "location": location
        ]
        
        let pickupDic = [
            "requester": BPUser.sharedInstance().id,
            "address": address,
            "time": self.date,
            "instructions": self.instructions,
            "items": [items]
        ]
        return pickupDic
    }
}
