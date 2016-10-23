//
//  BPOnGoingPickupsCollectionViewController.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 5/5/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.

import UIKit

private let notExpandedReuseIdentifier = "PickupCollectionViewCell"
private let expandedCellReuseIdentifier = "ExpandedCell"
private let notExpandedCellNibIdentifier = "BPPickupCollectionViewCell"
private let expandedCellNibIdentifier = "BPExpandedPickupCollectionViewCell"
private let ratePickupSegueIdentifier = "ratePickupSegueIdentifier"
private let editPickupTimeSegueIdentifier = "editPickupTimeSegueIdentifier"

class BPOnGoingPickupsCollectionViewController: UICollectionViewController {
    
    let refreshControl = UIRefreshControl()
    var labelEmptyCollectionView:UILabel!
    var pickupsViewModel = BPPickupsViewModel()
    var indexForPreviousExtendedCell: Int?
    var indexForCurrentExtendedCell: Int?
    var expandCell = false
    let flowLayout =  UICollectionViewFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureEmptyLabel()
        configureRefreshControl()
        self.pickupsViewModel.pickupsDelegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshControl.beginRefreshing()
        if !pickupsViewModel.dataFetched {
            fetchPickups()
        }
    }
    
    // MARK: Configurations
    
    func configureRefreshControl() {
        refreshControl.backgroundColor = UIColor.binnersGray1()
        refreshControl.tintColor = UIColor.gray
        refreshControl.addTarget(self, action: #selector(fetchPickups), for: .valueChanged)
        self.collectionView!.addSubview(refreshControl)
    }
    
    func configureEmptyLabel() {
        labelEmptyCollectionView = UILabel(frame: CGRect(
            x: 50,
            y: 0,
            width: self.view.frame.width - 100,
            height: 80))
        labelEmptyCollectionView.font = UIFont.binnersFontWithSize(17.0)
        labelEmptyCollectionView.textAlignment = .center
        labelEmptyCollectionView.text = "There are no pickups at the moment. Please pull to refresh."
        labelEmptyCollectionView.numberOfLines = 0
        labelEmptyCollectionView.sizeToFit()
    }
    
    // MARK: Collection View setup
    func configureCollectionView() {
        self.collectionView?.backgroundColor = UIColor.binnersGray1()
        
        flowLayout.itemSize = CGSize(
            width: self.view.frame.width * 0.9 ,
            height: self.view.frame.height * 0.23)
        flowLayout.scrollDirection = .vertical
        self.collectionView!.collectionViewLayout = flowLayout
        self.collectionView!.setNeedsLayout()
        self.collectionView!.setNeedsDisplay()
        self.collectionView!.alwaysBounceVertical = true
        
        let edgeInsets = UIEdgeInsets(
            top: (self.navigationController?.navigationBar.frame.height)! * 0.7,
            left: 0,
            bottom: 0,
            right: 0)
        self.collectionView?.contentInset = edgeInsets
        
        var cellNib = UINib(nibName: notExpandedCellNibIdentifier, bundle: nil)
        self.collectionView!.register(cellNib, forCellWithReuseIdentifier: notExpandedReuseIdentifier)
        cellNib = UINib(nibName: expandedCellNibIdentifier, bundle: nil)
        self.collectionView!.register(cellNib, forCellWithReuseIdentifier: expandedCellReuseIdentifier)

    }
    
    func showEmptyLabelIfValid() {
        if pickupsViewModel.showEmptyLabel {
            self.collectionView?.backgroundView = labelEmptyCollectionView
        } else {
            self.collectionView?.backgroundView = nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchPickups() {
        
        do {
            try pickupsViewModel.fetchOnGoingPickups()
        } catch let error as NSError {
            showCouldNotFetchPickupsError(error.localizedDescription)
            refreshControl.endRefreshing()
        }
    }
    
    func showCouldNotFetchPickupsError(_ msg:String) {
        self.showEmptyLabelIfValid()
        BPMessageFactory.makeMessage(.error, message: msg).show()
    }
    
    // MARK : Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let pickupCell = sender as? BPExpandedPickupCollectionViewCell else {
            return
        }
        if segue.identifier == ratePickupSegueIdentifier {
            if let ratePickupVC = segue.destination as? BPRatePickupViewController {
                ratePickupVC.pickup = pickupCell.pickup
            }
        }
    }
    
    func navigateToTimeVC(fromCell cell:BPExpandedPickupCollectionViewCell) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let timeVC = storyboard.instantiateViewController(withIdentifier: "TimeVc") as? BPClockViewController {
            timeVC.pickup = cell.pickup
            present(BPNavigationController(rootViewController: timeVC), animated: true, completion: nil)
        }
    }
    
}

// MARK: UICollectionViewDataSource && Delegate
extension BPOnGoingPickupsCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return pickupsViewModel.numberOfSections
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        
        return pickupsViewModel.numberOfItemsInSection
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
            
            if (expandCell && (indexPath as NSIndexPath).row == indexForCurrentExtendedCell) {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: expandedCellReuseIdentifier, for: indexPath)
                    as! BPExpandedPickupCollectionViewCell
                cell.pickup = pickupsViewModel.onGoingPickups[(indexPath as NSIndexPath).row]
                cell.editDelegate = self
                return cell
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: notExpandedReuseIdentifier, for: indexPath)
                as! BPOnGoingPickupCollectionViewCell
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

extension BPOnGoingPickupsCollectionViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if (expandCell && (indexPath as NSIndexPath).row == indexForCurrentExtendedCell) {
            return CGSize(
                width: self.view.frame.width * 0.9,
                height: self.view.frame.height * 0.73)
            
        } else  {

            return CGSize(
                width: self.view.frame.width * 0.9,
                height: self.view.frame.height * 0.23)
        }
    }
    
}

extension BPOnGoingPickupsCollectionViewController : PickupsDelegate {
    
    func didFinishFetchingOnGoingPickups(_ success: Bool, errorMsg: String?) {
        
        if success {
            self.showEmptyLabelIfValid()
            self.collectionView?.reloadData()
        } else {
            self.showCouldNotFetchPickupsError(errorMsg!)
        }
        self.refreshControl.endRefreshing()
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
