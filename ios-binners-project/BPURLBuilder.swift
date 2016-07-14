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
        let baseUrl = BPServerSettings.baseServerUrl
        let fbUserLoginUrl = BPServerSettings.facebookLoginUrl
        let fbUserLoginUrlFinal = "\(baseUrl)\(fbUserLoginUrl)\(accessToken)"
        
        return fbUserLoginUrlFinal
    }
    
    static func buildGoogleUserLoginURL(accessToken:String) -> String
    {
        let baseUrl = BPServerSettings.baseServerUrl
        let googleUserLoginUrl = BPServerSettings.googleLoginUrl
        let googleUserLoginUrlFinal = "\(baseUrl)\(googleUserLoginUrl)\(accessToken)"
        
        return googleUserLoginUrlFinal
    }
    
    static func buildTwitterUserLoginURL(accessToken:String, accessSecret:String) -> String
    {
        let baseUrl = BPServerSettings.baseServerUrl
        let twitterUserLoginUrl = BPServerSettings.twitterLoginUrl
        let twitterUserLoginUrlFinal = "\(baseUrl)\(twitterUserLoginUrl)/\(accessToken)/\(accessSecret)"
        
        return twitterUserLoginUrlFinal
    }
    
    static func getPostPickupURL() -> String {
        
        let baseUrl = BPServerSettings.baseServerUrl
        let pickupURL = BPServerSettings.pickupUrl
        return "\(baseUrl)\(pickupURL)"
    }
    
    static func getGetPickupsURL() -> String {
        
        let baseUrl = BPServerSettings.baseServerUrl
        let pickupURL = BPServerSettings.pickupRetriveUrl
        return "\(baseUrl)\(pickupURL)"
    }


    static func getStandardUserLoginURL() -> String
    {
        let baseUrl = BPServerSettings.baseServerUrl
        let UserLoginUrl = BPServerSettings.standardLoginUrl
        
        return "\(baseUrl)\(UserLoginUrl)"
    }
    
    static func getResidentUserRegistrationURL() -> String
    {
        let baseUrl = BPServerSettings.baseServerUrl
        let residentUsersUrl = BPServerSettings.residentUsersUrl
        
        return "\(baseUrl)\(residentUsersUrl)"
    }
    
    static func getAuthTokenRevalidateURL() -> String {
        let baseUrl = BPServerSettings.baseServerUrl
        let revalidateUrl = BPServerSettings.revalidateTokenUrl
        
        return "\(baseUrl)\(revalidateUrl)"

    }
    
    static func getPasswordResetURL(email: String) -> String {
        let baseUrl = BPServerSettings.baseServerUrl
        let passwordResetUrl = BPServerSettings.passwordResetURL
        
        return "\(baseUrl)\(passwordResetUrl)\(email)"
        
    }
    
    static func buildPickupPhotoUploadURL(pickupId:String) -> String {
        let baseUrl = BPServerSettings.baseServerUrl
        let finalPartUrl = BPServerSettings.photoUploadUrl
        
        return "\(baseUrl)\(pickupId)\(finalPartUrl)"
        
    }
    
}
