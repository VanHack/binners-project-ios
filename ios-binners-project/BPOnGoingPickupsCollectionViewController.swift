//
//  BPOnGoingPickupsCollectionViewController.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 5/5/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit

private let reuseIdentifier = "OnGoingPickupCell"

class BPOnGoingPickupsCollectionViewController: UICollectionViewController {
    
    var dataFetched = false
    var user = BPUser.sharedInstance
    var onGoingPickups:[BPPickup] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        
        do {
            try user().fetchOnGoingPickups() {
                
                (pickups,error) in
                
                if error == nil {
                    self.onGoingPickups = pickups!
                    self.dataFetched = true
                    self.collectionView?.reloadData()
                    
                } else {
                    BPMessageFactory.makeMessage(.ERROR, message: "Could not fetch pickups").show()
                }
                
            }
        }catch _ {
            BPMessageFactory.makeMessage(.ERROR, message: "error").show()
        }
        


    }
    
    
    // MARK: Collection View setup
    func configureCollectionView() {
        self.collectionView?.backgroundColor = UIColor.binnersGray1()
        
        let flowLayout =  UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSizeMake(self.view.frame.width * 0.9 , self.view.frame.height * 0.23)
        flowLayout.scrollDirection = .Vertical
        self.collectionView!.collectionViewLayout = flowLayout
        self.collectionView!.setNeedsLayout()
        self.collectionView!.setNeedsDisplay()
        
        let edgeInsets = UIEdgeInsetsMake((self.navigationController?.navigationBar.frame.height)! * 0.7,0,0, 0)
        self.collectionView?.contentInset = edgeInsets

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        
        if !dataFetched {return 0}
        else {
            return onGoingPickups.count
        }
        
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as? BPOnGoingPickupCollectionViewCell
        
        if cell == nil {
            cell = BPOnGoingPickupCollectionViewCell()
        }
        
        cell?.pickup = onGoingPickups[indexPath.row]
    
        // Configure the cell
    
        return cell!
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
extension BPOnGoingPickupsCollectionViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 20
    }
    
    
}
