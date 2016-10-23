//
//  BPAdditionalNotesController.swift
//  ios-binners-project
//
//  Created by Thais on 22/03/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.

import UIKit

class BPAdditionalNotesController: UIViewController, UITextViewDelegate  {

    @IBOutlet weak var boldLabel: UILabel!
    @IBOutlet weak var txtViewAddNote: UITextView!
    var pickup: BPPickup?
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
        
        let buttonRight = UIBarButtonItem(
            title: "Next",
            style: .done,
            target: self,
            action: #selector(BPAdditionalNotesController.nextButtonClicked))
        buttonRight.tintColor = UIColor.white
        
        self.navigationItem.rightBarButtonItem = buttonRight
        buttonRight.setTitleTextAttributes(
            [NSFontAttributeName:UIFont.binnersFontWithSize(16)!],
            for: UIControlState())
        self.title = "Additional Notes"
        
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtViewAddNote.textColor == UIColor.lightGray {
            txtViewAddNote.text = nil
            txtViewAddNote.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textViewPlaceHolder()
        }
    }
    
    func nextButtonClicked() {
        if txtViewAddNote.textColor == UIColor.lightGray {
            
            BPMessageFactory.makeMessage(.error,
                                         message: "You must provide instructions for the binner").show()
        } else {
            self.performSegue(withIdentifier: "reviewPickupSegue", sender: self)

        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "reviewPickupSegue" {
            
            guard let destVC = segue.destination
                as? BPReviewPickupViewController else {
                fatalError("Could not convert destination vc")
            }
            
            pickup?.instructions = self.txtViewAddNote.text
            destVC.pickup = self.pickup
        }
    }
    
    func cancelButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    func textViewPlaceHolder() {
        txtViewAddNote.text = "E.g. Hey! I've left my bottles and cans for you by the recycling bin in the alleyway."
        txtViewAddNote.textColor = UIColor.lightGray
        txtViewAddNote.delegate = self
    }
    
    //Fix keyboard click
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // for textView
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                                          replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

}
