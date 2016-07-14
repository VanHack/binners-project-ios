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
    
    var activityIndicator:UIActivityIndicatorView!
    let refreshControl = UIRefreshControl()
    var labelEmptyCollectionView:UILabel!
    var dataFetched = false
    var user = BPUser.sharedInstance
    var onGoingPickups:[BPPickup] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        activityIndicator = UIActivityIndicatorView(frame: CGRect(
            x: 0,
            y: 0,
            width: 50,
            height: 50))
        activityIndicator.activityIndicatorViewStyle = .Gray
        configureEmptyLabel()
        configureRefreshControl()
        let cellNib = UINib(nibName: "BPPickupCollectionViewCell", bundle: nil)
        self.collectionView!.registerNib(cellNib, forCellWithReuseIdentifier: reuseIdentifier)


    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if !dataFetched {
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
        if onGoingPickups.count == 0 {
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
        
        let flowLayout =  UICollectionViewFlowLayout()
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
        if !dataFetched {return 0}
        return 1
    }


    override func collectionView(
        collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {

        if !dataFetched {return 0}
        return onGoingPickups.count
        
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
        
        cell?.pickup = onGoingPickups[indexPath.row]
    
    
        return cell!
    }
    
    func reloadCollectionViewData() {
        self.dataFetched = true
        self.collectionView?.reloadData()
    }
    
    func startActivityIndicator() {
        self.view.addSubview(activityIndicator)
        self.activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
    }
    
    func fetchPickups() {
        
        startActivityIndicator()
        do {
            try BPPickup.fetchOnGoingPickups() { inner in
                do {
                    let pickups = try inner()
                    self.onGoingPickups = pickups
                    self.showEmptyLabelIfValid()
                    self.reloadCollectionViewData()
                } catch {
                    self.showCouldNotFetchPickupsError()
                }
                self.refreshControl.endRefreshing()
                self.activityIndicator.removeFromSuperview()
                
            }
        } catch {
            showCouldNotFetchPickupsError()
            refreshControl.endRefreshing()
            self.activityIndicator.removeFromSuperview()
        }
    }
    
    func showCouldNotFetchPickupsError() {
        self.showEmptyLabelIfValid()
        BPMessageFactory.makeMessage(.ERROR, message: "Could not fetch pickups").show()
    }


}
extension BPOnGoingPickupsCollectionViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 20
    }
    
    
}