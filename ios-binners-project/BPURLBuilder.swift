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
}