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
        

        // Do any additional setup after loading the view.
    }
    
    func setupNavigationBar() {
        
        let buttonRight = UIBarButtonItem(title: "✔︎", style: .Done, target: self, action: "checkmarkButtonClicked")
        buttonRight.tintColor = UIColor.whiteColor()
        
        self.navigationItem.rightBarButtonItem = buttonRight
        self.navigationController?.navigationBar.barTintColor = UIColor.binnersGreenColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        let buttonLeft = UIBarButtonItem(title: "✘", style: .Done, target: self, action: "cancelButtonClicked")
        buttonLeft.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = buttonLeft
        
    }
    
    func checkmarkButtonClicked() {
        
        self.performSegueWithIdentifier("toClockSegue", sender: self)
   
    }
    func cancelButtonClicked() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
