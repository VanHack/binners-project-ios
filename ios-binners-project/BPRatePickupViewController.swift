//
//  BPRatePickupViewController.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 9/2/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit

class BPRatePickupViewController: UIViewController {
    
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var binnerLabel: UILabel!
    @IBOutlet weak var textFieldComment: UITextField!
    @IBOutlet weak var buttonSubmitReview: UIButton!

    @IBOutlet weak var buttonCancel: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Button Action
    
    @IBAction func buttonSubmitReviewClicked(sender: UIButton) {
    }

    @IBAction func buttonCancelClicked(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
