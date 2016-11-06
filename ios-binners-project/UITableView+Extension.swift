//
//  UITableView+Extension.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 05/11/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import Foundation

extension UITableView {
    
    func adjustHeightOfTableView() {
        
        var height = self.contentSize.height
        let maxHeight = self.superview!.frame.size.height - self.frame.origin.y
        
        if height > maxHeight {
            height = maxHeight
        }
        
        
        UIView.animate(withDuration: 0.25, animations: {
            
            var frame = self.frame
            frame.size.height = height
            self.frame = frame
            
        })
    }
}
