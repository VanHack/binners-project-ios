//
//  BPURLBuilder.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 1/29/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import Foundation


class BPURLBuilder {
    
    static var residentUserRegistrationURL:NSURL? { return NSURL(string: BPServerSettings.residentUsersUrl) }
    static var postPickupURL:NSURL? { return NSURL(string: BPServerSettings.postPickupUrl) }
    static var getPickupsURL:NSURL? { return NSURL(string: BPServerSettings.getPickupsUrl) }
    static var onGoingPickupsURL:NSURL? { return  NSURL(string: BPServerSettings.onGoingPickupsUrl) }
    static var completedPickupsURL:NSURL? { return NSURL(string: BPServerSettings.completedPickupsUrl) }
    static var waitingReviewPickupURL:NSURL? {return NSURL(string: BPServerSettings.waitingReviewPickupsUrl) }
    static var standardLoginURL:NSURL? { return NSURL(string: BPServerSettings.standardLoginUrl) }
    static var revalidateTokenURL:NSURL? { return NSURL(string: BPServerSettings.revalidateTokenUrl) }
    
    static func buildFBUserLoginURL(accessToken:String) -> NSURL?
    {
        let fbUserLoginUrl = BPServerSettings.facebookLoginUrl
        let fbUserLoginUrlFinal = "\(fbUserLoginUrl)\(accessToken)"
        
        return NSURL(string: fbUserLoginUrlFinal)
    }
    
    static func buildGoogleUserLoginURL(accessToken:String) -> NSURL?
    {
        let googleUserLoginUrl = BPServerSettings.googleLoginUrl
        let googleUserLoginUrlFinal = "\(googleUserLoginUrl)\(accessToken)"
        
        return NSURL(string: googleUserLoginUrlFinal)
    }
    
    static func buildTwitterUserLoginURL(accessToken:String, accessSecret:String) -> NSURL?
    {
        let twitterUserLoginUrl = BPServerSettings.twitterLoginUrl
        let twitterUserLoginUrlFinal = "\(twitterUserLoginUrl)/\(accessToken)/\(accessSecret)"
        
        return NSURL(string: twitterUserLoginUrlFinal)
    }
    
    static func getPasswordResetURL(email: String) -> NSURL? {
        return NSURL(string: "\(BPServerSettings.passwordResetURL)\(email)")
    }
    
    static func buildPickupPhotoUploadURL(pickupId:String) -> NSURL? {
        let baseUrl = BPServerSettings.baseServerUrl
        let finalPartUrl = BPServerSettings.photoUploadUrl
        
        return NSURL(string: "\(baseUrl)\(pickupId)\(finalPartUrl)")
        
    }
    
}
