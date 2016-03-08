//
//  BPMapViewController.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 3/3/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit
import MapKit

class BPMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var tableView:UITableView?
    var searchBar:UISearchBar?
    var history:[String]            = []
    var filteredHistory:[String]    = []
    let cellHeight:CGFloat          = 60.0
    let headerHeight:CGFloat        = 30.0
    let regionRadius: CLLocationDistance = 1000
    let initialLocation = CLLocation(latitude: 49.2827, longitude: -123.1207)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addTestPickupAddresses()
        setupNavigationBar()
        setupSearchBarAndTableView()
        self.mapView.delegate = self
        centerMapOnLocation(initialLocation)
        
        
    }
    
    func addTestPickupAddresses() {
        
        let address1 = "N & 16th st, Lincoln - NE"
        let address2 = "1600 Pensylvania Ave NW"
        let address3 = "1600 Pensylvania Ave NW"
        
        
        self.history.append(address1)
        self.history.append(address2)
        self.history.append(address3)
        
        filteredHistory.appendContentsOf(self.history)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch = event!.allTouches()
        
        if ((self.searchBar!.isFirstResponder()) && (touch!.first != self.searchBar)) {
            
            self.searchBar!.resignFirstResponder()
            self.mapView.userInteractionEnabled = true
        }
        
        super.touchesBegan(touches, withEvent: event)
    }
    
    func setupSearchBarAndTableView() {
        
         searchBar = UISearchBar(frame: CGRectMake(
            self.view.frame.origin.x + (self.mapView.frame.size.width) * 0.02,
            mapView.bounds.origin.y + 5,
            self.view.frame.size.width - (self.mapView.frame.size.width) * 0.04,
            40))
        
        searchBar!.delegate = self
        self.mapView.addSubview(searchBar!)
        
        tableView = UITableView(frame: CGRectMake(
            searchBar!.frame.origin.x,
            searchBar!.frame.origin.y + searchBar!.frame.size.height + 5,
            searchBar!.frame.size.width,
            (cellHeight * CGFloat(history.count) + headerHeight)
            
            ),style:.Plain)
        
        let cellNib = UINib(nibName: "BPRecentAddressTableViewCell", bundle: nil)
        tableView!.registerNib(cellNib, forCellReuseIdentifier: "searchTableViewCell")

        tableView!.backgroundColor = UIColor.binnersGray1()
        tableView!.delegate = self
        tableView!.dataSource = self
        
        
    }
    
    func setupNavigationBar() {
        
        let buttonRight = UIBarButtonItem(title: "✔︎", style: .Done, target: self, action: "checkmarkButtonClicked")
        buttonRight.tintColor = UIColor.whiteColor()
        
        self.navigationItem.rightBarButtonItem = buttonRight
        self.navigationController?.navigationBar.barTintColor = UIColor.binnersGreenColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        let buttonLeft = UIBarButtonItem(title: "✘", style: .Done, target: self, action: "cancelButtonClicked")
        buttonLeft.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = buttonLeft
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkmarkButtonClicked() {
        self.performSegueWithIdentifier("toClockVCSegue", sender: self)
    }
    func cancelButtonClicked() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredHistory = history.filter { address in
            return address.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        self.tableView!.reloadData()
        self.tableView!.adjustHeightOfTableView()

    }
    
    func searchCoordinatesForAddress(address:String) {
        
       let geocoder = CLGeocoder()
        
        //CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:theCenter radius:theRadius identifier:theIdentifier];
        
        let region = CLCircularRegion(center: self.mapView.region.center, radius: regionRadius * 2.0, identifier: "current")
        
        geocoder.geocodeAddressString(address, inRegion: region, completionHandler: {
            
            (placemarks:[CLPlacemark]?,error) in
            
            if let placemarks = placemarks {
                
                for placemark in placemarks {
                    print(placemark.name)
                }
            }

            
        
        
        })
        
    }
    

}
extension BPMapViewController : UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchBar.text!)
        searchCoordinatesForAddress(searchBar.text!)
        
    }
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
        self.mapView.addSubview(self.tableView!)
        tableView!.reloadData()
    }
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {

        self.tableView?.removeFromSuperview()
    }
    
}

extension BPMapViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell =  tableView.dequeueReusableCellWithIdentifier("searchTableViewCell") as? BPRecentAddressTableViewCell
        
        if cell == nil {
            cell = BPRecentAddressTableViewCell(style: .Default, reuseIdentifier: "searchTableViewCell")

        }
        
        if  self.searchBar!.text != "" {
            cell!.location = filteredHistory[indexPath.row]
        } else {
            cell!.location = history[indexPath.row]
        }
        
       
        
        return cell!
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.searchBar!.text != "" {
            return filteredHistory.count

        }
        return self.history.count
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let viewHeader = UIView(frame: CGRectMake(
            0,
            0,
            self.tableView!.frame.size.width,
            headerHeight
            ))
        viewHeader.backgroundColor = UIColor.whiteColor()
        let titleLabel = UILabel(frame: CGRectMake(
            10,
            0,
            viewHeader.frame.size.width,
            headerHeight
            ))
        titleLabel.font = UIFont.binnersFontWithSize(16)
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.text = "Recent"
        viewHeader.addSubview(titleLabel)
        
        return viewHeader
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight
    }
    
    
    
}
extension UITableView {
    
    func adjustHeightOfTableView() {
        
        var height = self.contentSize.height
        let maxHeight = self.superview!.frame.size.height - self.frame.origin.y
        
        if height > maxHeight {
            height = maxHeight
        }
        
        
        UIView.animateWithDuration(0.25, animations: {
            
            var frame = self.frame
            frame.size.height = height
            self.frame = frame
            
        })
    }
}

extension BPMapViewController : MKMapViewDelegate {
    
    
    
}
