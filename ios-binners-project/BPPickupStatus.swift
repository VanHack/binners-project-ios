//
//  BPPickupStatus.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 12/10/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import Foundation

enum PickupStatus: String {
    case
    OnGoing = "on_going",
    Completed = "completed",
    WaitingForReview = "waiting_for_review"
    
    
    func statusString() -> String {
        
        switch self {
        case .OnGoing:
            return "On going"
        case .Completed:
            return "Completed"
        case .WaitingForReview:
            return "Waiting for review"
        }
    }
}