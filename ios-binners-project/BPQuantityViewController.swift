//
//  BPQuantityPageViewController.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 3/15/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit

enum QuantitySelection {
    case Nothing
    case Photo
    case Number
}

class BPQuantityViewController:  UIViewController {

    var pickup:BPPickup?
    var imagePicker:UIImagePickerController!
    var valuePicker:UIPickerView!
    var values = [
        "15 - 25 (About 2 grocery bags)",
        "26 - 35 (About 4 grocery bags)",
        "36 - 50 (About 1/2 garbage bag)",
        "51+ (About 1 black garbage bag)"]
    var quantitySelection:QuantitySelection = .Nothing
    @IBOutlet weak var quantityButton: UIButton!
    @IBOutlet weak var takeAPictureButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.binnersGrayBackgroundColor()
        setupNavigationBar()
        setupValuePicker()
        setupButtons()
        
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(BPQuantityViewController.dismissPicker))
        self.view.addGestureRecognizer(gesture)
    }
    
    func dismissPicker() {
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseInOut, animations: {
            
            var frame = self.valuePicker.frame
            frame.origin.y = self.view.frame.size.height
            self.valuePicker.frame = frame
            
            
            }, completion:{
                value in
                
                self.valuePicker.removeFromSuperview()

        })
    }
    
    func setupValuePicker() {
        
        valuePicker = UIPickerView(frame: CGRectMake(
            self.view.frame.origin.x,
            self.view.frame.size.height,
            self.view.frame.size.width,
            self.view.frame.size.height * 0.33
            ))
        
        valuePicker.backgroundColor = UIColor.whiteColor()
        valuePicker.delegate = self
        valuePicker.dataSource = self
    }
    
    func setupButtons() {
        
        quantityButton.backgroundColor = UIColor.whiteColor()
        quantityButton.addTarget(self, action: #selector(BPQuantityViewController.openValuePicker), forControlEvents: .TouchUpInside)
        quantityButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        takeAPictureButton.backgroundColor = UIColor.whiteColor()
        takeAPictureButton.addTarget(self, action: #selector(BPQuantityViewController.openCamera), forControlEvents: .TouchUpInside)
        
    }
    
    func openValuePicker() {
        
        self.view.addSubview(self.valuePicker)
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseInOut, animations: {
            
            
            var frame = self.valuePicker.frame
            frame.origin.y = self.view.frame.size.height - self.view.frame.size.height * 0.33
            self.valuePicker.frame = frame
            
            }, completion: nil)
        
    }
    
    func openCamera() {
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        self.presentViewController(imagePicker, animated: true, completion: nil)

    }
    
    func setupNavigationBar() {
        
        let buttonRight = UIBarButtonItem(title: "Next", style: .Done, target: self, action: #selector(BPQuantityViewController.nextButtonClicked))
        buttonRight.setTitleTextAttributes([NSFontAttributeName:UIFont.binnersFontWithSize(16)!], forState: .Normal)
        buttonRight.tintColor = UIColor.whiteColor()
        
        self.navigationItem.rightBarButtonItem = buttonRight
        self.navigationController?.navigationBar.barTintColor = UIColor.binnersGreenColor()
        self.title = "Quantity"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
    }
    
    func nextButtonClicked() {
        
        guard quantitySelection != .Nothing else {
            
            BPMessageFactory.makeMessage(.ERROR, message: "You must select a number of items or a photo").show()
            return
        }
        
        var reedemable:BPReedemable!
        
        if quantitySelection == .Photo {
            
             reedemable = BPReedemable(picture: self.takeAPictureButton!.imageView!.image!)
        }
        else {
            
             reedemable = BPReedemable(quantity: self.quantityButton!.titleLabel!.text!)
        }
        
        self.pickup!.reedemable = reedemable
        self.performSegueWithIdentifier("additionalNotesSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "additionalNotesSegue" {
            let destVc = segue.destinationViewController as! BPAdditionalNotesController
            destVc.pickup = self.pickup
        } else {
            let destVc = segue.destinationViewController as! BPReviewPickupViewController
            destVc.pickup = self.pickup
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension BPQuantityViewController : UIImagePickerControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
         let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        takeAPictureButton.imageView!.contentMode = .ScaleAspectFill
        takeAPictureButton.setImage(image, forState: .Normal)
        self.quantityButton.setTitle(nil, forState: .Normal)
        quantitySelection = .Photo
    }

}
extension BPQuantityViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let title = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        self.quantityButton.setTitle(title!, forState: .Normal)
        takeAPictureButton.setImage(nil, forState: .Normal)
        quantitySelection = .Number
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return values[row]
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return values.count
    }
    
}

extension BPQuantityViewController : UINavigationControllerDelegate {
    
}