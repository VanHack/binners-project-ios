//
//  BPServerRequestManager.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 1/29/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.

import Foundation
import AFNetworking

enum KindOfRequest {
    case post
    case get
    case delete
    case put
}

typealias OnSuccessBlock = (AnyObject) -> Void
typealias OnFailureBlock = (BPError) -> Void

class BPServerRequestManager {
    static let sharedInstance = BPServerRequestManager()
    
    func execute(_ request: KindOfRequest,
                 url: URL,
                 manager: AFHTTPSessionManager,
                 param: AnyObject?,
                 onSuccess successBlock:@escaping OnSuccessBlock, onFailure failureBlock:OnFailureBlock?) {
        
        switch request {
        case .get:      executeGET(url, manager:manager, param:param, onSuccess:successBlock, onFailure:failureBlock)
        case .post:     executePOST(url, manager:manager, param:param, onSuccess:successBlock, onFailure:failureBlock)
        case .delete:   fatalError("Operation not supported")
        case .put:      fatalError("Operation not supported")

        }
        
    }
    
    internal func executeGET(
        _ url:URL,
        manager:AFHTTPSessionManager,
        param:AnyObject?,
        onSuccess:@escaping OnSuccessBlock, onFailure:OnFailureBlock?) {
        
        manager.get(url.absoluteString, parameters: param, progress: nil, success: {
            
            (_,response: Any) in
            
            onSuccess(response as AnyObject)
            
        },failure: { (_, error: Error) in
                
            onFailure?(BPError.serverError(error))
                
        })
    }
    
    internal func executePOST(
        _ url:URL,
        manager:AFHTTPSessionManager,
        param:AnyObject?,
        onSuccess:@escaping OnSuccessBlock, onFailure:OnFailureBlock?) {
        
        manager.post(url.absoluteString, parameters: param, progress: nil, success: {
            
            (_,response: Any) in
            onSuccess(response as AnyObject)
            
        },failure: { (_, error: Error) in
            
            onFailure?(BPError.serverError(error))
                
        })
    }
    

    
}
