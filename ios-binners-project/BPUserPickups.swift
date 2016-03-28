//
//  BPUserPickups.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 3/28/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit

class BPUserPickups: NSObject {
    
    static let sharedInstance = BPUserPickups()
    var completedPickups:RLMArray?
    var notCompletedPickups:RLMArray?

}
