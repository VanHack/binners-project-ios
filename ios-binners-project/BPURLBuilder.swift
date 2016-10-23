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
    static var getPickupsURL:URL? { return URL(string: BPServerSettings.getPickupsUrl) }
    static var onGoingPickupsURL:URL? { return  URL(string: BPServerSettings.onGoingPickupsUrl) }
    static var completedPickupsURL:URL? { return URL(string: BPServerSettings.completedPickupsUrl) }
    static var waitingReviewPickupURL:URL? {return URL(string: BPServerSettings.waitingReviewPickupsUrl) }
    static var standardLoginURL:URL? { return URL(string: BPServerSettings.standardLoginUrl) }
    static var revalidateTokenURL:URL? { return URL(string: BPServerSettings.revalidateTokenUrl) }
    
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
