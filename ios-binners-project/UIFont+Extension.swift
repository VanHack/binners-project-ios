//
//  UIFont+Extension.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 2/3/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.

import Foundation
import UIKit

extension UIFont {
    
    static func binnersFont() -> UIFont? {
        
        return UIFont(name: "Oxygen",size: 16)
    }
    
    static func binnersFontWithSize(_ size:CGFloat) -> UIFont? {
        
        return UIFont(name: "Oxygen",size: size)
    }
    
    
    static func binnerFontName() -> String {
        return "Oxygen"
    }
}
