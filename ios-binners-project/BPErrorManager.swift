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
    
    class func processErrorFromServer(error:NSError) -> ErrorType
    {
        
        guard let errorUserInfoData =
            error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as? NSData else {
                return Error.ErrorWithMsg(errorMsg: "Invalid Error type")
        }
        
        do {
            let errorParsed = try NSJSONSerialization.JSONObjectWithData(
                errorUserInfoData,
                options:NSJSONReadingOptions.AllowFragments)
            
            guard let errorDetails = errorParsed["details"] as? Int,
                errorMSg = errorParsed["error"] as? String else
            {
                return Error.ErrorWithMsg(errorMsg: "Invalid Error type")
            }
            
            return ErrorServer.ErrorWithCode(errorCode: String(errorDetails), errorMsg: errorMSg)
            
        } catch let error {
            return error
        }
        
    }
}

enum ErrorServer : ErrorType {
    case CouldNotGetToken
    case ErrorWithCode(errorCode:String, errorMsg:String)
}

enum Error : ErrorType
{
    case ErrorWithMsg(errorMsg:String)
    case InvalidURL
    case ErrorConvertingFile
    case InvalidToken
}

enum ErrorPickup : ErrorType {
    case PictureCantBeNil
}

enum ErrorUser : ErrorType {
    case ErrorCreatingUser
}
