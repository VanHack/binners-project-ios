//
//  UIColor+Extension.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 2/3/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import Foundation


extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    static func colorWith(redValue: CGFloat, greenValue: CGFloat, blueValue: CGFloat, alpha: CGFloat) -> UIColor {
        
        return UIColor(red: redValue/255.0, green: greenValue/255.0, blue: blueValue/255.0, alpha: alpha)
    }
    
    
    static func calendarSeparationColor() -> UIColor
    {
        return UIColor(netHex: 0xd0d4d9)
    }
    
    
    static func binnersMapBlueColor() -> UIColor
    {
        return UIColor(netHex: 0x006DE8)
    }
    
    static func binnersGrayBackgroundColor() -> UIColor
    {
        return UIColor(netHex: 0xe0e2e4)
    }
    
    static func binnersGreenColor() -> UIColor
    {
        return UIColor(netHex: 0x369a3f)
    }
    
    static func binnersGreenColor2() -> UIColor
    {
        return UIColor(netHex: 0x9bc69e)
    }
    
    static func binnersSkipButtonColor() -> UIColor
    {
        return UIColor(netHex: 0x0d220f)
    }
    static func binnersGray1() -> UIColor {
        
        return UIColor(netHex: 0xf1efef)

    }
    static func binnersGray2() -> UIColor {
        
        return UIColor(netHex: 0xe0e2e4)
        
    }
    static func binnersGray3() -> UIColor {
        
        return UIColor(netHex: 0xcccfd3)
        
    }
    static func binnersDarkGray1() -> UIColor {
        
        return UIColor(netHex: 0x4d5155)
        
    }
    

    
}