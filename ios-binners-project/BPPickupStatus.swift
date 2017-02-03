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
    onGoing = "on_going",
    completed = "completed",
    waitingForReview = "waiting_review"
    
    
    func statusString() -> String {
        
        switch self {
        case .onGoing:
            return "On going"
        case .completed:
            return "Completed"
        case .waitingForReview:
            return "Waiting for review"
        }
    }
    
    func statusUrlString() -> String {
        switch self {
        case .onGoing:
            return "ongoing"
        case .completed:
            return "completed"
        case .waitingForReview:
            return "waitingreview"
        }

    }
}
