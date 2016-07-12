//
//  BPDesignableView.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 7/12/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit


@IBDesignable
class BPDesignableView: UIView {
    
    let colorHex = 0x1E9D33
    
    override func prepareForInterfaceBuilder() {
        self.backgroundColor = UIColor(netHex: colorHex)
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        self.backgroundColor = UIColor(netHex: colorHex)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor(netHex: colorHex)
    }

}
