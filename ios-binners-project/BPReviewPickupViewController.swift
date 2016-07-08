//
//  BPReviewPickupViewController.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 3/16/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit

class BPReviewPickupViewController: UIViewController {

    var pickup:BPPickup?
    var activityIndicator:UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        activityIndicator = UIActivityIndicatorView(
            frame: CGRect(x: 0,y: 0,width: 50,height: 50))

        // Do any additional setup after loading the view.
    }
    
    func configureTableView() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        var cellNib = UINib(nibName: "BPMapTableViewCell", bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: "mapTableViewCell")
        cellNib = UINib(nibName: "BPDateTableViewCell", bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: "dateTableViewCell")
        cellNib = UINib(nibName: "BPQuantityTableViewCell", bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: "quantityTableViewCell")
        cellNib = UINib(nibName: "BPIntructionsTableViewCell", bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: "instructionsTableViewCell")
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

extension BPReviewPickupViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch (indexPath.row) {
        case 0: return 331.0
        case 1: return 100.0
        case 2:
            if self.pickup!.reedemable.picture == nil {
            return 100.0
            } else { return 300.0 }
        case 3: return 157.0
        default: return 10.0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell?
        
        switch indexPath.row {
        case 0: cell =
            self.tableView.dequeueReusableCellWithIdentifier("mapTableViewCell")
            as? BPMapTableViewCell
                let cellMap = cell as? BPMapTableViewCell
                cellMap!.address = self.pickup!.address
                cell = cellMap
        case 1: cell =
            self.tableView.dequeueReusableCellWithIdentifier("dateTableViewCell")
            as? BPDateTableViewCell
                let cellDate = cell as? BPDateTableViewCell
                cellDate!.date = pickup!.date
                cell = cellDate
        case 2: cell =
            self.tableView.dequeueReusableCellWithIdentifier("quantityTableViewCell")
            as? BPQuantityTableViewCell
                let cellQuantity = cell as? BPQuantityTableViewCell
                cellQuantity!.reedemable = self.pickup!.reedemable
                cell = cellQuantity
        case 3: cell =
            self.tableView.dequeueReusableCellWithIdentifier("instructionsTableViewCell")
            as? BPIntructionsTableViewCell
                let cellInstructions = cell as? BPIntructionsTableViewCell
                cellInstructions!.instructions = self.pickup!.instructions
                cellInstructions!.finishedPickupDelegate = self
                cell = cellInstructions
        default:cell = UITableViewCell()
            
        }
        
        return cell!
        
    }
    
    func showPostPickupErrorAndEnablePostButton(sender:UIButton) {
        
        self.activityIndicator.removeFromSuperview()
        sender.enabled = true
        BPMessageFactory.makeMessage(.ERROR, message: "There was an error while uploading the pickup").show()
    }
    
}

extension BPReviewPickupViewController : FinishedPickupDelegate {
    
    func finishPickupButtonClicked(sender:UIButton) {
        sender.enabled = false
        sender.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        
        do {
            try pickup!.postPickupInBackgroundWithBock({
                
                (inner:() throws -> AnyObject) in
                
                do
                {
                    try inner()
                    self.activityIndicator.removeFromSuperview()
                    self.dismissViewControllerAnimated(true, completion: nil)
                    sender.enabled = true
                    
                } catch {
                    self.showPostPickupErrorAndEnablePostButton(sender)
                }
                
                
            })
        } catch {
            showPostPickupErrorAndEnablePostButton(sender)
            
        }
        

        
    }
    
    
}
