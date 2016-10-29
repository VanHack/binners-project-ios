//
//  BPHistoryViewControllerCollectionViewController.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 7/13/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit

private let historyCellReuseIdentifier = "PickupCollectionViewCell"
private let historyCellNibIdentifier = "BPPickupCollectionViewCell"

class BPHistoryViewControllerCollectionViewController: PickupsCollectionViewController {

    override func fetchPickups() {
        
        do {
            try pickupsViewModel.fetchOnGoingPickups()
        } catch let error as NSError {
            showCouldNotFetchPickupsError(error.localizedDescription)
            refreshControl.endRefreshing()
        }
    }

    override func registerNibs() {
        let cellNib = UINib(nibName: historyCellNibIdentifier, bundle: Bundle.main)
        self.collectionView!.register(cellNib, forCellWithReuseIdentifier: historyCellReuseIdentifier)
    }

}
extension BPHistoryViewControllerCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: historyCellReuseIdentifier, for: indexPath) as? BPPickupCollectionViewCell {
            cell.configure(style: .rating)
            cell.pickup = pickupsViewModel.onGoingPickups[(indexPath as NSIndexPath).row]
            return cell
        }
        return BPPickupCollectionViewCell()
    }
    
    
}
