//
//  BPOnGoingPickupsCollectionViewController.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 5/5/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.

import UIKit

private let notExpandedCellReuseIdentifier = "PickupCollectionViewCell"
private let expandedCellReuseIdentifier = "ExpandedCell"
private let notExpandedCellNibIdentifier = "BPPickupCollectionViewCell"
private let expandedCellNibIdentifier = "BPExpandedPickupCollectionViewCell"
// Segues
private let ratePickupSegueIdentifier = "ratePickupSegueIdentifier"
private let editPickupTimeSegueIdentifier = "editPickupTimeSegueIdentifier"

class BPOnGoingPickupsCollectionViewController: PickupsCollectionViewController {
    
    var indexForPreviousExtendedCell: Int?
    var indexForCurrentExtendedCell: Int?
    var expandCell = false
    
    override func fetchPickups() {
        
        do {
            try pickupsViewModel.fetchOnGoingPickups()
        } catch let error as NSError {
            showCouldNotFetchPickupsError(error.localizedDescription)
            refreshControl.endRefreshing()
        }
    }
    
    override func registerNibs() {
        var cellNib = UINib(nibName: notExpandedCellNibIdentifier, bundle: nil)
        self.collectionView!.register(cellNib, forCellWithReuseIdentifier: notExpandedCellReuseIdentifier)
        cellNib = UINib(nibName: expandedCellNibIdentifier, bundle: nil)
        self.collectionView!.register(cellNib, forCellWithReuseIdentifier: expandedCellReuseIdentifier)
    }
    
    // MARK : Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pickupCell = sender as? BPExpandedPickupCollectionViewCell {
            
            if segue.identifier == ratePickupSegueIdentifier {
                if let ratePickupVC = segue.destination as? BPRatePickupViewController {
                    ratePickupVC.pickup = pickupCell.pickup
                }
            }
        }
    }
    
    func navigateToTimeVC(fromCell cell:BPExpandedPickupCollectionViewCell) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let timeVC = storyboard.instantiateViewController(withIdentifier: "TimeVc") as? BPClockViewController {
            timeVC.pickup = cell.pickup
            timeVC.isPresenting = true
            present(BPNavigationController(rootViewController: timeVC), animated: true, completion: nil)
        }
    }
    
    
}

extension BPOnGoingPickupsCollectionViewController {
    
    
    override func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if (expandCell && (indexPath as NSIndexPath).row == indexForCurrentExtendedCell) {
            return CGSize(
                width: self.view.frame.width * 0.9,
                height: self.view.frame.height * 0.73)
            
        } else  {
            return super.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
        }
    }
    
    
}

// MARK: UICollectionViewDataSource && Delegate
extension BPOnGoingPickupsCollectionViewController {
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
            
            if (expandCell && (indexPath as NSIndexPath).row == indexForCurrentExtendedCell) {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: expandedCellReuseIdentifier, for: indexPath)
                    as! BPExpandedPickupCollectionViewCell
                cell.pickup = pickupsViewModel.onGoingPickups[(indexPath as NSIndexPath).row]
                cell.editDelegate = self
                return cell
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: notExpandedCellReuseIdentifier, for: indexPath)
                as! BPPickupCollectionViewCell
            cell.configure()
            cell.pickup = pickupsViewModel.onGoingPickups[(indexPath as NSIndexPath).row]
            return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt
        indexPath: IndexPath) {
        
        indexForPreviousExtendedCell = indexForCurrentExtendedCell
        indexForCurrentExtendedCell = (indexPath as NSIndexPath).row
        expandCell = !expandCell
        
        if let indexPrevious = indexForPreviousExtendedCell {
            
            if indexPrevious != indexForCurrentExtendedCell { // if cell expanded before is different than current than we expand other cell
                expandCell = true
            }
            
            let indexPath = IndexPath(row: indexPrevious, section: 0)
            self.collectionView?.reloadItems(at: [indexPath])
        }
        
        let indexPath = IndexPath(row: indexForCurrentExtendedCell!, section: 0)
        self.collectionView?.reloadItems(at: [indexPath])
        
    }
}

extension BPOnGoingPickupsCollectionViewController : EditPickupProtocol {
    
     func didClickEditButton(forCell cell: BPExpandedPickupCollectionViewCell, edit: EditType, pickup:BPPickup) {
        
        switch edit {
        case .rate:
            self.performSegue(withIdentifier: ratePickupSegueIdentifier, sender: cell)
        case .time:
            navigateToTimeVC(fromCell: cell)
        default:
            break
        }
        
    }
}
