//
//  BPCalendarViewController.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 3/11/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.


import UIKit

class BPCalendarViewController: UIViewController {
    
    var monthView: MRMonthView!
    var pickup:BPPickup?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        self.view.backgroundColor = UIColor.binnersGrayBackgroundColor()
        
        let originY = self.navigationController!.navigationBar.frame.size.height
        
        monthView = MRMonthView(frame: CGRect(
            x: self.view.frame.origin.x + (self.view.frame.size.width * 0.05),
            y: originY + (self.view.frame.size.height * 0.1),
            width: self.view.frame.size.width * 0.9,
            height: self.view.frame.size.height * 0.80))
        
        self.view.addSubview(monthView!)
        monthView.buttonsArrowColor = UIColor.binnersGreenColor()
        
        
        let descriptionLabel = UILabel(frame: CGRect(
            x: self.view.frame.origin.x + (self.view.frame.size.width * 0.05),
            y: originY,
            width: self.view.frame.size.width * 0.9,
            height: self.view.frame.size.height * 0.2))
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
        descriptionLabel.text = "Please provide your preferred date for a pick-up."
        descriptionLabel.textAlignment = .center
        
        self.view.addSubview(descriptionLabel)


    }
    
    func setupNavigationBar() {
        
        let buttonRight = UIBarButtonItem(
            title: "Next",
            style: .done,
            target: self,
            action: #selector(BPCalendarViewController.checkmarkButtonClicked))
        buttonRight.setTitleTextAttributes(
            [NSFontAttributeName:UIFont.binnersFontWithSize(16)!],
            for: UIControlState())
        buttonRight.tintColor = UIColor.white
        let buttonLeft = UIBarButtonItem(
            barButtonSystemItem: .stop,
            target: self,
            action: #selector(BPCalendarViewController.cancelButtonClicked))
        
        buttonLeft.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = buttonLeft
        self.navigationItem.rightBarButtonItem = buttonRight
        self.title = "Date"
        
    }
    
    func cancelButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func checkmarkButtonClicked() {
        
        let calendarDate = self.monthView.date.changeHour(0).changeMinute(0)
        let todaysDate = Date().changeMinute(0).changeHour(0)
        
        if calendarDate.compare(todaysDate) == .orderedAscending  {
            // month view's date is earlier than today's date
            BPMessageFactory.makeMessage(.alert, message: "You can't go back to the past, lol").show()
            
        } else {
            self.performSegue(withIdentifier: "toClockSegue", sender: self)
        }
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "toClockSegue" {
            
            guard let destVC = segue.destination as? BPClockViewController else {
                fatalError("could not convert view controller")
            }
            pickup?.date = self.monthView.date
            destVC.pickup = self.pickup
        }
    }

}
