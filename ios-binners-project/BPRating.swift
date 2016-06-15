//
//  BPRating.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 6/13/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import Foundation

struct BPRating {
    
    var comment:String?
    var rating:Int {
        
        set {
            if newValue > 5 {
                rating = 5
            } else if newValue < 1 {
                rating = 1
            } else {
                rating = newValue
            }
        }
        get {
            return self.rating
        }
    }
    
}