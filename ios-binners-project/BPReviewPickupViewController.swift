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

    }
    
    func configureTableView() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        var cellNib = UINib(nibName: "BPMapTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "mapTableViewCell")
        cellNib = UINib(nibName: "BPDateTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "dateTableViewCell")
        cellNib = UINib(nibName: "BPQuantityTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "quantityTableViewCell")
        cellNib = UINib(nibName: "BPIntructionsTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "instructionsTableViewCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension BPReviewPickupViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch ((indexPath as NSIndexPath).row) {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell?
        
        switch (indexPath as NSIndexPath).row {
        case 0: cell =
            self.tableView.dequeueReusableCell(withIdentifier: "mapTableViewCell")
            as? BPMapTableViewCell
                let cellMap = cell as? BPMapTableViewCell
                cellMap!.address = self.pickup!.address
                cell = cellMap
        case 1: cell =
            self.tableView.dequeueReusableCell(withIdentifier: "dateTableViewCell")
            as? BPDateTableViewCell
                let cellDate = cell as? BPDateTableViewCell
                cellDate!.date = pickup!.date
                cell = cellDate
        case 2: cell =
            self.tableView.dequeueReusableCell(withIdentifier: "quantityTableViewCell")
            as? BPQuantityTableViewCell
                let cellQuantity = cell as? BPQuantityTableViewCell
                cellQuantity!.reedemable = self.pickup!.reedemable
                cell = cellQuantity
        case 3: cell =
            self.tableView.dequeueReusableCell(withIdentifier: "instructionsTableViewCell")
            as? BPIntructionsTableViewCell
                let cellInstructions = cell as? BPIntructionsTableViewCell
                cellInstructions!.instructions = self.pickup!.instructions
                cellInstructions!.finishedPickupDelegate = self
                cell = cellInstructions
        default:cell = UITableViewCell()
            
        }
        
        return cell!
        
    }
    
    func showPostPickupErrorAndEnablePostButton(_ sender:UIButton) {
        
        self.activityIndicator.removeFromSuperview()
        sender.isEnabled = true
        BPMessageFactory.makeMessage(.error, message: "There was an error while uploading the pickup").show()
    }
    
}

extension BPReviewPickupViewController : FinishedPickupDelegate {
    
    func finishPickupButtonClicked(_ sender:UIButton) {
        sender.isEnabled = false
        sender.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        
        if let pickup = pickup {
            
            pickup.postPickup({
                
                _ in
                self.activityIndicator.removeFromSuperview()
                self.dismiss(animated: true, completion: nil)
                sender.isEnabled = true
                
                
                }, onFailure: {
                    _ in
                    self.showPostPickupErrorAndEnablePostButton(sender)
            })
            
        }
        
    }
    
    
}
