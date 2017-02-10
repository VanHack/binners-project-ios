//
//  BPRateService.swift
//  ios-binners-project
//
//  Created by Matheus Alves Alano Dias on 09/02/17.
//  Copyright © 2017 Rodrigo de Souza Reis. All rights reserved.
//

import Foundation
import AFNetworking

class BPRateService {
    
    class func ratePickups(pickupID: String, rate: Int, comment: String, onSuccess: @escaping OnSuccessBlock, onFailure: OnFailureBlock? ) throws {
        
        guard let token = BPUser.sharedInstance.token else {
            throw BPError.invalidToken
        }
        
        if let url = URL(binnersPath: .ratePickup(pickupId: pickupID)) {
            
            let manager = AFHTTPSessionManager()
            manager.requestSerializer.setValue(token, forHTTPHeaderField: "Authorization")
            
            let param = ["rate":rate,"comment":comment] as AnyObject
            
            BPServerRequestManager.sharedInstance.execute(
                .post,
                url: url,
                manager: manager,
                param: param,
                onSuccess: onSuccess, onFailure: onFailure)
        }
    }
}
