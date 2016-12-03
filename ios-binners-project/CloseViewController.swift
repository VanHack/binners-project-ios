//
//  CloseModalViewController.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 03/12/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import Foundation

class CloseButtonViewController: UIViewController {
    
    var hideCloseButton : Bool = false {
        didSet {
            setCloseButtonHidden(hideCloseButton)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideCloseButton = false
    }
    
    func setCloseButtonHidden(_ hidden: Bool) {
        
        if self.navigationController == nil {
            
            if !hidden {
                let closeButton = UIButton(frame: CGRect(x:0, y:0, width: 50, height: 50))
                closeButton.setImage(UIImage(named: "delete_sign"), for: .normal)
                closeButton.addTarget(self, action: #selector(CloseButtonViewController.dismissVC), for: .touchUpInside)
                self.view.addSubview(closeButton)
            }
            
        } else {
            if hidden { self.navigationItem.leftBarButtonItem = nil } else {
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(CloseButtonViewController.dismissVC))
            }
            
        }
        
    }
    
    func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }

}
