//
//  BPActionBar.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 13/10/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit

@objc protocol BPActionBar: class {
 
    optional func configureActionBar()
    optional func dismiss()
    func barTitle() -> String
    func showCloseButton() -> Bool
    func rightBarButtonItem() -> UIBarButtonItem?
}

extension BPActionBar where Self: UIViewController {
    
    func configureActionBar() {
        
        if showCloseButton() {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: #selector(dismiss))
        }

        self.navigationItem.rightBarButtonItem = rightBarButtonItem()
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
        
        
        if let binnersFont = UIFont.binnersFontWithSize(16) {
            self.navigationItem.leftBarButtonItem?.setTitleTextAttributes(
                [NSFontAttributeName:binnersFont],
                forState: .Normal)
            self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(
                [NSFontAttributeName:binnersFont],
                forState: .Normal)
        }
        
        self.title = barTitle()
    }
    
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}