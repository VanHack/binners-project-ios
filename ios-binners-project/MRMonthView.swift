//
//  MRMonthView.swift
//  MRMonthCalendar
//
//  Created by Matheus Ruschel on 2/21/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.

import UIKit

class MRMonthView: UIView {

    private var labelDayOfTheWeek: UILabel?
    private var labelDayOfTheMonth: UILabel?
    private var labelMonth: UILabel?
    private var labelYear: UILabel?
    private var separationView: UIView?
    private var viewContainerMonthAndYear: UIView?
    private var viewContainerDays: UIView?
    private var dayButtons: [MRDayOfTheMonthButton] = []
    private var daySelected: String?
    var buttonsArrowColor: UIColor = UIColor.binnersGreenColor()
    var date = NSDate()
    
    
    var delegate: MRMonthCalendarDelegate?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.binnersGrayBackgroundColor()
        
        // don't change the order of the setup!! otherwise it will crash... I warned you
        configureBottomCalendar()
        configureTopCalendar()
        daySelected = "\(date.dayMonthYear().0)"
        updateCalendar(date)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.binnersGrayBackgroundColor()
        
        // don't change the order of the setup!! otherwise it will crash... I warned you
        configureBottomCalendar()
        configureTopCalendar()
        daySelected = "\(date.dayMonthYear().0)"
        updateCalendar(date)


    }
    
    //MARK: VIEW LOGIC
    func updateCalendar(date: NSDate) {
//        UIView.animateWithDuration(0.25, animations: {
//            
//            self.labelDayOfTheWeek?.alpha = 0.0
//            self.labelDayOfTheMonth?.alpha = 0.0
//            self.viewContainerMonthAndYear?.alpha = 0.0
//            self.viewContainerDays?.alpha = 0.0
//            
//            },completion: {
//        
//                completed in
//                self.updateCalendarLayoutElements(date)
//                self.markDaySelected()
//                self.makeViewsAndLabelsAppear()
//        })
        self.updateCalendarLayoutElements(date)
        self.markDaySelected()

        
    }
    
    private func updateCalendarLayoutElements(date: NSDate) {
        
        let dayMonthYear = date.dayMonthYear()
        
        self.labelMonth?.text = date.monthLiteral()
        self.labelYear?.text = String(dayMonthYear.2)
        self.labelDayOfTheMonth?.text = String(dayMonthYear.0)
        self.labelDayOfTheWeek?.text = date.dayOfWeekLiteral()
        
        let listOfDays_DaysOfTheWeek_Month_Year = getAllDaysInWeeksInMonthFor(date)
        
        correctButtonTitles(listOfDays_DaysOfTheWeek_Month_Year)
        
        
    }
    
    private func correctButtonTitles(
        dayDayOfTheWeekMonthYearList:[( String, String, String, String )]) {
        

        for button in dayButtons {
            
            let dayStructure = dayDayOfTheWeekMonthYearList[button.number! - 1]
            button.day_dayOfTheWeek_Month_Year = dayStructure
            
            if date.dayMonthYear().1 != Int(dayStructure.2) {
                button.alpha = 0.3
            } else {
                button.alpha = 1.0
            }
        }
        
    }
    
    private func makeViewsAndLabelsAppear() {
        UIView.animateWithDuration(0.25, animations: {
            
            self.labelDayOfTheWeek?.alpha = 1.0
            self.labelDayOfTheMonth?.alpha = 1.0
            self.viewContainerMonthAndYear?.alpha = 1.0
            self.viewContainerDays?.alpha = 1.0
            
            }, completion: {
                
                completed in
                
        })
        
    }
    
    func getAllDaysInWeeksInMonthFor(date: NSDate) ->
        [(String, String, String, String)] {
         let pastMonthDaysStrings = getAllDaysInFirstWeekOfPastMonthFor(date)
         let currentMonthDaysStrings = date.daysOfTheMonth(date)
        let nextMonthDaysStrings = getAllDaysInFirstWeekOfNextMonthForWeekDayOfLastDay(date)
        
        let days = pastMonthDaysStrings + currentMonthDaysStrings + nextMonthDaysStrings
        
        return days
    }
    
    
    func getAllDaysInFirstWeekOfPastMonthFor(date: NSDate) ->
        [( String, String, String, String )]
    {
        var daysStrings = [(String, String, String, String)]()
        
        
        let firstDayOfTheMonth = date.getDateForFirstDayOfTheMonth()
        let weekDayForFirstDay = firstDayOfTheMonth.dayOfTheWeek()
        
        var daysOutOfTheMonth = weekDayForFirstDay - 1
        
        let pastMonthDays = date.getPastMonth().getDaysOfTheMonth()
        var currentDay = pastMonthDays.length
        
        while daysOutOfTheMonth > 0 {
            
            daysStrings.insert((
                String(currentDay),
                String(daysOutOfTheMonth),
                String(date.getPastMonth().dayMonthYear().1),
                String(date.getPastMonth().dayMonthYear().2)), atIndex: 0)
            
            currentDay -= 1
            daysOutOfTheMonth -= 1
        }
        
        
        
        return daysStrings
    }
    
    func getAllDaysInFirstWeekOfNextMonthForWeekDayOfLastDay(date: NSDate) ->
        [ (String, String, String, String) ]
    {
        var daysStrings = [(String, String, String, String)]()
        let weekDay = date.getNextMonth().getDateForFirstDayOfTheMonth().dayOfTheWeek()
        
        var dayInit = 1
        
        var index: Int = weekDay
        for _ in 1...2 {
            
            for ; index <= 7; index += 1 {//in weekDay...7 {
            
            daysStrings.append((
            String(dayInit),
            String(index),
            String(date.getNextMonth().dayMonthYear().1),
            String(date.getNextMonth().dayMonthYear().2)))
            dayInit += 1
            
            }
            index = 1
            
        }
        
        return daysStrings
    }

    //MARK: BUTTON ACTIONS
    internal func didGoToNextMonth() {
        
        date = date.getNextMonth()
        updateCalendar(date)
        self.delegate?.calendarDidChangeDate(date)

    }
    internal func didGoToPreviousMonth() {
        
        date = date.getPastMonth()
        updateCalendar(date)
        self.delegate?.calendarDidChangeDate(date)
    }
    internal func goToPreviousDay() {
        
        date = date.previousDayDate()
        daySelected = "\(date.dayMonthYear().0)"
        updateCalendar(date)
        self.delegate?.calendarDidChangeDate(date)
    }
    internal func goToNextDay() {
        
        date = date.nextDayDate()
        daySelected = "\(date.dayMonthYear().0)"
        updateCalendar(date)
        self.delegate?.calendarDidChangeDate(date)
    }
    
    internal func didSelectDate(sender: MRDayOfTheMonthButton) {
        let day_dayOfTheWeek_Month_Year = sender.day_dayOfTheWeek_Month_Year
        
        if Int(day_dayOfTheWeek_Month_Year!.3) < date.dayMonthYear().2 {
            // go back one month with date selected
            
            daySelected = day_dayOfTheWeek_Month_Year!.0
            didGoToPreviousMonth()
        } else if Int(day_dayOfTheWeek_Month_Year!.3) > date.dayMonthYear().2 {
            // go forward one month with date selected
            
            daySelected = day_dayOfTheWeek_Month_Year!.0
            didGoToNextMonth()

        } else if Int(day_dayOfTheWeek_Month_Year!.2) > date.dayMonthYear().1 {
            
            daySelected = day_dayOfTheWeek_Month_Year!.0
            didGoToNextMonth()
            
        } else if Int(day_dayOfTheWeek_Month_Year!.2) < date.dayMonthYear().1 {
            
            daySelected = day_dayOfTheWeek_Month_Year!.0
            didGoToPreviousMonth()

            
        } else {
            // change day in current month
            daySelected = day_dayOfTheWeek_Month_Year!.0
            markDaySelected()

        }
        
    }

    internal func markDaySelected() {
        
        var selected = false
        
        if let daySelect = daySelected {
            
            date = date.changeDay(Int(daySelect)!)
            
            for button in dayButtons {
                
                if Int(button.day_dayOfTheWeek_Month_Year!.0) == date.dayMonthYear().0
                    && Int(button.day_dayOfTheWeek_Month_Year!.2) == date.dayMonthYear().1
                    && !selected {
                    
                    button.setSelectedDay(UIColor.binnersGreenColor())
                    self.labelDayOfTheMonth!.text = "\(date.dayMonthYear().0)"
                    self.labelDayOfTheWeek!.text = date.dayOfWeekLiteral()
                    selected = true

                } else {

                    button.setUnselected()
                    
                }
                
            }

        }
        
        
    }
    
    
    //MARK: VIEW LAYOUT SETUP
    
    private func configureTopCalendar() {
        configureLabelDayOfTheWeek()
        configureLabelDayOfTheMonth()
        configureLabelMonthAndYear()
        configureSideDayOfTheMonthButtons()
        configureSideMonthAndYearButtons()
    }
    
    
    private func configureLabelDayOfTheWeek() {
        labelDayOfTheWeek = UILabel(frame: CGRect(
            x: self.bounds.origin.x,
            y: self.bounds.size.height * 0.1,
            width: self.bounds.size.width,
            height: 20.0))
        labelDayOfTheWeek!.text = "Tuesday"
        labelDayOfTheWeek?.textAlignment = .Center
        labelDayOfTheWeek!.textColor = UIColor.binnersGreenColor()

        
        self.addSubview(labelDayOfTheWeek!)
    }
    
    private func configureLabelDayOfTheMonth() {
        
        labelDayOfTheMonth = UILabel(frame: CGRect(
            x: 0,
            y: (labelDayOfTheWeek!.frame.size.height * 2) + labelDayOfTheWeek!.frame.origin.y,
            width: 120.0,
            height: self.frame.size.height * 0.20))

        labelDayOfTheMonth!.center.x = labelDayOfTheWeek!.center.x
        labelDayOfTheMonth!.font = UIFont.systemFontOfSize(100.0)
        labelDayOfTheMonth!.text = "7"
        labelDayOfTheMonth?.textAlignment = .Center
        labelDayOfTheMonth?.textColor = UIColor.binnersGreenColor()
        
        self.addSubview(labelDayOfTheMonth!)

    }
    
    private func configureSideDayOfTheMonthButtons() {
        
        let width: CGFloat = 30.0
        let positionXForLeftButton = (labelDayOfTheMonth!.frame.origin.x / 2.0) - width
        
        // left button
        let buttonLeft = UIButton(type: .System)
        buttonLeft.frame = CGRect(
            x: positionXForLeftButton,
            y: 0,
            width: width,
            height: 30.0)
        buttonLeft.setTitle("<", forState: .Normal)
        buttonLeft.tintColor = buttonsArrowColor
        buttonLeft.backgroundColor = UIColor.clearColor()
        buttonLeft.center.y = labelDayOfTheMonth!.center.y
        buttonLeft.titleLabel!.font = UIFont.systemFontOfSize(20)
        buttonLeft.addTarget(self,
                             action: #selector(MRMonthView.goToPreviousDay),
                             forControlEvents: .TouchUpInside)
        
        // add target to left button
        
        // right button
        
        let buttonRight = UIButton(type: .System)
        buttonRight.frame = CGRect(
            x: (labelDayOfTheMonth!.frame.origin.x +
                labelDayOfTheMonth!.frame.size.width + self.frame.size.width) / 2.0,
            y: 0,
            width: width,
            height: 30.0)
        buttonRight.setTitle(">", forState: .Normal)
        buttonRight.tintColor = buttonsArrowColor
        buttonRight.backgroundColor = UIColor.clearColor()
        buttonRight.center.y = labelDayOfTheMonth!.center.y
        buttonRight.titleLabel!.font = UIFont.systemFontOfSize(20)
        buttonRight.addTarget(self,
                              action: #selector(MRMonthView.goToNextDay),
                              forControlEvents: .TouchUpInside)
        
        // add target to right button
        self.addSubview(buttonRight)
        self.addSubview(buttonLeft)
        
        
    }
    
    private func configureLabelMonthAndYear() {
        
        labelMonth = UILabel(frame: CGRect(
            x: 0,
            y: 0,
            width: 100.0,
            height: 30.0))
        labelMonth!.text = "January"
        labelMonth?.textAlignment = .Center
        //labelMonth?.sizeToFit()
        
        labelYear = UILabel(frame: CGRect(
            x: labelMonth!.frame.size.width + 5,
            y: 0,
            width: 40.0,
            height: 30.0))
        labelYear!.text = "2016"
        labelYear?.textColor = UIColor.calendarSeparationColor()
        
        let posY = ((labelDayOfTheMonth!.frame.origin.y + labelDayOfTheMonth!.frame.size.height +
                    separationView!.frame.origin.y) / 2) - labelMonth!.frame.size.height/2 - 7
            
        viewContainerMonthAndYear = UIView(frame: CGRect(
            x: 0,
            y: posY,
            width: labelMonth!.frame.size.width + labelYear!.frame.size.width,
            height: labelMonth!.frame.size.height))
        
        viewContainerMonthAndYear!.center.x = labelDayOfTheMonth!.center.x
        
        viewContainerMonthAndYear!.addSubview(labelMonth!)
        viewContainerMonthAndYear!.addSubview(labelYear!)
        
        self.addSubview(viewContainerMonthAndYear!)
        
        
    }
    
    private func configureSideMonthAndYearButtons() {
        
        // left button
        let buttonLeft = UIButton(type: .System)
        buttonLeft.frame = CGRect(
            x: 10,
            y: 0,
            width: 30.0,
            height: 30.0)
        buttonLeft.setTitle("<", forState: .Normal)
        buttonLeft.tintColor = buttonsArrowColor
        buttonLeft.backgroundColor = UIColor.clearColor()
        buttonLeft.center.y = viewContainerMonthAndYear!.center.y
        buttonLeft.titleLabel!.font = UIFont.systemFontOfSize(20)
        buttonLeft.addTarget(self,
                             action: #selector(MRMonthView.didGoToPreviousMonth),
                             forControlEvents: .TouchUpInside)
        
        // right button
        
        let buttonRight = UIButton(type: .System)
        buttonRight.frame = CGRect(
            x: self.frame.size.width - 40,
            y: 0,
            width: 30.0,
            height: 30.0)
        buttonRight.setTitle(">", forState: .Normal)
        buttonRight.tintColor = buttonsArrowColor
        buttonRight.backgroundColor = UIColor.clearColor()
        buttonRight.center.y = viewContainerMonthAndYear!.center.y
        buttonRight.titleLabel!.font = UIFont.systemFontOfSize(20)
        buttonRight.addTarget(self,
                              action: #selector(MRMonthView.didGoToNextMonth),
                              forControlEvents: .TouchUpInside)
        
        self.addSubview(buttonRight)
        self.addSubview(buttonLeft)

    }
    
    private func configureBottomCalendar() {
        separationView = UIView(frame: CGRect(
            x: 0,
            y: self.frame.size.height * 0.55,
            width: self.frame.size.width - 30,
            height: 1.0))
        separationView!.center.x = CGRectGetMidX(self.bounds)
        separationView!.backgroundColor = UIColor.calendarSeparationColor()
        
        self.addSubview(separationView!)
        setupWeekDaysLabels()
    }
    
    private func setupWeekDaysLabels() {
        
        for index in 0..<7 {
            let initialPosY = separationView!.frame.origin.y - 18
            let labelWidth = separationView!.frame.size.width / 7.0
            let initialPosX = separationView!.frame.origin.x + (CGFloat(index) * labelWidth)

            
            let weekLabel = UILabel(frame: CGRect(
                x: initialPosX,
                y: initialPosY,
                width: labelWidth,
                height: 15))
            weekLabel.textColor = UIColor.binnersGreenColor()
            weekLabel.textAlignment = .Center
            weekLabel.font = UIFont.boldSystemFontOfSize(14)
            
            var text = ""
    
            switch index {
            case 0: text = "Sun"
            case 1: text = "Mon"
            case 2: text = "Tue"
            case 3: text = "Wed"
            case 4: text = "Thu"
            case 5: text = "Fri"
            case 6: text = "Sat"
            
            default: break
            }
            
            weekLabel.text = text
            
            self.addSubview(weekLabel)
            addDayButtonsToColumnFromLabel(index, positionX: initialPosX, width:labelWidth )
        }
        
    }
    
    private func addDayButtonsToColumnFromLabel(
        weekIndex: Int,
        positionX: CGFloat,
        width: CGFloat) {
        let originY = (separationView!.frame.origin.y + separationView!.frame.size.height)
        let labelHeight = (self.frame.size.height - originY) / 6.0
        
        let weekIndexInit = weekIndex + 1
        
        if viewContainerDays == nil {
            viewContainerDays = UIView(frame: CGRect(
                x: separationView!.frame.origin.x,
                y: originY,
                width: separationView!.frame.size.width,
                height: (self.frame.size.height - originY)
                ))
            viewContainerDays?.backgroundColor = UIColor.clearColor()
            self.addSubview(viewContainerDays!)
            
        }
        
        let positionXInContainer = positionX - separationView!.frame.origin.x
        
        for index in 0..<6 {
            let initialPosY = (CGFloat(index) * labelHeight)
            
            
            let weekDayButton = MRDayOfTheMonthButton(type: .Custom)
             weekDayButton.frame = CGRect(
                x: positionXInContainer,
                y: initialPosY,
                width: width,
                height: labelHeight)

            weekDayButton.titleLabel!.textAlignment = .Center
            weekDayButton.titleLabel!.font = UIFont.boldSystemFontOfSize(14)
            weekDayButton.number = weekIndexInit + (index * 7)
            weekDayButton.setTitle("\(weekDayButton.number!)", forState: .Normal)
            weekDayButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            weekDayButton.addTarget(
                self,
                action: #selector(MRMonthView.didSelectDate(_:)),
                forControlEvents: .TouchUpInside)
            
            viewContainerDays!.addSubview(weekDayButton)
            dayButtons.append(weekDayButton)

        }
        
    }

}
