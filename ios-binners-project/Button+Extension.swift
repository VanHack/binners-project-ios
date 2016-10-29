//
//  Button+Extension.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 29/10/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import Foundation

extension UIBarButtonItem {
    
    
    func configureBarButton() {
        
        if let font = UIFont.binnersFontWithSize(16) {
            self.setTitleTextAttributes( [NSFontAttributeName:font], for: UIControlState())
        }
        self.tintColor = UIColor.white
    }
    
}
