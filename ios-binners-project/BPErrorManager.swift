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
        let errorParsed = try NSJSONSerialization.JSONObjectWithData(error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as! NSData, options:NSJSONReadingOptions.AllowFragments)
        
        guard let errorDetails = errorParsed["details"] else
        {
            throw Error.InvalidErrorType(erroMSg: "Invalid Error type")
        }
        
        return Error.InvalidInformationProvided(errorCode: errorDetails!["errorCode"] as! String, errorMsg: errorDetails!["message"] as! String)
        
    }
}

enum Error : ErrorType
{
    case URLMalformedError(errorMsg:String)
    case RequestError(errorCode:String, errorMsg:String)
    case OperationNotSupported(errorMsg:String)
    case FacebookAuthMissing(errorMsg:String)
    case GoogleAuthMissing(errorMsg:String)
    case TwitterAuthMissing(errorMsg:String)
    case AuthMissing(errorMsg:String)
    case InvalidErrorType(erroMSg:String)
    case InvalidInformationProvided(errorCode:String, errorMsg:String)
    case DataBaseError(errorMsg:String)

}