//
//  BPQuantityPageViewController.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 3/15/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.

import UIKit

enum QuantitySelection {
    case nothing
    case photo
    case number
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
    var quantitySelection:QuantitySelection = .nothing
    @IBOutlet weak var quantityButton: UIButton!
    @IBOutlet weak var takeAPictureButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.binnersGrayBackgroundColor()
        setupNavigationBar()
        setupValuePicker()
        setupButtons()
        
        
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(BPQuantityViewController.dismissPicker))
        self.view.addGestureRecognizer(gesture)
    }
    
    func dismissPicker() {
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions(), animations: {
            
            var frame = self.valuePicker.frame
            frame.origin.y = self.view.frame.size.height
            self.valuePicker.frame = frame
            
            
            }, completion:{
                value in
                
                self.valuePicker.removeFromSuperview()

        })
    }
    
    func setupValuePicker() {
        
        valuePicker = UIPickerView(frame: CGRect(
            x: self.view.frame.origin.x,
            y: self.view.frame.size.height,
            width: self.view.frame.size.width,
            height: self.view.frame.size.height * 0.33
            ))
        
        valuePicker.backgroundColor = UIColor.white
        valuePicker.delegate = self
        valuePicker.dataSource = self
    }
    
    func setupButtons() {
        
        quantityButton.backgroundColor = UIColor.white
        quantityButton.addTarget(self,
                                 action: #selector(BPQuantityViewController.openValuePicker),
                                 for: .touchUpInside)
        quantityButton.setTitleColor(UIColor.black, for: UIControlState())
        takeAPictureButton.backgroundColor = UIColor.white
        takeAPictureButton.addTarget(self,
                                     action: #selector(BPQuantityViewController.openCamera),
                                     for: .touchUpInside)
        
    }
    
    func openValuePicker() {
        
        self.view.addSubview(self.valuePicker)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions(), animations: {
            
            
            var frame = self.valuePicker.frame
            frame.origin.y = self.view.frame.size.height - self.view.frame.size.height * 0.33
            self.valuePicker.frame = frame
            
            }, completion: nil)
        
    }
    
    func openCamera() {
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        self.present(imagePicker, animated: true, completion: nil)

    }
    
    func setupNavigationBar() {
        
        let buttonRight = UIBarButtonItem(title: "Next",
                                          style: .done,
                                          target: self,
                                          action: #selector(BPQuantityViewController.nextButtonClicked))
        buttonRight.setTitleTextAttributes(
            [NSFontAttributeName:UIFont.binnersFontWithSize(16)!],
            for: UIControlState())
        buttonRight.tintColor = UIColor.white
        
        self.navigationItem.rightBarButtonItem = buttonRight
        self.title = "Quantity"
        
    }
    
    func nextButtonClicked() {
        
        guard quantitySelection != .nothing else {
            
            BPMessageFactory.makeMessage(.error,
                                         message: "You must select a number of items or a photo").show()
            return
        }
        
        var reedemable:BPReedemable!
        
        if quantitySelection == .photo {
            
             reedemable = BPReedemable(picture: self.takeAPictureButton!.imageView!.image!)
        } else {
            
             reedemable = BPReedemable(quantity: self.quantityButton!.titleLabel!.text!)
        }
        
        self.pickup!.reedemable = reedemable
        self.performSegue(withIdentifier: "additionalNotesSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "additionalNotesSegue" {
            let destVc = segue.destination as? BPAdditionalNotesController
            destVc!.pickup = self.pickup
        } else {
            let destVc = segue.destination as? BPReviewPickupViewController
            destVc!.pickup = self.pickup
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension BPQuantityViewController : UIImagePickerControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : Any]) {
        
        imagePicker.dismiss(animated: true, completion: nil)
         let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        takeAPictureButton.imageView!.contentMode = .scaleAspectFill
        takeAPictureButton.setImage(image, for: UIControlState())
        self.quantityButton.setTitle(nil, for: UIControlState())
        quantitySelection = .photo
    }

}
extension BPQuantityViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let title = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        self.quantityButton.setTitle(title!, for: UIControlState())
        takeAPictureButton.setImage(nil, for: UIControlState())
        quantitySelection = .number
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return values[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return values.count
    }
    
}

extension BPQuantityViewController : UINavigationControllerDelegate {
    
}
