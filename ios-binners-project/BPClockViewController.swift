//
//  BPClockViewController.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 3/1/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.


import UIKit

enum TimeMode {
    case hours
    case minutes
}

enum TimePeriod {
    case am
    case pm
}


class BPClockViewController: CloseButtonViewController {

    @IBOutlet weak var labelAmPm: UILabel!
    @IBOutlet weak var labelTwoDots: UILabel!
    @IBOutlet weak var minutesButton: UIButton!
    @IBOutlet weak var hoursButton: UIButton!
    @IBOutlet weak var pmButton: UIButton!
    @IBOutlet weak var amButton: UIButton!
    @IBOutlet weak var clockView: BEMAnalogClockView!
    var viewInitialized = false
    var isPresenting = false
    
    @IBOutlet weak var labelDescription: UILabel!
    
    var timeMode: TimeMode = .hours
    var hours: Int = 0
    var minutes: Int = 0
    var pickup: BPPickup?
    var timePeriod: TimePeriod = .am
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.view.backgroundColor = UIColor.binnersGrayBackgroundColor()
        self.labelDescription.sizeToFit()
        self.labelDescription.adjustsFontSizeToFitWidth = true
        
        setupNavigationBar()
        configureClock()
        configureButtonsAndLabels()
        hideCloseButton = !isPresenting
    }
    
    func checkIfNowIsPMorAM() {
        
        let hour = Date().getHour()
        
        if hour < 12 {
            aMButtonClicked()
            
        } else {
            pMButtonClicked()
        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        
        if !viewInitialized {
            checkIfNowIsPMorAM()
            viewInitialized = true
        }
        
    }
    
    func setupNavigationBar() {
        
        let buttonRight = UIBarButtonItem(
            title: "Next",
            style: .done,
            target: self,
            action: #selector(BPClockViewController.checkmarkButtonClicked))
        buttonRight.setTitleTextAttributes(
            [NSFontAttributeName:UIFont.binnersFontWithSize(16)!],
            for: UIControlState())
        buttonRight.tintColor = UIColor.white
        
        self.navigationItem.rightBarButtonItem = buttonRight
        self.title = "Time"
        
    }
    
    func checkmarkButtonClicked() {
        
        var hours = Int(self.hoursButton.titleLabel!.text!)!
        let minutes = Int(self.minutesButton.titleLabel!.text!)!

        if timePeriod == .pm {
            hours += 12
        }
        
        let pickupDate = self.pickup?.date.changeHour(hours - 3).changeMinute(minutes)
        
        if(pickupDate!.compare(Date()) == .orderedAscending) { // hour on clock is earlier than hour now
            BPMessageFactory.makeMessage(
                .alert,
                message: "You have to schedule the pickup for at least X hours before it happens").show()
            
        } else {
            self.pickup?.date = self.pickup?.date.changeHour(hours)
            self.pickup?.date = self.pickup?.date.changeMinute(minutes)
            self.performSegue(withIdentifier: "quantitySegue", sender: self)
        }
        
        
        
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
        amButton.tintColor = UIColor.white
        
        pmButton.backgroundColor = UIColor.clear
        pmButton.tintColor = UIColor.binnersGreenColor()
        labelAmPm.text = "am"
        
    }
    
    func pMButtonClicked() {
        
        timePeriod = .pm
        pmButton.layer.masksToBounds = true
        pmButton.layer.cornerRadius = amButton.layer.bounds.height / 2.0
        pmButton.backgroundColor = UIColor.binnersGreenColor()
        pmButton.tintColor = UIColor.white
        
        amButton.backgroundColor = UIColor.clear
        amButton.tintColor = UIColor.binnersGreenColor()
        labelAmPm.text = "pm"


    }
    
    func configureButtonsAndLabels() {
        
        minutesButton.tintColor = UIColor.binnersGreenColor()
        hoursButton.tintColor   = UIColor.binnersGreenColor()
        labelTwoDots.textColor  = UIColor.binnersGreenColor()
        amButton.tintColor      = UIColor.binnersGreenColor()
        pmButton.tintColor      = UIColor.binnersGreenColor()
        
        minutesButton.titleLabel?.font = UIFont.systemFont(ofSize: 50)
        hoursButton.titleLabel?.font   = UIFont.systemFont(ofSize: 50)
        labelTwoDots.font              = UIFont.systemFont(ofSize: 50)
        
        if timeMode == .hours {
            minutesButton.alpha = 0.5
        } else {
            hoursButton.alpha = 0.5
        }

        amButton.addTarget(
            self,
            action: #selector(BPClockViewController.aMButtonClicked),
            for: .touchUpInside)
        pmButton.addTarget(
            self,
            action: #selector(BPClockViewController.pMButtonClicked),
            for: .touchUpInside)

        minutesButton.addTarget(
            self,
            action: #selector(BPClockViewController.minuteButtonClicked),
            for: .touchUpInside)
        hoursButton.addTarget(
            self,
            action: #selector(BPClockViewController.hourButtonClicked),
            for: .touchUpInside)
        
        labelAmPm.textColor = UIColor.binnersGreenColor()
        labelAmPm.alpha = 0.5
        
        
        self.view.bringSubview(toFront: amButton)
        self.view.bringSubview(toFront: pmButton)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "quantitySegue" {
            
            guard let destVc = segue.destination as? BPQuantityViewController else {
                fatalError("Could not convert view controller")
            }
            
            destVc.pickup = pickup
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension BPClockViewController :BEMAnalogClockDelegate {
    
    func currentTime(onClock clock: BEMAnalogClockView!, hours: String ,minutes: String , seconds: String ) {
        
        if timeMode == .hours {
            
            if clock.hours < 10 {
                hoursButton.setTitle("0\(hours)", for: UIControlState())
                
            } else {
                hoursButton.setTitle("\(hours)", for: UIControlState())
                
            }
            
        } else {
            
            if clock.minutes < 10 {
                minutesButton.setTitle("0\(minutes)", for: UIControlState())
            } else {
                minutesButton.setTitle("\(minutes)", for: UIControlState())
            }
        }
        
       self.hours = clock.hours
       self.minutes = clock.minutes
        
    }
    
    
    func clockDidFinishLoading(_ clock: BEMAnalogClockView!) {
        
        if clock.minutes < 10 {
            minutesButton.setTitle("0\(clock.minutes)", for: UIControlState())
        } else {
            minutesButton.setTitle("\(clock.minutes)", for: UIControlState())
        }
        
        if clock.hours < 10 {
            hoursButton.setTitle("0\(clock.hours)", for: UIControlState())

        } else {
            hoursButton.setTitle("\(clock.hours)", for: UIControlState())

        }
        self.hours = clock.hours
        self.minutes = clock.minutes
        clockView.currentTime = false
        
        
    }
}
