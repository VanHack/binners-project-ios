//
//  BPNavigationController.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 16/10/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit

class BPNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        
        UINavigationBar.appearance().backIndicatorImage = UIImage()
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage()
        
        self.navigationBar.barTintColor = UIColor.binnersGreenColor()
        self.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName : UIColor.whiteColor()]
    }
    
}
