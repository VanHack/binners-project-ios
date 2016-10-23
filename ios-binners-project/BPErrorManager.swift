//
//  BPErrors.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 1/29/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import Foundation
import AFNetworking


class BPErrorManager
{
    
    class func processErrorFromServer(_ error: NSError) -> Error
    {
        
        guard let errorUserInfoData =
            error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as? Data else {
                return BPError.invalidError
        }
        
        do {
            let errorParsed = try JSONSerialization.jsonObject(
                with: errorUserInfoData,
                options:JSONSerialization.ReadingOptions.allowFragments) as AnyObject
            
            guard let errorDetails = errorParsed["details"] as? Int,
                let errorMSg = errorParsed["error"] as? String else {
                return BPError.invalidError
            }
            
            return ErrorServer.errorWithCode(errorCode: String(errorDetails), errorMsg: errorMSg)
            
        } catch let error {
            return error
        }
        
    }
}

enum ErrorServer : Error {
    case couldNotGetToken
    case errorWithCode(errorCode: String, errorMsg: String)
}

enum BPError : Error
{
    case invalidURL
    case errorConvertingFile
    case invalidToken
    case googleAuthMissing
    case fbAuthMissing
    case twitterAuthMissing
    case userError
    case invalidError
    case fbPublicProfileNotProvided
    case serverError(Error)
}

enum ErrorPickup : Error {
    case pictureCantBeNil
}

extension BPError {
    
    func errorMsg() -> String {
        
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .errorConvertingFile:
            return "Error converting file"
        case .invalidToken:
            return "Invalid token"
        case .fbAuthMissing:
            return "Facebook Auth missing"
        case .twitterAuthMissing:
            return "Twitter Auth missing"
        case .googleAuthMissing:
            return "Google auth missing"
        case .serverError(let error):
            return msg(forServerError: error)
        default:
            return "An unexpected error happened!"
        }
        
    }
    
    fileprivate func msg(forServerError error:Error) -> String {
        return "Server error"
    }
    
}


