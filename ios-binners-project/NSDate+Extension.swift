//
//  NSDate+Extension.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 3/14/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit

extension NSDate {
    
    
    func dayMonthYear() -> (Int,Int,Int)
    {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year,.Month,.Day,.WeekOfMonth,.Weekday], fromDate: self)
        
        return (components.day,components.month,components.year)
        
    }
    
    func changeDay(day:Int) ->NSDate {
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year,.Month,.Day,.WeekOfMonth,.Weekday], fromDate: self)
        components.day = day
        let date = calendar.dateFromComponents(components)
        return date!
    }
    
    func changeHour(hour:Int) ->NSDate {
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year,.Month,.Day,.WeekOfMonth,.Weekday,.Hour,.Minute], fromDate: self)
        components.hour = hour
        let date = calendar.dateFromComponents(components)
        return date!
    }
    
    func changeMinute(minute:Int) ->NSDate {
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year,.Month,.Day,.WeekOfMonth,.Weekday,.Hour,.Minute], fromDate: self)
        components.minute = minute
        let date = calendar.dateFromComponents(components)
        return date!
    }
    
    func dayOfTheWeek() -> Int
    {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year,.Month,.Day,.WeekOfMonth,.Weekday], fromDate: self)
        
        return components.weekday
    }
    
    func daysOfTheMonth(date:NSDate) ->[(String,String,String,String)] {
        
        var dayStrings = [(String,String,String,String)]()
        var weekDay = date.getDateForFirstDayOfTheMonth().dayOfTheWeek()
        
        for index in 1...self.getDaysOfTheMonth().length {
            
            dayStrings.append((String(index),String(weekDay),String(date.dayMonthYear().1),String(date.dayMonthYear().2)))
            
            weekDay++
            
            if weekDay > 7
            {
                weekDay = 1
            }
            
        }
        return dayStrings
        
    }
    
    func getDateForFirstDayOfTheMonth() ->NSDate
    {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year,.Month,.Day,.WeekOfMonth,.Weekday], fromDate: self)
        components.day = 1
        let date = calendar.dateFromComponents(components)
        return date!
    }
    
    func getPastMonth() ->NSDate
    {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year,.Month,.Day,.WeekOfMonth,.Weekday], fromDate: self)
        components.month = components.month - 1
        let date = calendar.dateFromComponents(components)
        return date!
    }
    
    func getNextMonth() ->NSDate
    {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year,.Month,.Day,.WeekOfMonth,.Weekday], fromDate: self)
        components.month = components.month + 1
        let date = calendar.dateFromComponents(components)
        return date!
    }
    
    func nextDayDate() ->NSDate
    {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year,.Month,.Day,.WeekOfMonth,.Weekday], fromDate: self)
        components.day = components.day + 1
        let date = calendar.dateFromComponents(components)
        return date!
    }
    
    func previousDayDate() ->NSDate
    {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year,.Month,.Day,.WeekOfMonth,.Weekday], fromDate: self)
        components.day = components.day - 1
        let date = calendar.dateFromComponents(components)
        return date!
    }
    
    
    func getDaysOfTheMonth() -> NSRange
    {
        let calendar = NSCalendar.currentCalendar()
        let daysRange = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: self)
        
        return daysRange
    }
    
    func monthLiteral() ->String
    {
        let month = self.dayMonthYear().1
        
        switch(month) {
            
        case 1: return "January"
        case 2: return "February"
        case 3: return "March"
        case 4: return "April"
        case 5: return "May"
        case 6: return "June"
        case 7: return "July"
        case 8: return "August"
        case 9: return "September"
        case 10: return "October"
        case 11: return "November"
        default: return "December"
            
            
        }
        
    }
    
    func dayOfWeekLiteral() ->String
    {
        let day = self.dayOfTheWeek()
        
        switch(day) {
            
        case 1: return "Sunday"
        case 2: return "Monday"
        case 3: return "Tuesday"
        case 4: return "Wednesday"
        case 5: return "Thursday"
        case 6: return "Friday"
        default: return "Saturday"
            
        }
        
    }
    
    
    
    
}


