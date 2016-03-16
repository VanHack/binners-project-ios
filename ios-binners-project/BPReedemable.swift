//
//  BPReedemable.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 3/14/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit

class BPReedemable: NSObject {
    
    var quantity:String!
    var picture:UIImage!
    
    
    init(quantity:String) {
        
        self.quantity = quantity
    }
    
    init(picture:UIImage) {
        
        self.picture = picture
    }

}
