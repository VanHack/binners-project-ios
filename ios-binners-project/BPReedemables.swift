//
//  BPReedemable.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 3/14/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit

class BPReedemables: NSObject {
    
    var quantity:Int!
    var pictures:[UIImage]!
    
    
    init(quantity:Int) {
        
        self.quantity = quantity
    }
    
    init(pictures:[UIImage]) {
        
        self.pictures = pictures
    }

}
