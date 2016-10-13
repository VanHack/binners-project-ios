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
    static let baseServerUrl =          "http://binners.herokuapp.com/api/v1.0/"
    static let facebookLoginUrl =           "\(baseServerUrl)auth/facebook/"
    static let googleLoginUrl =             "\(baseServerUrl)auth/google/"
    static let twitterLoginUrl =            "\(baseServerUrl)auth/twitter"
    static let postPickupUrl =              "\(baseServerUrl)pickup"
    static let getPickupsUrl =              "\(baseServerUrl)pickups"
    static let residentUsersUrl =           "\(baseServerUrl)users"
    static let standardLoginUrl =           "\(baseServerUrl)auth"
    static let revalidateTokenUrl =         "\(baseServerUrl)auth/revalidate"
    static let passwordResetURL =           "\(baseServerUrl)auth/forgot/"
    static let photoUploadUrl =             "photos"
    static let onGoingPickupsUrl =          "\(getPickupsUrl)/ongoing"
    static let waitingReviewPickupsUrl =    "\(getPickupsUrl)/waitingreview"
    static let completedPickupsUrl =          "\(getPickupsUrl)/completed"
    
}
