//
//  BPPickup.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 3/14/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.

import UIKit
import MapKit
import AFNetworking

typealias PickupSucessBlock = ([BPPickup] -> Void)

final class BPPickup : AnyObject {

    var reedemable: BPReedemable!
    var date: NSDate!
    var instructions: String!
    var address: BPAddress!
    var id: String!
    var rating: BPRating?
    var binnerID: String?
    var status: PickupStatus = .OnGoing
    
    init(id: String?,
         instructions: String,
         date: NSDate,
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
    
    func postPickup(onSuccess:OnSuccessBlock, onFailure:OnFailureBlock?) throws {
        
        let wrapper = BPObjectWrapper()
        try wrapper.wrapObject(self)
        
        if let url = BPURLBuilder.postPickupURL {
            
            let manager = AFHTTPSessionManager()
        
            manager.requestSerializer.setValue(wrapper.header!, forHTTPHeaderField: "Authorization")
        
            BPServerRequestManager.sharedInstance.execute(
                .POST,
                url: url,
                manager: manager,
                param: wrapper.body,
                onSuccess: onSuccess,
                onFailure: onFailure)
        }
        
        
    }
    
    class func fetchOnGoingPickups(onSuccess:PickupSucessBlock, onFailure:OnFailureBlock? ) throws {
        
        guard let token = BPUser.sharedInstance().token else {
            throw Error.InvalidToken
        }
        
        if let url = BPURLBuilder.getPickupsURL {
            
            let manager = AFHTTPSessionManager()
            manager.requestSerializer.setValue(token, forHTTPHeaderField: "Authorization")
            
            BPServerRequestManager.sharedInstance.execute(
                .GET,
                url: url,
                manager: manager,
                param: nil,
                onSuccess: {
                    
                    object in
                    
                    guard let pickupsListDictionary = object as? [[String:AnyObject]] else {
                        onFailure?(Error.ErrorConvertingFile)
                        return
                    }
                    
                    var pickups:[BPPickup] = []
                    
                    pickupsListDictionary.forEach( {
                        dictionary in
                        if let pickup = BPPickup.mapToModel(dictionary) {
                            pickups.append(pickup)
                        }
                    })
                    
                    onSuccess(pickups)
                    
                },onFailure:onFailure)
            
        }
        
        
    }

    
//    func postPickupPictureForPickupId(onSuccess:OnSuccessBlock, onFailure:OnFailureBlock?) {
//        
//        if (reedemable.picture != nil) {
//            
//            let finalUrl = BPURLBuilder.buildPickupPhotoUploadURL(id)
//            let manager = AFHTTPSessionManager()
//            
//            manager.POST(finalUrl, parameters: nil, constructingBodyWithBlock: { formData in
//                
//                let imageData = UIImageJPEGRepresentation(self.reedemable.picture, 0.5)
//                formData.appendPartWithFormData(imageData!, name: "pickupImage")
//                
//                }, success: {sessionDataTask,object in
//                    
//                    onSuccess(object!)
//                    
//                }, failure: {sessionDataTask, error in
//                    
//                    onFailure?(BPErrorManager.processErrorFromServer(error))
//            })
//            
//        } else {
//            onFailure?(ErrorPickup.PictureCantBeNil)
//        }
//        
//
//    }
    
}

extension BPPickup : Mappable {
    
    static func mapToModel(object: AnyObject) -> BPPickup? {
        
        guard
        let id = object["_id"] as? String,
        let instructions = object["instructions"] as? String,
        let items = object["items"]! as? NSArray,
        let date = object["time"] as? String,
        let addressJson = object["address"]!,
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
