//
//  NSDate+Extension.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 3/14/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.


import UIKit

enum DateFormatType {
    case time, date
}

extension Date {
    
    static func currentHour() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let dateNow = Date()
        let calendar = Calendar.current
        let comp = (calendar as NSCalendar).components([.hour], from: dateNow)
        return comp.hour!
    }
    
    func printDate() -> String {
        return "\(self.dayMonthYear().1)/\(self.dayMonthYear().0)/\(self.dayMonthYear().2)"
    }
    
    func formattedDate(_ dateType: DateFormatType) -> String {
        
        let formatter = DateFormatter()
        
        switch dateType {
        case .date:
            formatter.timeStyle = .none
            formatter.dateStyle = .short
        case .time:
            formatter.timeStyle = .short
            formatter.dateStyle = .none
        }
        
        return formatter.string(from: self)
    }
    
    func printTime() -> String {
        
        var timePeriod = "am"
        var minute: String = "\(self.getMinute())"
        var hour: String = "\(self.getHour())"
        
        print(hour)
        var hourValue: Int = self.getHour()
        if self.getHour() > 12 {
            timePeriod = "pm"
            hourValue = hourValue - 12
            hour = "\(hourValue)"
        }
        if self.getMinute() < 10 {
            minute = "0\(self.getMinute())"
        }
        
        if hourValue < 10 {
            hour = "0\(hourValue)"
        }
        
        return "\(hour):\(minute) " + timePeriod
    }
    
    func dayMonthYear() -> ( Int, Int, Int ) {
        let calendar = Calendar.current
        let components =
            (calendar as NSCalendar).components(
                [.year, .month, .day, .weekOfMonth, .weekday],
                from: self)
        
        return ( components.day!, components.month!, components.year!)
        
    }
    
    func changeDay(_ day: Int) -> Date {
        
        let calendar = Calendar.current
        var components = (calendar as NSCalendar).components(
            [.year, .month, .day, .weekOfMonth, .weekday],
            from: self)
        components.day = day
        let date = calendar.date(from: components)
        return date!
    }
    
    func getHour() -> Int {
        
        let calendar = Calendar.current
        let components =
            (calendar as NSCalendar).components(
                [.year, .month, .day, .weekOfMonth, .weekday, .hour, .minute],
                from: self)
        
        return components.hour!
    }
    
    func getMinute() -> Int {
        
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(
            [.year, .month, .day, .weekOfMonth, .weekday, .hour, .minute],
            from: self)
        return components.minute!
    }

    
    func changeHour(_ hour: Int) -> Date {
        
        let calendar = Calendar.current
        var components = (calendar as NSCalendar).components(
            [.year, .month, .day, .weekOfMonth, .weekday, .hour, .minute],
            from: self)
        components.hour = hour
        let date = calendar.date(from: components)
        return date!
    }
    
    func changeMinute(_ minute: Int) -> Date {
        
        let calendar = Calendar.current
        var components = (calendar as NSCalendar).components(
            [.year, .month, .day, .weekOfMonth, .weekday, .hour, .minute],
            from: self)
        components.minute = minute
        let date = calendar.date(from: components)
        return date!
    }
    
    func dayOfTheWeek() -> Int {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(
            [.year, .month, .day, .weekOfMonth, .weekday],
            from: self)
        
        return components.weekday!
    }
    
    func daysOfTheMonth(_ date: Date) -> [(String, String, String, String)] {
        
        var dayStrings = [( String, String, String, String)]()
        var weekDay = date.getDateForFirstDayOfTheMonth().dayOfTheWeek()
        
        for index in 1...self.getDaysOfTheMonth().length {
            
            dayStrings.append(
                (String(index),
                String(weekDay),
                String(date.dayMonthYear().1),
                String(date.dayMonthYear().2) ))
            
            weekDay += 1
            
            if weekDay > 7 {
                weekDay = 1
            }
            
        }
        return dayStrings
        
    }
    
    func getDateForFirstDayOfTheMonth() -> Date {
        let calendar = Calendar.current
        var components = (calendar as NSCalendar).components(
            [.year, .month, .day, .weekOfMonth, .weekday],
            from: self)
        components.day = 1
        let date = calendar.date(from: components)
        return date!
    }
    
    func getPastMonth() -> Date {
        let calendar = Calendar.current
        var components = (calendar as NSCalendar).components(
            [.year, .month, .day, .weekOfMonth, .weekday], from: self)
        components.month = components.month! - 1
        let date = calendar.date(from: components)
        return date!
    }
    
    func getNextMonth() -> Date {
        let calendar = Calendar.current
        var components = (calendar as NSCalendar).components(
            [.year, .month, .day, .weekOfMonth, .weekday],
            from: self)
        components.month = components.month! + 1
        let date = calendar.date(from: components)
        return date!
    }
    
    func nextDayDate() -> Date {
        let calendar = Calendar.current
        var components =
            (calendar as NSCalendar).components(
                [.year, .month, .day, .weekOfMonth, .weekday],
                from: self)
        components.day = components.day! + 1
        let date = calendar.date(from: components)
        return date!
    }
    
    func previousDayDate() -> Date {
        let calendar = Calendar.current
        var components = (calendar as NSCalendar).components(
            [.year, .month, .day, .weekOfMonth, .weekday],
            from: self)
        components.day = components.day! - 1
        let date = calendar.date(from: components)
        return date!
    }
    
    func getDaysOfTheMonth() -> NSRange {
        let calendar = Calendar.current
        let daysRange = (calendar as NSCalendar).range(of: .day, in: .month, for: self)
        return daysRange
    }
    
    static func parseDateFromServer(_ dateString:String) -> Date? {
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.'000Z'"
        
        return dateFormatter.date(from: dateString)
    }

    
    func monthLiteral() -> String {
        let month = self.dayMonthYear().1
        
        switch month {
            
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
    
    func dayOfWeekLiteral() -> String {
        let day = self.dayOfTheWeek()
        
        switch day {
            
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
