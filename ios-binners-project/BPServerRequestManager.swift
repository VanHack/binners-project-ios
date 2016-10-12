//
//  BPServerRequestManager.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 1/29/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.

import Foundation
import AFNetworking

enum KindOfRequest {
    case POST
    case GET
    case DELETE
    case PUT
}

typealias OnSuccessBlock = (AnyObject) -> Void
typealias OnFailureBlock = (ErrorType) -> Void

class BPServerRequestManager {
    static let sharedInstance = BPServerRequestManager()
    
    func execute(request: KindOfRequest,
                 urlString: String,
                 manager: AFHTTPSessionManager,
                 param: AnyObject?,
                 onSuccess successBlock:OnSuccessBlock, onFailure failureBlock:OnFailureBlock?) throws {
        
         guard let url = NSURL(string: urlString) else {
            throw Error.InvalidURL
        }
        
        switch request {
        case .GET:      executeGET(url, manager:manager, param:param, onSuccess:successBlock, onFailure:failureBlock)
        case .POST:     executePOST(url, manager:manager, param:param, onSuccess:successBlock, onFailure:failureBlock)
        case .DELETE:   fatalError("Operation not supported")
        case .PUT:      fatalError("Operation not supported")

        }
        
    }
    
    internal func executeGET(
        url:NSURL,
        manager:AFHTTPSessionManager,
        param:AnyObject?,
        onSuccess:OnSuccessBlock, onFailure:OnFailureBlock?) {
        
        manager.GET(url.absoluteString, parameters: param, progress: nil, success: {
            
            _,response in
            
            onSuccess(response!)
            
        },failure: {
                
            (_, error) in
                
            onFailure?(error)
                
        })
    }
    
    internal func executePOST(
        url:NSURL,
        manager:AFHTTPSessionManager,
        param:AnyObject?,
        onSuccess:OnSuccessBlock, onFailure:OnFailureBlock?) {
        
        manager.POST(url.absoluteString, parameters: param, progress: nil, success: {
            
            _,response in
            onSuccess(response!)
            
        },failure: {
                
            (_, error) in
            onFailure?(error)
                
        })
    }
    

    
}
