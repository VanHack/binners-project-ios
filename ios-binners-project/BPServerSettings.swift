//
//  BPServerSettings.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 1/29/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import Foundation


struct BPServerSettings
{
    //static let baseServerUrl = "http://dev-b.leomcabral.com/api/v1.0/"
    static let baseServerPath =          "http://binners.herokuapp.com/api/v1.0/"
    static let facebookLoginPath =           "\(baseServerPath)auth/facebook/"
    static let googleLoginPath =             "\(baseServerPath)auth/google/"
    static let twitterLoginPath =            "\(baseServerPath)auth/twitter"
    static let postPickupPath =              "\(baseServerPath)pickup"
    static let getPickupsPath =              "\(baseServerPath)pickups"
    static let residentUsersPath =           "\(baseServerPath)users"
    static let standardLoginPath =           "\(baseServerPath)auth"
    static let revalidateTokenPath =         "\(baseServerPath)auth/revalidate"
    static let passwordResetPath =           "\(baseServerPath)auth/forgot/"
    static let photoUploadPath =             "photos"
    static let statusTrackingPickupsPath =   "\(getPickupsPath)/status-tracking?"
    
    static func pickupPhotoUpload(_ pickupId:String) -> String {
        return "\(baseServerPath)\(pickupId)\(photoUploadPath)"
    }
    
    static func passwordReset(_ email: String) -> String {
        return "\(passwordResetPath)\(email)"
    }
    
    static func fBUserLogin(_ accessToken:String) -> String {
        return "\(facebookLoginPath)\(accessToken)"
    }
    
    static func googleUserLogin(_ accessToken:String) -> String {
        return "\(googleLoginPath)\(accessToken)"
    }
    
    static func twitterUserLogin(_ accessToken:String, accessSecret:String) -> String {
        return "\(twitterLoginPath)/\(accessToken)/\(accessSecret)"
    }
    
    static func ratePickup(pickupId: String) -> String {
        return "\(getPickupsPath)/\(pickupId)/review"
    }
    
    static func getPickups( _ pickupStatuses: [PickupStatus], withLimit limit: UInt) -> String {
        
        var stringURL = statusTrackingPickupsPath + "limit=\(limit)&status=["
        pickupStatuses.forEach({ pickupStatus in
            
            stringURL += "\"" + pickupStatus.statusUrlString() + "\""
            
            if pickupStatuses.last != pickupStatus {
                stringURL += ","
            }
            else {
                stringURL += "]"
            }
        })
        stringURL = stringURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        return stringURL
        
    }
    
}
