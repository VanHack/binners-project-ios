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
            
            buttonImageOrText.setTitleColor(UIColor.blackColor(), forState: .Normal)
            buttonImageOrText.backgroundColor = UIColor.whiteColor()
            
            if reedemable!.picture == nil {
                buttonImageOrText.setTitle(reedemable!.quantity, forState: .Normal)
            } else {
                buttonImageOrText.imageView!.contentMode = .ScaleAspectFill
                buttonImageOrText.setImage(reedemable!.picture, forState: .Normal)
            }
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
