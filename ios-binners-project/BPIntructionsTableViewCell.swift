//
//  BPIntructionsTableViewCell.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 3/21/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit

protocol FinishedPickupDelegate {
    
    func finishPickupButtonClicked(_ sender:UIButton)
}

class BPIntructionsTableViewCell: UITableViewCell {

    @IBOutlet weak var labelInstructions: UILabel!
    @IBOutlet weak var buttonFinish: UIButton! {
        didSet {
            buttonFinish.backgroundColor = UIColor.binnersGreenColor()
            buttonFinish.tintColor = UIColor.white
            buttonFinish.addTarget(self,
                                   action: #selector(buttonFinishClicked),
                                   for: .touchUpInside)
            buttonFinish.layer.cornerRadius = 10
            buttonFinish.clipsToBounds = true
        }
    }
    @IBOutlet weak var labelText: UILabel!
    
    var instructions:String? {
        didSet {
            labelText.backgroundColor = UIColor.white
            labelText.text = instructions!
        }
    }
    var finishedPickupDelegate:FinishedPickupDelegate?
    
    func buttonFinishClicked(_ sender:UIButton) {
        finishedPickupDelegate?.finishPickupButtonClicked(sender)
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
