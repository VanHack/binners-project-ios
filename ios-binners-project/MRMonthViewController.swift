//
//  MRMonthViewController.swift
//  MRMonthCalendar
//
//  Created by Matheus Ruschel on 2/22/16.
//  Copyright © 2016 Matheus Ruschel. All rights reserved.
//

import UIKit

class MRMonthViewController: UIViewController {
    
    var monthView:MRMonthView?
    var date:NSDate? {
        return monthView?.date
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        monthView = MRMonthView(frame: CGRectMake(
            self.view.frame.origin.x,
            self.view.frame.origin.y,
            self.view.frame.size.width,
            self.view.frame.size.height))
        
        self.view.addSubview(monthView!)
        
        monthView!.delegate = self
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

extension MRMonthViewController : MRMonthCalendarDelegate
{
    func calendarDidChangeDate(date: NSDate) {
        
    }
}
