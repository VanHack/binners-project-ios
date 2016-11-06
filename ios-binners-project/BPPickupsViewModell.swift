//
//  BPPickupsViewModell.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 05/11/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import Foundation


protocol BPPickupsViewModell {
    
    var pickups: [BPPickup] { get set }
    var pickupsDelegate: PickupsDelegate? { get set }
    var dataFetched: Bool { get set }
    var numberOfItemsInSection: Int { get }
    var numberOfSections: Int { get }
    var showEmptyLabel: Bool { get }
    func fetchPickups() throws
}
