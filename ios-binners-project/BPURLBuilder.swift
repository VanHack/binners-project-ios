//
//  BPURLBuilder.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 1/29/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import Foundation


class BPURLBuilder {
    
    static func buildFBUserLoginURL(accessToken:String) -> String
    {
        let fbUserLoginUrl = BPServerSettings.facebookLoginUrl
        let fbUserLoginUrlFinal = "\(fbUserLoginUrl)\(accessToken)"
        
        return fbUserLoginUrlFinal
    }
    
    static func buildGoogleUserLoginURL(accessToken:String) -> String
    {
        let googleUserLoginUrl = BPServerSettings.googleLoginUrl
        let googleUserLoginUrlFinal = "\(googleUserLoginUrl)\(accessToken)"
        
        return googleUserLoginUrlFinal
    }
    
    static func buildTwitterUserLoginURL(accessToken:String, accessSecret:String) -> String
    {
        let twitterUserLoginUrl = BPServerSettings.twitterLoginUrl
        let twitterUserLoginUrlFinal = "\(twitterUserLoginUrl)/\(accessToken)/\(accessSecret)"
        
        return twitterUserLoginUrlFinal
    }
    
    static func getPostPickupURL() -> String {
        return BPServerSettings.postPickupUrl
    }
    
    static func getGetPickupsURL() -> String {
        return BPServerSettings.getPickupsUrl
    }
    
    static func getOnGoingPickupsURL() -> String {
        return BPServerSettings.onGoingPickupsUrl
    }

    static func getCompletedPickupsURL() -> String {
        return BPServerSettings.completedPickupsUrl
    }
    
    static func getWaitingForReviewPickupsURL() -> String {
        return BPServerSettings.waitingReviewPickupsUrl
    }

    static func getStandardUserLoginURL() -> String
    {
        return BPServerSettings.standardLoginUrl
    }
    
    static func getResidentUserRegistrationURL() -> String
    {
        return BPServerSettings.residentUsersUrl
    }
    
    static func getAuthTokenRevalidateURL() -> String {
        return BPServerSettings.revalidateTokenUrl
    }
    
    static func getPasswordResetURL(email: String) -> String {
        return "\(BPServerSettings.passwordResetURL)\(email)"
    }
    
    static func buildPickupPhotoUploadURL(pickupId:String) -> String {
        let baseUrl = BPServerSettings.baseServerUrl
        let finalPartUrl = BPServerSettings.photoUploadUrl
        
        return "\(baseUrl)\(pickupId)\(finalPartUrl)"
        
    }
    
}
