//
//  BPEncoder.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 6/14/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import Foundation

class BPEncoder {
    
    static func convertSwiftArrayToNSArrayWithData<T>(_ objects:[T]) -> NSArray where T:NSCoding {
        
        let dataArray = objects.map({ value in return NSKeyedArchiver.archivedData(withRootObject: value)})
        
        let encodedArray = NSMutableArray()
        
        for encodedObject in dataArray { encodedArray.add(encodedObject) }
        return encodedArray as NSArray
    }
    
    static func convertNSArrayWithDataToSwiftArray(_ encodedObjects:NSArray) -> [AnyObject]? {
        
        var objectList = [AnyObject]()
        for encodedObject in encodedObjects {
            
            guard let
                encodedObjectData = encodedObject as? Data,
                let unarchivedData = NSKeyedUnarchiver.unarchiveObject(with: encodedObjectData) else {
                return nil
            }
            
            objectList.append(unarchivedData as AnyObject)
        }
        
        return objectList
    }
    
    
    
}
