//
//  BPQuantityTableViewCell.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 3/21/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit

class BPQuantityTableViewCell: UITableViewCell {

    @IBOutlet weak var labelText: UILabel!
    
    @IBOutlet weak var buttonImageOrText: UIButton!
    
    var reedemable:BPReedemable? {
        didSet {
            
            buttonImageOrText.setTitleColor(UIColor.black, for: UIControlState())
            buttonImageOrText.backgroundColor = UIColor.white
            
            if reedemable!.picture == nil {
                buttonImageOrText.setTitle(reedemable!.quantity, for: UIControlState())
            } else {
                buttonImageOrText.imageView!.contentMode = .scaleAspectFill
                buttonImageOrText.setImage(reedemable!.picture, for: UIControlState())
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.binnersGrayBackgroundColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
