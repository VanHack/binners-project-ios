//
//  BPMapViewController.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 3/3/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps

class BPMapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!

    var tableView:UITableView?
    var searchBar:UISearchBar?
    var filteredHistory:[BPAddress]    = []
    var searchResults:[BPAddress]  = []
    let cellHeight:CGFloat          = 60.0
    let headerHeight:CGFloat        = 30.0
    let regionRadius: CLLocationDistance = 1000
    let locationManager = CLLocationManager()
    let mapTasks = BPMapTasks()
    private var kvoContext: UInt8 = 1
    var didFindMyLocation = false
    var marker:GMSMarker!
    var pickup:BPPickup = BPPickup()
    
    var history:[BPAddress] {
        
        do {
            
            guard let historyList = try BPUser.sharedInstance().loadPickupAdressHistory() else {
                return []
            }
            return historyList
        } catch {
            BPMessageFactory.makeMessage(.ERROR, message: "User not initialized").show()
        }
        return []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filteredHistory.appendContentsOf(history)

        setupNavigationBar()
        setupMap()
        setupSearchBarAndTableView()
        locationManager.delegate = self
        
        if(locationManager.respondsToSelector("requestAlwaysAuthorization")) {
            if #available(iOS 8.0, *) {
                locationManager.requestAlwaysAuthorization()

            } else {
                // Fallback on earlier versions
                locationManager.startUpdatingLocation()
            }
            
            locationManager.location?.coordinate.latitude
        }
        
        
        mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New, context: nil)

    }
    
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if !didFindMyLocation {
            
            let myLocation: CLLocation = change![NSKeyValueChangeNewKey] as! CLLocation
            centerMapOnLocation(myLocation)
            mapView.settings.myLocationButton = true
            
            didFindMyLocation = true
        }
        
        

    }
    
    func setupMap() {
        
        self.mapView.delegate = self
        self.mapView.myLocationEnabled = true

        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        let touch = event!.allTouches()
        
        if ((self.searchBar!.isFirstResponder()) && (touch!.first != self.searchBar)) {
            
            self.searchBar!.resignFirstResponder()
            self.mapView.userInteractionEnabled = true
        }
        
    }
    
    func setupSearchBarAndTableView() {
        
         searchBar = UISearchBar(frame: CGRectMake(
            self.view.frame.origin.x + (self.mapView.frame.size.width) * 0.02,
            mapView!.bounds.origin.y + 5,
            self.view.frame.size.width - (self.mapView.frame.size.width) * 0.04,
            40))
        searchBar!.delegate = self
        
        let frame = self.view.convertRect(self.searchBar!.frame, fromView: self.mapView!)
        
        searchBar!.frame = frame
        self.view.addSubview(searchBar!)
        
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
        
        self.navigationController?.navigationBar.barTintColor = UIColor.binnersGreenColor()
        self.title = "Location"
            
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "newPickupSegue" {
            let destVc = segue.destinationViewController as! UINavigationController
            let calendarVC = destVc.viewControllers[0] as! BPCalendarViewController
            do {
                try BPUser.sharedInstance().addAddressToHistory(self.pickup.address)
            }catch {
                print("should not enter here")
            }
            
            calendarVC.pickup = self.pickup
        }
    }
    
    func cancelButtonClicked() {
        self.mapView.removeObserver(self, forKeyPath: "myLocation")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        self.mapView.camera = GMSCameraPosition.cameraWithTarget(location.coordinate, zoom: 15.0)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
         let trimmedString = searchText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        if trimmedString != "" {
            filteredHistory = history.filter {
                address in
                
                let streetAddress = address.formattedAddress
                return streetAddress.lowercaseString.containsString(searchText.lowercaseString)
                
            }
        } else {
            filteredHistory = history
        }
        
        
        self.tableView!.reloadData()
        self.tableView!.adjustHeightOfTableView()
       
    }
    
    func searchCoordinatesForAddress(address:String) {
        
        self.mapTasks.geocodeAddress(address, withCompletionHandler: {
            
            (status, success) -> Void in
            
            if !success {
                
                print(status)
                
                if status == "ZERO_RESULTS" {
                    print("Nothing could be found")
                }
            }
            else {
                
                self.searchResults = self.mapTasks.resultsList
                self.tableView!.reloadData()
                self.tableView!.adjustHeightOfTableView()
    
            }
        })
        
    }
    
    func goToNewPickup() {
        self.performSegueWithIdentifier("newPickupSegue", sender: self)
    }
    
    
    

}
extension BPMapViewController : UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        let trimmedString = searchBar.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        if trimmedString != ""
        {
            searchCoordinatesForAddress(searchBar.text!)
        }
        filterContentForSearchText(searchBar.text!)

    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
        self.view.addSubview(self.tableView!)
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
        
        if indexPath.section == 0 && self.filteredHistory.count > 0 {
            if  self.searchBar!.text != "" {
                cell!.address = filteredHistory[indexPath.row]
            } else {
                cell!.address = history[indexPath.row]
            }
        } else {
            cell!.address = self.searchResults[indexPath.row]
        }
        
       
        
        return cell!
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        mapView.clear()
        view.endEditing(true)
        
        let cellSelected = tableView.cellForRowAtIndexPath(indexPath) as! BPRecentAddressTableViewCell
        
        if let address = cellSelected.address {
            
            let clLocation = CLLocation(latitude: address.location.latitude, longitude: address.location.longitude)
            centerMapOnLocation(clLocation)
            let  position = CLLocationCoordinate2DMake(address.location.latitude, address.location.longitude)
            marker = GMSMarker(position: position)
            marker.title = address.formattedAddress
            marker.map = mapView
            mapView.selectedMarker = marker
            self.pickup.address = address

            
        }
        
        
        
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if self.filteredHistory.count == 0 && self.searchResults.count == 0 {
            return 0
        }
        
        if self.filteredHistory.count == 0 || self.searchResults.count == 0 {
            return 1
        }
        return 2
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            
        if section == 0 && self.filteredHistory.count > 0 {
            if self.searchBar!.text != "" {
                return filteredHistory.count
                
            }else {
                return self.history.count
                
            }
            
        }
        
        return self.searchResults.count
        

    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var titleHeader = "Results"
        
        if section == 0 && self.filteredHistory.count > 0 {
            titleHeader = "Recent"
        }
        
        
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
        titleLabel.text = titleHeader
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

extension BPMapViewController: UIAlertViewDelegate {
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
    }
    
}

extension BPMapViewController : GMSMapViewDelegate {
    
    func mapView(mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        let button = UIButton(frame: CGRectMake(0,0,200,30))
        button.setTitle("+ Request pickup here", forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.backgroundColor = UIColor.binnersMapBlueColor()
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        
        return button;
    }
    
    func mapView(mapView: GMSMapView, didTapInfoWindowOfMarker marker: GMSMarker) {
        goToNewPickup()
    }
    
}

extension BPMapViewController : CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
           // centerMapOnLocation(locationManager.location!)

    }

    
    
}

