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
    
    func execute(request:KindOfRequest,urlString:String,manager:AFHTTPSessionManager,param:AnyObject?,completion:(inner:() throws ->AnyObject) ->Void) throws
    {
        
        guard let url = NSURL(string: urlString) else
        {
            throw Error.URLMalformedError(errorMsg: "Error with URL")
        }
        
            
            switch(request)
            {
                case .GET:      executeGET(url,manager:manager,param:param,completion: completion)
                case .POST:     executePOST(url,manager:manager,param:param,completion: completion)
                case .DELETE:   throw Error.OperationNotSupported(errorMsg: "Operation not supported")
                case .PUT:      throw Error.OperationNotSupported(errorMsg: "Operation not supported")
            }

        
        
    }
    
    internal func executeGET(url:NSURL,manager:AFHTTPSessionManager,param:AnyObject?,completion:(inner:() throws ->AnyObject) ->Void)
    {
        
        manager.GET(url.absoluteString, parameters: param, progress: nil, success: {
            
            sessionDataTask,response in
            
            completion(inner: {return response! })
            
            },failure: {
                
                (sessionDataTask, error) in
                
                completion(inner: {
                
                    let error = try BPErrorManager.processErrorFromServer(error)
                    throw error
                
                })

                
                
        })
    }
    
    internal func executePOST(url:NSURL,manager:AFHTTPSessionManager,param:AnyObject?,completion:(inner:()throws->AnyObject)->Void)
    {
        
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        
        manager.POST(url.absoluteString, parameters: param, progress: nil, success: {
            
            sessionDataTask,response in
            
            completion(inner: {return response!})
            
            
            },failure: {
                
                (sessionDataTask, error) in
                
                completion(inner: {
                    let error = try BPErrorManager.processErrorFromServer(error)
                    throw error
                
                })
                
                
        })
    }

    
}