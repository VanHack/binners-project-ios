//
//  BPEncoder.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 6/14/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import Foundation

struct BPEncoder {
    
    static func convertSwiftArrayToNSArrayWithData<T where T:NSCoding>(objects:[T]) -> NSArray {
        
        let dataArray = objects.map({ value in return NSKeyedArchiver.archivedDataWithRootObject(value)})
        
        let encodedArray = NSMutableArray()
        
        for encodedObject in dataArray { encodedArray.addObject(encodedObject) }
        return encodedArray as NSArray
    }
    
    static func convertNSArrayWithDataToSwiftArray(encodedObjects:NSArray) throws -> [AnyObject] {
        
        var objectList = [AnyObject]()
        for encodedObject in encodedObjects {
            
            guard let encodedObjectData = encodedObject as? NSData,
            unarchivedData = NSKeyedUnarchiver.unarchiveObjectWithData(encodedObjectData) else {
                throw Error.ErrorWithMsg(errorMsg: "Could not convert NSArray to Swift Array")
            }
            
            objectList.append(unarchivedData)
        }
        
        return objectList
    }
    
    
    
}