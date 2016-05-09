//
//  BPCustomCollectionViewFlowLayout.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 5/6/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit

class BPCustomCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let answer = super.layoutAttributesForElementsInRect(rect)

        var answersCopy = [UICollectionViewLayoutAttributes]()
        
        for i in 0..<answer!.count {
            
            let element = answer![i]
            answersCopy.append(element.copy() as! UICollectionViewLayoutAttributes)
        }
        
        
        for i in 1..<answersCopy.count {
            
            let currentLayoutAttributes = answersCopy[i]
            let prevLayoutAttributes = answersCopy[i - 1]
            let maximumSpacing = CGFloat(20.0)
            let origin = CGRectGetMaxY(prevLayoutAttributes.frame)
            
            if (origin + maximumSpacing + currentLayoutAttributes.frame.size.height < self.collectionViewContentSize().height) {
                var frame = currentLayoutAttributes.frame
                frame.origin.y = origin + maximumSpacing
                currentLayoutAttributes.frame = frame
            }
            
        }
        return answersCopy
    }

}
