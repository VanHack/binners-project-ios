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
    
    class func buildTwitterUserLoginURL(accessToken:String) -> String
    {
        let baseUrl = BPServerSettings.baseServerUrl
        let twitterUserLoginUrl = BPServerSettings.twitterLoginUrl
        let twitterUserLoginUrlFinal = "\(baseUrl)\(twitterUserLoginUrl)\(accessToken)"
        
        return twitterUserLoginUrlFinal
    }

    class func getStandardUserLoginURL() -> String
    {
        let baseUrl = BPServerSettings.baseServerUrl
        let UserLoginUrl = BPServerSettings.standardLoginUrl
        let userLoginUrlFinal = "\(baseUrl)\(UserLoginUrl)"
        
        return userLoginUrlFinal
    }
    
    class func getResidentUserRegistrationURL() -> String
    {
        let baseUrl = BPServerSettings.baseServerUrl
        let residentUsersUrl = BPServerSettings.residentUsersUrl
        let userLoginUrlFinal = "\(baseUrl)\(residentUsersUrl)"
        
        return userLoginUrlFinal
    }
}