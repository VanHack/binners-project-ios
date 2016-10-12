//
//  BPPickupsViewModel.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 7/19/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import Foundation

protocol PickupsDelegate {
    
    func didFinishFetchingOnGoingPickups(success:Bool,errorMsg: String?)
}


class BPPickupsViewModel {
    
    var onGoingPickups:[BPPickup] = []
    var pickupsDelegate:PickupsDelegate?
    var dataFetched = false
    var numberOfItemsInSection: Int {
        return onGoingPickups.count
    }
    var numberOfSections: Int {
        if !self.dataFetched {return 0}
        return 1
    }
    var showEmptyLabel: Bool {
        return onGoingPickups.count == 0
    }
    
    func fetchOnGoingPickups() throws {
        
        dataFetched = false
        self.onGoingPickups.removeAll()
        
        try BPPickup.fetchOnGoingPickups({
            
            pickups in
            
            self.dataFetched = true
            self.onGoingPickups.appendContentsOf(pickups)
            self.pickupsDelegate?.didFinishFetchingOnGoingPickups(true, errorMsg: nil)
            
        }, onFailure: {
            _ in
            self.pickupsDelegate?.didFinishFetchingOnGoingPickups(false,
                errorMsg: "Could not fetch pickups")
            
        })

    }
    
    
    
    
}