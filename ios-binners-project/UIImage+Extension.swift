//
//  UIImage+Extension.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 4/11/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import Foundation

extension UIImage {
    func makeImageWithColorAndSize(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRectMake(0, 0, size.width, size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}