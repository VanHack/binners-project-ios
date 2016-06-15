//
//  BPURLBuilder.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 1/29/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import Foundation


class BPURLBuilder {
    
    class func buildFBUserLoginURL(accessToken:String) -> String
    {
        let baseUrl = BPServerSettings.baseServerUrl
        let fbUserLoginUrl = BPServerSettings.facebookLoginUrl
        let fbUserLoginUrlFinal = "\(baseUrl)\(fbUserLoginUrl)\(accessToken)"
        
        return fbUserLoginUrlFinal
    }
    
    class func buildGoogleUserLoginURL(accessToken:String) -> String
    {
        let baseUrl = BPServerSettings.baseServerUrl
        let googleUserLoginUrl = BPServerSettings.googleLoginUrl
        let googleUserLoginUrlFinal = "\(baseUrl)\(googleUserLoginUrl)\(accessToken)"
        
        return googleUserLoginUrlFinal
    }
    
    class func buildTwitterUserLoginURL(accessToken:String, accessSecret:String) -> String
    {
        let baseUrl = BPServerSettings.baseServerUrl
        let twitterUserLoginUrl = BPServerSettings.twitterLoginUrl
        let twitterUserLoginUrlFinal = "\(baseUrl)\(twitterUserLoginUrl)/\(accessToken)/\(accessSecret)"
        
        return twitterUserLoginUrlFinal
    }
    
    class func getPostPickupURL() ->String {
        
        let baseUrl = BPServerSettings.baseServerUrl
        let pickupURL = BPServerSettings.pickupUrl
        return "\(baseUrl)\(pickupURL)"
    }
    
    class func getGetPickupsURL() ->String {
        
        let baseUrl = BPServerSettings.baseServerUrl
        let pickupURL = BPServerSettings.pickupRetriveUrl
        return "\(baseUrl)\(pickupURL)"
    }


    class func getStandardUserLoginURL() -> String
    {
        let baseUrl = BPServerSettings.baseServerUrl
        let UserLoginUrl = BPServerSettings.standardLoginUrl
        
        return "\(baseUrl)\(UserLoginUrl)"
    }
    
    class func getResidentUserRegistrationURL() -> String
    {
        let baseUrl = BPServerSettings.baseServerUrl
        let residentUsersUrl = BPServerSettings.residentUsersUrl
        
        return "\(baseUrl)\(residentUsersUrl)"
    }
    
    class func getAuthTokenRevalidateURL() -> String {
        let baseUrl = BPServerSettings.baseServerUrl
        let revalidateUrl = BPServerSettings.revalidateTokenUrl
        
        return "\(baseUrl)\(revalidateUrl)"

    }
    
    class func buildPickupPhotoUploadURL(pickupId:String) -> String {
        let baseUrl = BPServerSettings.baseServerUrl
        let finalPartUrl = BPServerSettings.photoUploadUrl
        
        return "\(baseUrl)\(pickupId)\(finalPartUrl)"
        
    }
    
}