//
//  BPClockViewController.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 3/1/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit

enum TimeMode {
    case hours
    case minutes
}

enum TimePeriod {
    case am
    case pm
}


class BPClockViewController: UIViewController {

    @IBOutlet weak var labelAmPm: UILabel!
    @IBOutlet weak var labelTwoDots: UILabel!
    @IBOutlet weak var minutesButton: UIButton!
    @IBOutlet weak var hoursButton: UIButton!
    @IBOutlet weak var pmButton: UIButton!
    @IBOutlet weak var amButton: UIButton!
    @IBOutlet weak var clockView: BEMAnalogClockView!
    var timeMode:TimeMode = .hours
    var hours:Int = 0
    var minutes:Int = 0
    var pickup:BPPickup?
    var timePeriod:TimePeriod = .am
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupNavigationBar()
        configureClock()
        configureButtonsAndLabels()
        checkIfNowIsPMorAM()
    }
    
    func checkIfNowIsPMorAM() {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let dateNow = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let comp = calendar.components([.Hour], fromDate: dateNow)
        let hour = comp.hour
        
        if hour < 12 {
            aMButtonClicked()
            
        } else {
            pMButtonClicked()
        }
        
        
    }
    
    func setupNavigationBar() {
        
        let buttonRight = UIBarButtonItem(title: "Next", style: .Done, target: self, action: "checkmarkButtonClicked")
        buttonRight.setTitleTextAttributes([NSFontAttributeName:UIFont.binnersFontWithSize(16)!], forState: .Normal)
        buttonRight.tintColor = UIColor.whiteColor()
        
        self.navigationItem.rightBarButtonItem = buttonRight
        self.navigationController?.navigationBar.barTintColor = UIColor.binnersGreenColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        

    }
    
    func cancelButtonClicked() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func checkmarkButtonClicked() {
        print("next one up is...")
        
        var hours = Int(self.hoursButton.titleLabel!.text!)!
        let minutes = Int(self.minutesButton.titleLabel!.text!)!

        if timePeriod == .pm {
            hours += 12
        }
        
        self.pickup?.date = self.pickup?.date.changeHour(hours)
        self.pickup?.date = self.pickup?.date.changeMinute(minutes)

        
    }
    
    func configureClock() {
        
        clockView.delegate = self
        clockView.enableDigit = true
        clockView.secondHandAlpha = 0.0
        clockView.currentTime = true
        clockView.setTimeViaTouch = true
        clockView.faceBackgroundColor = UIColor.binnersGreenColor()
        
        if timeMode == .hours {
            clockView.minuteHandAlpha = 0.0
        } else {
            clockView.hourHandAlpha = 0.0
        }
        

    }
    
    func aMButtonClicked() {
        
        timePeriod = .am
        amButton.layer.masksToBounds = true
        amButton.layer.cornerRadius = amButton.layer.bounds.height / 2.0
        amButton.backgroundColor = UIColor.binnersGreenColor()
        amButton.tintColor = UIColor.whiteColor()
        
        pmButton.backgroundColor = UIColor.clearColor()
        pmButton.tintColor = UIColor.binnersGreenColor()
        labelAmPm.text = "am"
        
    }
    
    func pMButtonClicked() {
        
        timePeriod = .pm
        pmButton.layer.masksToBounds = true
        pmButton.layer.cornerRadius = amButton.layer.bounds.height / 2.0
        pmButton.backgroundColor = UIColor.binnersGreenColor()
        pmButton.tintColor = UIColor.whiteColor()
        
        amButton.backgroundColor = UIColor.clearColor()
        amButton.tintColor = UIColor.binnersGreenColor()
        labelAmPm.text = "pm"


    }
    
    func configureButtonsAndLabels() {
        
        minutesButton.tintColor = UIColor.binnersGreenColor()
        hoursButton.tintColor   = UIColor.binnersGreenColor()
        labelTwoDots.textColor  = UIColor.binnersGreenColor()
        amButton.tintColor      = UIColor.binnersGreenColor()
        pmButton.tintColor      = UIColor.binnersGreenColor()
        
        minutesButton.titleLabel?.font = UIFont.systemFontOfSize(50)
        hoursButton.titleLabel?.font   = UIFont.systemFontOfSize(50)
        labelTwoDots.font              = UIFont.systemFontOfSize(50)
        
        if timeMode == .hours {
            minutesButton.alpha = 0.5
        } else {
            hoursButton.alpha = 0.5
        }

        amButton.addTarget(self, action: "aMButtonClicked", forControlEvents: .TouchUpInside)
        pmButton.addTarget(self, action: "pMButtonClicked", forControlEvents: .TouchUpInside)

        minutesButton.addTarget(self, action: "minuteButtonClicked", forControlEvents: .TouchUpInside)
        hoursButton.addTarget(self, action: "hourButtonClicked", forControlEvents: .TouchUpInside)
        
        labelAmPm.textColor = UIColor.binnersGreenColor()
        labelAmPm.alpha = 0.5
    }
    
    func minuteButtonClicked() {
        
        minutesButton.alpha = 1.0
        hoursButton.alpha = 0.5
        clockView.hourHandAlpha = 0.0
        clockView.minuteHandAlpha = 1.0
        clockView.hourOrMinuteSelected = 1
        timeMode = .minutes
        clockView.reloadClock()
    }
    func hourButtonClicked() {
        
        hoursButton.alpha = 1.0
        minutesButton.alpha = 0.5
        clockView.minuteHandAlpha = 0.0
        clockView.hourHandAlpha = 1.0
        clockView.hourOrMinuteSelected = 0
        timeMode = .hours
        clockView.reloadClock()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension BPClockViewController :BEMAnalogClockDelegate {
    
    func currentTimeOnClock(clock: BEMAnalogClockView!, hours: String!,minutes: String!,seconds: String!) {
        
        if timeMode == .hours {
            
            if clock.hours < 10 {
                hoursButton.setTitle("0\(hours)", forState: .Normal)
                
            } else {
                hoursButton.setTitle("\(hours)", forState: .Normal)
                
            }
            
        } else {
            
            if clock.minutes < 10 {
                minutesButton.setTitle("0\(minutes)", forState: .Normal)
            } else {
                minutesButton.setTitle("\(minutes)", forState: .Normal)
            }
        }
        
       self.hours = clock.hours
       self.minutes = clock.minutes
        
        
    }
    
    
    func clockDidFinishLoading(clock: BEMAnalogClockView!) {
        
        if clock.minutes < 10 {
            minutesButton.setTitle("0\(clock.minutes)", forState: .Normal)
        } else {
            minutesButton.setTitle("\(clock.minutes)", forState: .Normal)
        }
        
        if clock.hours < 10 {
            hoursButton.setTitle("0\(clock.hours)", forState: .Normal)

        } else {
            hoursButton.setTitle("\(clock.hours)", forState: .Normal)

        }
        self.hours = clock.hours
        self.minutes = clock.minutes
        clockView.currentTime = false
        
        
    }
}
