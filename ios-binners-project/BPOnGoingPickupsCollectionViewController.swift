//
//  BPOnGoingPickupsCollectionViewController.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 5/5/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//
// swiftlint:disable trailing_whitespace
import UIKit

private let reuseIdentifier = "PickupCollectionViewCell"

class BPOnGoingPickupsCollectionViewController: UICollectionViewController {
    
    let refreshControl = UIRefreshControl()
    var labelEmptyCollectionView:UILabel!
    var pickupsViewModel = BPPickupsViewModel()
    var cellExpanded: UICollectionViewCell?
    let flowLayout =  UICollectionViewFlowLayout()
    var cellIsExpanded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureEmptyLabel()
        configureRefreshControl()
        self.pickupsViewModel.pickupsDelegate = self
        let cellNib = UINib(nibName: "BPPickupCollectionViewCell", bundle: nil)
        self.collectionView!.registerNib(cellNib, forCellWithReuseIdentifier: reuseIdentifier)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshControl.beginRefreshing()
        if !pickupsViewModel.dataFetched {
            fetchPickups()
        }
    }
    
    func configureRefreshControl() {
        refreshControl.backgroundColor = UIColor.binnersGray1()
        refreshControl.tintColor = UIColor.grayColor()
        refreshControl.addTarget(self, action: #selector(fetchPickups), forControlEvents: .ValueChanged)
        self.collectionView!.addSubview(refreshControl)
    }

    func showEmptyLabelIfValid() {
        if pickupsViewModel.showEmptyLabel {
            self.collectionView?.backgroundView = labelEmptyCollectionView
        } else {
            self.collectionView?.backgroundView = nil
        }
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

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return pickupsViewModel.numberOfSections
    }


    override func collectionView(
        collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        
        return pickupsViewModel.numberOfItemsInSection
    }

    override func collectionView(
        collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath)
        -> UICollectionViewCell {
            
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            reuseIdentifier,
            forIndexPath: indexPath)
            as? BPOnGoingPickupCollectionViewCell
        
        if cell == nil {
            cell = BPOnGoingPickupCollectionViewCell()
        }
        
        cell?.pickup = pickupsViewModel.onGoingPickups[indexPath.row]
    
        return cell!
    }
    
    override func collectionView(collectionView: UICollectionView,
                                 didSelectItemAtIndexPath
        indexPath: NSIndexPath) {
        
        cellExpanded = collectionView.cellForItemAtIndexPath(indexPath)
        cellIsExpanded = true
        
        self.collectionView?.reloadItemsAtIndexPaths([indexPath])
        
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if cellExpanded == collectionView.cellForItemAtIndexPath(indexPath) && cellIsExpanded {
            cellIsExpanded = false
            return CGSize(
                width: self.view.frame.width * 0.9,
                height: self.view.frame.height * 0.73)
        } else  {
            return CGSize(
                width: self.view.frame.width * 0.9,
                height: self.view.frame.height * 0.23)
        }
        
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


}
extension BPOnGoingPickupsCollectionViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 20
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
