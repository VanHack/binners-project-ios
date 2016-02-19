//
//  UIFont+Extension.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 2/3/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    static func binnersFont() ->UIFont? {
        
        return UIFont(name: "Oxygen Regular",size: 16)
    }
    
    static func binnerFontName() ->String
    {
        return "Oxygen Regular"
    }
}