//
//  BPURLBuilder.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 1/29/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import Foundation

enum BinnersStringPaths {
    case twitter(accessToken: String, accessSecret: String)
    case facebook(accessToken: String)
    case google(accessToken: String)
    case getPickups(pickupStatuses: [PickupStatus], limit: UInt)
    case passwordReset(String)
    case pickupPhotoUpload(pickupId: String)
    case residentRegistration
    case postPickup
    case standardLogin
    case revalidateToken
    
}

extension URL {
    
    init?(binnersPath: BinnersStringPaths) {
        
        switch binnersPath {
        case .revalidateToken:
            self.init(string: BPServerSettings.revalidateTokenPath)
        case .standardLogin:
            self.init(string: BPServerSettings.standardLoginPath)
        case .postPickup:
            self.init(string: BPServerSettings.postPickupPath)
        case .residentRegistration:
            self.init(string: BPServerSettings.residentUsersPath)
        case .pickupPhotoUpload(let pickupId):
            self.init(string: BPServerSettings.pickupPhotoUpload(pickupId))
        case .passwordReset(let email):
            self.init(string: BPServerSettings.passwordReset(email))
        case .getPickups(let pickupStatuses, let limit):
            self.init(string:BPServerSettings.getPickups(pickupStatuses, withLimit: limit))
        case .google(let accessToken):
            self.init(string: BPServerSettings.googleUserLogin(accessToken))
        case .facebook(let accessToken):
            self.init(string: BPServerSettings.fBUserLogin(accessToken))
        case .twitter(let accessToken, let accessSecret):
            self.init(string: BPServerSettings.twitterUserLogin(accessToken, accessSecret: accessSecret))
        }
        
        
    }
    
}
