//
//  BPPickupService.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 05/11/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import Foundation
import AFNetworking

class BPPickupService {
    
    class func fetchPickups(_ pickupStatusList: [PickupStatus], withLimit limit: UInt, onSuccess: @escaping PickupSucessBlock, onFailure: OnFailureBlock? ) throws {
        
        guard let token = BPUser.sharedInstance.token else {
            throw BPError.invalidToken
        }
        
        if let url = BPURLBuilder.getPickupsURL(pickupStatusList, withLimit: limit) {
            
            let manager = AFHTTPSessionManager()
            manager.requestSerializer.setValue(token, forHTTPHeaderField: "Authorization")
            
            BPServerRequestManager.sharedInstance.execute(
                .get,
                url: url,
                manager: manager,
                param: nil,
                onSuccess: {
                    
                    object in
                    
                    guard let pickupsListDictionary = object as? [[AnyHashable : AnyObject]] else {
                        onFailure?(BPError.errorConvertingFile)
                        return
                    }
                    
                    var pickups:[BPPickup] = []
                    
                    pickupsListDictionary.forEach( {
                        dictionary in
                        if let pickup = BPPickup.mapToModel(withData: dictionary as AnyObject) {
                            pickups.append(pickup)
                        }
                    })
                    
                    onSuccess(pickups)
                    
            },onFailure:onFailure)
            
        }
    }
    
    class func postPickup( _ pickup: BPPickup, onSuccess: @escaping OnSuccessBlock, onFailure: OnFailureBlock?) {
        
        let wrapper = BPObjectWrapper()
        wrapper.wrapObject(pickup)
        
        if let url = BPURLBuilder.postPickupURL {
            
            let manager = AFHTTPSessionManager()
            
            manager.requestSerializer.setValue(wrapper.header!, forHTTPHeaderField: "Authorization")
            
            BPServerRequestManager.sharedInstance.execute(
                .post,
                url: url,
                manager: manager,
                param: wrapper.body,
                onSuccess: onSuccess,
                onFailure: onFailure)
        }
        
        
    }

    
}
