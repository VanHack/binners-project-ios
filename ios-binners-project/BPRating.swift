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
    var rating:Int
    
    
    init(comment:String?, rating:Int){
        self.comment = comment
        if rating > 5 {
            self.rating = 5
        }
        else if rating < 1 {
            self.rating = 1
        }
        else {
            self.rating = rating
        }
    }
    
}
