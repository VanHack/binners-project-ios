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
        
        let originY = self.navigationController!.navigationBar.frame.size.height
        
        monthView = MRMonthView(frame: CGRectMake(
            self.view.frame.origin.x,
            originY,
            self.view.frame.size.width,
            self.view.frame.size.height))
        
        self.view.addSubview(monthView!)
        monthView.buttonsArrowColor = UIColor.binnersGreenColor()

    }
    
    func setupNavigationBar() {
        
        let buttonRight = UIBarButtonItem(title: "Next", style: .Done, target: self, action: "checkmarkButtonClicked")
        buttonRight.setTitleTextAttributes([NSFontAttributeName:UIFont.binnersFontWithSize(16)!], forState: .Normal)
        buttonRight.tintColor = UIColor.whiteColor()
        
        self.navigationItem.rightBarButtonItem = buttonRight
        self.navigationController?.navigationBar.barTintColor = UIColor.binnersGreenColor()
        self.title = "Date"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
    }
    
    func checkmarkButtonClicked() {
        
        self.performSegueWithIdentifier("toClockSegue", sender: self)
   
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
