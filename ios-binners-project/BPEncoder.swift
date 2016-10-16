//
//  BPEncoder.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 6/14/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import Foundation

class BPEncoder {
    
    static func convertSwiftArrayToNSArrayWithData<T where T:NSCoding>(objects:[T]) -> NSArray {
        
        let dataArray = objects.map({ value in return NSKeyedArchiver.archivedDataWithRootObject(value)})
        
        let encodedArray = NSMutableArray()
        
        for encodedObject in dataArray { encodedArray.addObject(encodedObject) }
        return encodedArray as NSArray
    }
    
    static func convertNSArrayWithDataToSwiftArray(encodedObjects:NSArray) -> [AnyObject]? {
        
        var objectList = [AnyObject]()
        for encodedObject in encodedObjects {
            
            guard let
                encodedObjectData = encodedObject as? NSData,
                unarchivedData = NSKeyedUnarchiver.unarchiveObjectWithData(encodedObjectData) else {
                return nil
            }
            
            objectList.append(unarchivedData)
        }
        
        return objectList
    }
    
    
    
}