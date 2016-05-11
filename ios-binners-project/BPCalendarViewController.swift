//
//  BPCalendarViewController.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 3/11/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit

class BPCalendarViewController: UIViewController {
    
    var monthView: MRMonthView!
    var pickup:BPPickup?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        self.view.backgroundColor = UIColor.binnersGrayBackgroundColor()
        
        let originY = self.navigationController!.navigationBar.frame.size.height
        
        monthView = MRMonthView(frame: CGRectMake(
            self.view.frame.origin.x + (self.view.frame.size.width * 0.05),
            originY + (self.view.frame.size.height * 0.1),
            self.view.frame.size.width * 0.9,
            self.view.frame.size.height * 0.80))
        
        self.view.addSubview(monthView!)
        monthView.buttonsArrowColor = UIColor.binnersGreenColor()
        
        
        let descriptionLabel = UILabel(frame: CGRectMake(
            self.view.frame.origin.x + (self.view.frame.size.width * 0.05),
            originY,
            self.view.frame.size.width * 0.9,
            self.view.frame.size.height * 0.2))
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.boldSystemFontOfSize(12.0)
        descriptionLabel.text = "Please provide your preferred date for a pick-up."
        descriptionLabel.textAlignment = .Center
        
        self.view.addSubview(descriptionLabel)


    }
    
    func setupNavigationBar() {
        
        let buttonRight = UIBarButtonItem(title: "Next", style: .Done, target: self, action: "checkmarkButtonClicked")
        buttonRight.setTitleTextAttributes([NSFontAttributeName:UIFont.binnersFontWithSize(16)!], forState: .Normal)
        buttonRight.tintColor = UIColor.whiteColor()
        let buttonLeft = UIBarButtonItem(title: "✘", style: .Done, target: self, action: "cancelButtonClicked")
        buttonLeft.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = buttonLeft
        self.navigationItem.rightBarButtonItem = buttonRight
        self.navigationController?.navigationBar.barTintColor = UIColor.binnersGreenColor()
        self.title = "Date"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        UINavigationBar.appearance().backIndicatorImage = UIImage()
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage()
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()

        
    }
    
    func cancelButtonClicked() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func checkmarkButtonClicked() {
        
        let calendarDate = self.monthView.date.changeHour(0).changeMinute(0)
        let todaysDate = NSDate().changeMinute(0).changeHour(0)
        
        if calendarDate.compare(todaysDate) == .OrderedAscending  {
            // month view's date is earlier than today's date
            BPMessageFactory.makeMessage(.ALERT, message: "You can't go back to the past, lol").show()
            
        } else {
            self.performSegueWithIdentifier("toClockSegue", sender: self)
        }
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "toClockSegue" {
            
            let destVC = segue.destinationViewController as! BPClockViewController
            pickup?.date = self.monthView.date
            destVC.pickup = self.pickup
        }
    }

}
