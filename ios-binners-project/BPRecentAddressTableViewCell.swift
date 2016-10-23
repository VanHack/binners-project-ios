//
//  BPRecentAddressTableViewCell.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 3/7/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit

class BPRecentAddressTableViewCell: UITableViewCell {

    @IBOutlet weak var locationLabel: UILabel!
    
    var address:BPAddress? {
        didSet {
            locationLabel.text = address!.formattedAddress

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        configureCell()
        
    }
    
    func configureCell() {
        self.backgroundColor = UIColor.binnersGray1()
        self.locationLabel.font = UIFont.binnersFontWithSize(13)
        self.locationLabel.textColor = UIColor.binnersDarkGray1()
        self.locationLabel.adjustsFontSizeToFitWidth = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
