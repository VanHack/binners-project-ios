//
//  BPRatePickupViewController.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 9/2/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit
import HCSStarRatingView

class BPRatePickupViewController: UIViewController {
    
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var binnerLabel: UILabel!
    @IBOutlet weak var textFieldComment: UITextField!
    @IBOutlet weak var buttonSubmitReview: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var starView: HCSStarRatingView!
    @IBOutlet weak var labelPleaseComment: UILabel!
    
    var pickup: BPPickup!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        binnerLabel.enabled = false
        setupUI()
        setupView(forPickup: pickup)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupUI() {
        labelPleaseComment.adjustsFontSizeToFitWidth = true
    }
    
    func setupView(forPickup pickup: BPPickup) {
        labelDate.text = pickup.date.formattedDate(.date)
        labelTime.text = pickup.date.formattedDate(.time)
    }
    
    // MARK: Button Action
    
    @IBAction func buttonSubmitReviewClicked(sender: UIButton) {
        // code for submiting review here
    }

    @IBAction func buttonCancelClicked(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
