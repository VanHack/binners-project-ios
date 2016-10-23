//
//  BPActionBar.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 13/10/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit

@objc protocol BPActionBar: class {
 
    @objc optional func configureActionBar()
    @objc optional func dismiss()
    func barTitle() -> String
    func showCloseButton() -> Bool
    func rightBarButtonItem() -> UIBarButtonItem?
}

extension BPActionBar where Self: UIViewController {
    
//    func configureActionBar() {
//        
//        if showCloseButton() {
//            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissView))
//        }
//
//        self.navigationItem.rightBarButtonItem = rightBarButtonItem()
//        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
//        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
//        
//        
//        if let binnersFont = UIFont.binnersFontWithSize(16) {
//            self.navigationItem.leftBarButtonItem?.setTitleTextAttributes(
//                [NSFontAttributeName:binnersFont],
//                for: UIControlState())
//            self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(
//                [NSFontAttributeName:binnersFont],
//                for: UIControlState())
//        }
//        
//        self.title = barTitle()
//    }
    
    
    func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
}
