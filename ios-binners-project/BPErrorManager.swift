//
//  BPErrors.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 1/29/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import Foundation


class BPErrorManager
{
    
    class func processErrorFromServer(error:NSError) throws ->ErrorType
    {
        
        guard let errorUserInfoData =
            error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as? NSData else {
                throw Error.ErrorWithMsg(errorMsg: "Invalid Error type")

        }
        
        let errorParsed = try NSJSONSerialization.JSONObjectWithData(
            errorUserInfoData,
            options:NSJSONReadingOptions.AllowFragments)
        
        guard let errorDetails = errorParsed["details"] as? Int,
        errorMSg = errorParsed["error"] as? String else
        {
            throw Error.ErrorWithMsg(errorMsg: "Invalid Error type")
        }
        
        return Error.ErrorWithCode(errorCode: String(errorDetails), errorMsg: errorMSg)
        
    }
}

enum Error : ErrorType
{
    case ErrorWithMsg(errorMsg:String)
    case ErrorWithCode(errorCode:String, errorMsg:String)

}