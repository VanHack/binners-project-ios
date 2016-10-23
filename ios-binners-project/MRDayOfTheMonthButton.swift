//
//  MRDayOfTheMonthButton.swift
//  MRMonthCalendar
//
//  Created by Matheus Ruschel on 2/24/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.
//

import UIKit

class MRDayOfTheMonthButton: UIButton {

    var number:Int?
    var day_dayOfTheWeek_Month_Year:(String,String,String,String)? {
        
        didSet {
            self.setTitle(day_dayOfTheWeek_Month_Year!.0, for: UIControlState())
        }
        
    }
    
    func setSelectedDay(_ color:UIColor) {
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.layer.bounds.height / 2.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = color.cgColor


    }

    func setUnselected() {
        
        self.layer.cornerRadius = 0.0
        self.layer.borderWidth = 0.0
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
