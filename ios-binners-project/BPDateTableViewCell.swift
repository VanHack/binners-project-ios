//
//  BPDateTableViewCell.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 3/21/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit

class BPDateTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var timeSelectedLabel: UILabel!
    @IBOutlet weak var dateSelectedLabel: UILabel!
    
    var date:NSDate? {
        didSet {
            
            self.timeSelectedLabel.text = date!.printTime()
            self.dateSelectedLabel.text = date!.printDate()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = UIColor.binnersGrayBackgroundColor()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
