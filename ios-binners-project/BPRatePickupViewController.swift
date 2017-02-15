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
    @IBOutlet weak var starView: HCSStarRatingView!
    @IBOutlet weak var labelPleaseComment: UILabel!
    
    var pickup: BPPickup!
    var rateViewModel = BPRatePickupViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BPLoginViewController.dismissKeyboard))
        
        self.view.backgroundColor = UIColor.binnersGrayBackgroundColor()
        self.rateViewModel.rateDelegate = self
        //binnerLabel.isEnabled = false
        setupUI()
        setupView(forPickup: pickup)
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupNavigationBar() {
        
        let buttonLeft = UIBarButtonItem(
            barButtonSystemItem: .stop,
            target: self,
            action: #selector(self.cancelButtonClicked))
        
        buttonLeft.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = buttonLeft
        self.title = "Rate The Pickup"
    }
    
    func cancelButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupUI() {
        labelPleaseComment.adjustsFontSizeToFitWidth = true
        starView.backgroundColor = UIColor.binnersGrayBackgroundColor()
        starView.tintColor = UIColor.binnersGreenColor()
        starView.maximumValue = 5
        starView.minimumValue = 1.0
        buttonSubmitReview.backgroundColor = UIColor.binnersGreenColor()
        buttonSubmitReview.tintColor = UIColor.white
    }
    
    func makeItReadOnly(isEnabled: Bool){
        if isEnabled {
            self.buttonSubmitReview.isEnabled = false
            self.starView.isEnabled = false
            self.textFieldComment.isEnabled = false
        }
        else {
            self.buttonSubmitReview.isEnabled = true
            self.starView.isEnabled = true
            self.textFieldComment.isEnabled = true
        }
    }
    
    func setupView(forPickup pickup: BPPickup) {
        labelDate.text = pickup.date.formattedDate(.date)
        labelTime.text = pickup.date.formattedDate(.time)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // MARK: Button Action
    
    @IBAction func buttonSubmitReviewClicked(_ sender: UIButton) {
        if Int(starView.value) < 1 || Int(starView.value) > 5 {
            BPMessageFactory.makeMessage(.error, message: "You must select a star").show()
        }
        else if textFieldComment.text! == "" {
            BPMessageFactory.makeMessage(.error, message: "You must enter a comment").show()
        }
        else{
            self.makeItReadOnly(isEnabled: true)
            
            do{
                try self.rateViewModel.ratePickup(pickupID: pickup.id, rate: Int(starView.value), comment: textFieldComment.text!)
            } catch let error as NSError {
                BPMessageFactory.makeMessage(.error, message: error.localizedDescription).show()
            }
        }
    }
}

extension BPRatePickupViewController : RateDelegate {
    func didFinishRatingPickup(_ success: Bool, errorMsg: String?) {
        self.makeItReadOnly(isEnabled: false)

        switch success {
        case true: self.dismiss(animated: true, completion: nil)
        default: BPMessageFactory.makeMessage(.error, message: errorMsg!).show()
        }
    }
}
