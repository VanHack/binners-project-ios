//
//  PickupsCollectionViewController.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 29/10/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit

protocol PickupsCustomCollectionView {
    func fetchPickups()
    func registerNibs()
}

class PickupsCollectionViewController: UICollectionViewController {
    
    let refreshControl = UIRefreshControl()
    var labelEmptyCollectionView:UILabel!
    var pickupsViewModel = BPPickupsViewModel()
    let flowLayout =  UICollectionViewFlowLayout()

    override final func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configureEmptyLabel()
        configureRefreshControl()
        self.pickupsViewModel.pickupsDelegate = self
    }
    
    override final func viewWillAppear(_ animated: Bool) {
        refreshControl.beginRefreshing()
        if !pickupsViewModel.dataFetched {
            fetchPickups()
        }
    }
    
    // MARK: Configurations
    
    final func configureRefreshControl() {
        refreshControl.backgroundColor = UIColor.binnersGray1()
        refreshControl.tintColor = UIColor.gray
        refreshControl.addTarget(self, action: #selector(fetchPickups), for: .valueChanged)
        self.collectionView!.addSubview(refreshControl)
    }
    
    final func configureEmptyLabel() {
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
    final func configureCollectionView() {
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
        
       registerNibs()
        
    }

    final func showEmptyLabelIfValid() {
        if pickupsViewModel.showEmptyLabel {
            self.collectionView?.backgroundView = labelEmptyCollectionView
        } else {
            self.collectionView?.backgroundView = nil
        }
    }

    final func showCouldNotFetchPickupsError(_ msg:String) {
        self.showEmptyLabelIfValid()
        BPMessageFactory.makeMessage(.error, message: msg).show()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
// MARK: UICollectionViewDataSource && Delegate
extension PickupsCollectionViewController {
    
    override final func numberOfSections(in collectionView: UICollectionView) -> Int {
        return pickupsViewModel.numberOfSections
    }
    
    override final func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        
        return pickupsViewModel.numberOfItemsInSection
    }
}

extension PickupsCollectionViewController : UICollectionViewDelegateFlowLayout {
    
    final func collectionView(_ collectionView: UICollectionView,
                              layout collectionViewLayout: UICollectionViewLayout,
                              minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize( width: self.view.frame.width * 0.9, height: self.view.frame.height * 0.3)
    }
    
}

extension PickupsCollectionViewController : PickupsDelegate {
    
    final func didFinishFetchingOnGoingPickups(_ success: Bool, errorMsg: String?) {
        
        if success {
            self.showEmptyLabelIfValid()
            self.collectionView?.reloadData()
        } else {
            self.showCouldNotFetchPickupsError(errorMsg!)
        }
        self.refreshControl.endRefreshing()
    }
}

extension PickupsCollectionViewController : PickupsCustomCollectionView {
    
    func fetchPickups() {
        
    }
    
    func registerNibs() {
        
    }
    
}



