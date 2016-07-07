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
        
        guard let _ = errorParsed["details"] else
        {
            throw Error.ErrorWithMsg(errorMsg: "Invalid Error type")
        }
        
        return Error.ErrorWithCode(errorCode: String(errorParsed["statusCode"] as! Int), errorMsg: errorParsed["error"] as! String)
        
    }
}

enum Error : ErrorType
{
    case ErrorWithMsg(errorMsg:String)
    case ErrorWithCode(errorCode:String, errorMsg:String)

}