//
//  BPURLBuilder.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 1/29/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import Foundation

class BPURLBuilder {
    
    static var residentUserRegistrationURL:URL? { return URL(string: BPServerSettings.residentUsersUrl) }
    static var postPickupURL:URL? { return URL(string: BPServerSettings.postPickupUrl) }
    static var standardLoginURL:URL? { return URL(string: BPServerSettings.standardLoginUrl) }
    static var revalidateTokenURL:URL? { return URL(string: BPServerSettings.revalidateTokenUrl) }
    
    static func getPickupsURL( _ pickupStatus: PickupStatus) -> URL? {
    
        switch pickupStatus {
        case .completed:
            return URL(string: BPServerSettings.completedPickupsUrl)
        case .onGoing:
            return URL(string: BPServerSettings.onGoingPickupsUrl)
        case .waitingForReview:
            return URL(string:BPServerSettings.waitingReviewPickupsUrl)
        }
    }
    
    static func getPickupsURL( _ pickupStatuses: [PickupStatus], withLimit limit: UInt) -> URL? {
        
        
        var stringURL = BPServerSettings.statusTrackingPickupsUrl
        pickupStatuses.forEach({ pickupStatus in
        
            stringURL += "status=" + pickupStatus.statusUrlString()
            
            if pickupStatuses.last != pickupStatus {
                stringURL += "&"
            }
        })
        stringURL += "?limit=\(limit)"
        
        return URL(string: stringURL)
        
    }
    
    static func buildFBUserLoginURL(_ accessToken:String) -> URL?
    {
        let fbUserLoginUrl = BPServerSettings.facebookLoginUrl
        let fbUserLoginUrlFinal = "\(fbUserLoginUrl)\(accessToken)"
        
        return URL(string: fbUserLoginUrlFinal)
    }
    
    static func buildGoogleUserLoginURL(_ accessToken:String) -> URL?
    {
        let googleUserLoginUrl = BPServerSettings.googleLoginUrl
        let googleUserLoginUrlFinal = "\(googleUserLoginUrl)\(accessToken)"
        
        return URL(string: googleUserLoginUrlFinal)
    }
    
    static func buildTwitterUserLoginURL(_ accessToken:String, accessSecret:String) -> URL?
    {
        let twitterUserLoginUrl = BPServerSettings.twitterLoginUrl
        let twitterUserLoginUrlFinal = "\(twitterUserLoginUrl)/\(accessToken)/\(accessSecret)"
        
        return URL(string: twitterUserLoginUrlFinal)
    }
    
    static func getPasswordResetURL(_ email: String) -> URL? {
        return URL(string: "\(BPServerSettings.passwordResetURL)\(email)")
    }
    
    static func buildPickupPhotoUploadURL(_ pickupId:String) -> URL? {
        let baseUrl = BPServerSettings.baseServerUrl
        let finalPartUrl = BPServerSettings.photoUploadUrl
        
        return URL(string: "\(baseUrl)\(pickupId)\(finalPartUrl)")
        
    }
    
}
