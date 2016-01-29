//
//  BPErrors.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 1/29/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import Foundation


enum Error : ErrorType
{
    case URLMalformedError(errorMsg:String)
    case RequestError(errorMsg:String)
    case OperationNotSupported(errorMsg:String)
    case FacebookAuthMissing(errorMsg:String)
}