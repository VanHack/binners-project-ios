//
//  BPRatePickupViewModel.swift
//  ios-binners-project
//
//  Created by Matheus Alves Alano Dias on 08/02/17.
//  Copyright © 2017 Rodrigo de Souza Reis. All rights reserved.
//

import Foundation

protocol RateDelegate {
    func didFinishRatingPickup(_ success:Bool, errorMsg: String?)
}

class BPRatePickupViewModel {
    
    var rateDelegate:RateDelegate?
    
    func ratePickup(pickupID: String, rate: Int, comment: String) throws {
        try BPRateService.ratePickups(
            pickupID: pickupID,
            rate: rate,
            comment: comment,
            onSuccess: {_ in
                self.rateDelegate?.didFinishRatingPickup(true, errorMsg: nil)
        },
            onFailure: {_ in
                self.rateDelegate?.didFinishRatingPickup(false, errorMsg: "Could not rate")
        })
    }
    
}
