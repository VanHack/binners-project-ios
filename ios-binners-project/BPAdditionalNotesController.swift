//
//  BPAdditionalNotesController.swift
//  ios-binners-project
//
//  Created by Thais on 22/03/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit

class BPAdditionalNotesController: UIViewController,UITextViewDelegate  {

    @IBOutlet weak var boldLabel: UILabel!
    @IBOutlet weak var txtViewAddNote: UITextView!
    var pickup:BPPickup?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        textViewPlaceHolder()
        //boldLabel.font = UIFont.binnersFont(13)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavigationBar() {
        
        let buttonRight = UIBarButtonItem(title: "Next", style: .Done, target: self, action: #selector(BPAdditionalNotesController.nextButtonClicked))
        buttonRight.tintColor = UIColor.whiteColor()
        
        self.navigationItem.rightBarButtonItem = buttonRight
        self.navigationController?.navigationBar.barTintColor = UIColor.binnersGreenColor()
        buttonRight.setTitleTextAttributes([NSFontAttributeName:UIFont.binnersFontWithSize(16)!], forState: .Normal)
        self.title = "Additional Notes"
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
    }
    func textViewDidBeginEditing(textView: UITextView) {
        if txtViewAddNote.textColor == UIColor.lightGrayColor() {
            txtViewAddNote.text = nil
            txtViewAddNote.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textViewPlaceHolder()
        }
    }
    
    func nextButtonClicked() {
        if txtViewAddNote.textColor == UIColor.lightGrayColor(){
            
            BPMessageFactory.makeMessage(.ERROR, message: "You must provide instructions for the binner").show()
        }
        else{
            
            self.performSegueWithIdentifier("reviewPickupSegue", sender: self)

        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "reviewPickupSegue" {
            
            let destVC = segue.destinationViewController as! BPReviewPickupViewController
            pickup?.instructions = self.txtViewAddNote.text
            destVC.pickup = self.pickup
        }
    }
    
    func cancelButtonClicked() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func textViewPlaceHolder(){
        txtViewAddNote.text = "E.g. Hey! I've left my bottles and cans for you by the recycling bin in the alleyway."
        txtViewAddNote.textColor = UIColor.lightGrayColor()
        txtViewAddNote.delegate = self
    }
    
    //Fix keyboard click
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    // for textView
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

}
