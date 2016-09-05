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
private let ratePickupIdentifier = "ratePickupSegueIdentifier"

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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshControl.beginRefreshing()
        if !pickupsViewModel.dataFetched {
            fetchPickups()
        }
    }
    
    // MARK: Configurations
    
    func configureRefreshControl() {
        refreshControl.backgroundColor = UIColor.binnersGray1()
        refreshControl.tintColor = UIColor.grayColor()
        refreshControl.addTarget(self, action: #selector(fetchPickups), forControlEvents: .ValueChanged)
        self.collectionView!.addSubview(refreshControl)
    }
    
    func configureEmptyLabel() {
        labelEmptyCollectionView = UILabel(frame: CGRect(
            x: 50,
            y: 0,
            width: self.view.frame.width - 100,
            height: 80))
        labelEmptyCollectionView.font = UIFont.binnersFontWithSize(17.0)
        labelEmptyCollectionView.textAlignment = .Center
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
        flowLayout.scrollDirection = .Vertical
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
        self.collectionView!.registerNib(cellNib, forCellWithReuseIdentifier: notExpandedReuseIdentifier)
        cellNib = UINib(nibName: expandedCellNibIdentifier, bundle: nil)
        self.collectionView!.registerNib(cellNib, forCellWithReuseIdentifier: expandedCellReuseIdentifier)

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
    
    func showCouldNotFetchPickupsError(msg:String) {
        self.showEmptyLabelIfValid()
        BPMessageFactory.makeMessage(.ERROR, message: msg).show()
    }
    
    // MARK : Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
    }
    
}

// MARK: UICollectionViewDataSource && Delegate
extension BPOnGoingPickupsCollectionViewController {
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return pickupsViewModel.numberOfSections
    }
    
    override func collectionView(
        collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        
        return pickupsViewModel.numberOfItemsInSection
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath)
        -> UICollectionViewCell {
            
            if (expandCell && indexPath.row == indexForCurrentExtendedCell) {
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier(expandedCellReuseIdentifier, forIndexPath: indexPath)
                    as! BPExpandedPickupCollectionViewCell
                cell.pickup = pickupsViewModel.onGoingPickups[indexPath.row]
                cell.editDelegate = self
                return cell
            }
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(notExpandedReuseIdentifier, forIndexPath: indexPath)
                as! BPOnGoingPickupCollectionViewCell
            cell.pickup = pickupsViewModel.onGoingPickups[indexPath.row]
            return cell
            
            
    }
    
    
    override func collectionView(collectionView: UICollectionView,
                                 didSelectItemAtIndexPath
        indexPath: NSIndexPath) {
        
        indexForPreviousExtendedCell = indexForCurrentExtendedCell
        indexForCurrentExtendedCell = indexPath.row
        expandCell = !expandCell
        
        if let indexPrevious = indexForPreviousExtendedCell {
            
            if indexPrevious != indexForCurrentExtendedCell { // if cell expanded before is different than current than we expand other cell
                expandCell = true
            }
            
            let indexPath = NSIndexPath(forRow: indexPrevious, inSection: 0)
            self.collectionView?.reloadItemsAtIndexPaths([indexPath])
        }
        
        let indexPath = NSIndexPath(forRow: indexForCurrentExtendedCell!, inSection: 0)
        self.collectionView?.reloadItemsAtIndexPaths([indexPath])
        
    }
}

extension BPOnGoingPickupsCollectionViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if (expandCell && indexPath.row == indexForCurrentExtendedCell) {
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
    
    func didFinishFetchingOnGoingPickups(success: Bool, errorMsg: String?) {
        
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
    
    func didClickEditButton(forCell: BPExpandedPickupCollectionViewCell, edit: EditType) {
        
        switch edit {
        case .RATE:
            self.performSegueWithIdentifier(ratePickupIdentifier, sender: self)
        default:
            break
        }
        
    }
}
