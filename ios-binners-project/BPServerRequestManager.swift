//
//  BPServerRequestManager.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 1/29/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import Foundation

enum KindOfRequest
{
    case POST
    case GET
    case DELETE
    case PUT
}

class BPServerRequestManager
{
    static let sharedInstance = BPServerRequestManager()
    
    func execute(request:KindOfRequest,urlString:String,manager:AFHTTPSessionManager,param:AnyObject?,completion:(value:AnyObject?,error:ErrorType?)->Void)
    {
        
        guard let url = NSURL(string: urlString) else
        {
            completion(value: nil,error: Error.URLMalformedError(errorMsg: "Error with URL"))
            return
        }
        
        switch(request)
        {
            case .GET:      executeGET(url,manager:manager,param:param,completion: completion)
            case .POST:     executePOST(url,manager:manager,param:param,completion: completion)
            case .DELETE:   completion(value:nil,error:Error.OperationNotSupported(errorMsg: "Operation not supported"))
            case .PUT:      completion(value:nil,error:Error.OperationNotSupported(errorMsg: "Operation not supported"))

            
        }
        
        
    }
    
    private func executeGET(url:NSURL,manager:AFHTTPSessionManager,param:AnyObject?,completion:(value:AnyObject?,error:ErrorType?)->Void)
    {
        
       // manager.requestSerializer.setValue(auth, forHTTPHeaderField: "Authorization")
        
        manager.GET(url.absoluteString, parameters: param, progress: nil, success: {
            
            sessionDataTask,response in
            
            completion(value:response,error:nil)
            
            
            },failure: {
                
                (sessionDataTask, error) in
                
                completion(value:nil,error:error)
                
                
        })
    }
    
    private func executePOST(url:NSURL,manager:AFHTTPSessionManager,param:AnyObject?,completion:(value:AnyObject?,error:ErrorType?)->Void)
    {
        let manager = AFHTTPSessionManager()
        
        manager.POST(url.absoluteString, parameters: param, progress: nil, success: {
            
            sessionDataTask,response in
            
            completion(value:response,error:nil)
            
            
            },failure: {
                
                (sessionDataTask, error) in
                
                completion(value:nil,error:error)
                
                
        })
    }

    
}