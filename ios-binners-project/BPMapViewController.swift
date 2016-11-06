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
    fileprivate var tableView: UITableView?
    fileprivate var searchBar: UISearchBar?
    fileprivate var filteredHistory: [BPAddress]    = []
    fileprivate var searchResults: [BPAddress]  = []
    fileprivate let cellHeight: CGFloat          = 60.0
    fileprivate let headerHeight: CGFloat        = 30.0
    fileprivate let regionRadius: CLLocationDistance = 1000
    fileprivate let locationManager = CLLocationManager()
    fileprivate let mapTasks = BPMapTasks()
    fileprivate var kvoContext: UInt8 = 1
    fileprivate var didFindMyLocation = false
    fileprivate var marker: GMSMarker!
    var pickup: BPPickup = BPPickup()
    
    var history: [BPAddress] {
        if let addresses = BPUserDefaults.loadPickupAdressHistory() {
            return addresses
        } else {
            return []
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filteredHistory.append(contentsOf: history)
        setupNavigationBar()
        setupMap()
        setupSearchBarAndTableView()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        mapView.addObserver(self,
                            forKeyPath: "myLocation",
                            options: NSKeyValueObservingOptions.new,
                            context: nil)
    }
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?) {
        if !didFindMyLocation {
            
            if let myLocation: CLLocation = change![NSKeyValueChangeKey.newKey] as? CLLocation {
                centerMapOnLocation(myLocation)
                mapView.settings.myLocationButton = true
                didFindMyLocation = true
            }
        }
    }
    func setupMap() {
        self.mapView.delegate = self
        self.mapView.isMyLocationEnabled = true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch = event!.allTouches
        
        if let searchBar = self.searchBar,
            let touch = touch {
            if searchBar.isFirstResponder && (touch.first != self.searchBar) {
                self.searchBar!.resignFirstResponder()
                self.mapView.isUserInteractionEnabled = true
            }
        }
        
    }
    func setupSearchBarAndTableView() {
         searchBar = UISearchBar(frame: CGRect(
            x: self.view.frame.origin.x + (self.mapView.frame.size.width) * 0.02,
            y: mapView!.bounds.origin.y + 5,
            width: self.view.frame.size.width - (self.mapView.frame.size.width) * 0.04,
            height: 40))
        searchBar!.delegate = self
        let frame = self.view.convert(self.searchBar!.frame, from: self.mapView!)
        searchBar!.frame = frame
        self.view.addSubview(searchBar!)
        tableView = UITableView(frame: CGRect(
            x: searchBar!.frame.origin.x,
            y: searchBar!.frame.origin.y + searchBar!.frame.size.height + 5,
            width: searchBar!.frame.size.width,
            height: (cellHeight * CGFloat(history.count) + headerHeight)),
                                style:.plain)
        
        let cellNib = UINib(nibName: "BPRecentAddressTableViewCell", bundle: nil)
        tableView!.register(cellNib, forCellReuseIdentifier: "searchTableViewCell")

        tableView!.backgroundColor = UIColor.binnersGray1()
        tableView!.delegate = self
        tableView!.dataSource = self
    }
    func setupNavigationBar() {
        self.title = "Location"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "newPickupSegue" {
            
            guard let destVc = segue.destination as? UINavigationController,
                let calendarVC = destVc.viewControllers[0] as? BPCalendarViewController else {
                    
                    fatalError("Destionation view controller is not UINavigationController or BPCalendarViewController ")
            }
            BPUserDefaults.addAddressToHistory(pickup.address)
            calendarVC.pickup = self.pickup
        }
    }
    
    func cancelButtonClicked() {
        self.mapView.removeObserver(self, forKeyPath: "myLocation")
        self.dismiss(animated: true, completion: nil)
    }
    func centerMapOnLocation(_ location: CLLocation) {
        self.mapView.camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 15.0)
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
         let trimmedString =
            searchText.trimmingCharacters(in: CharacterSet.whitespaces)
        if trimmedString != "" {
            filteredHistory = history.filter {
                address in
                let streetAddress = address.formattedAddress
                return streetAddress!.lowercased().contains(searchText.lowercased())
            }
        } else {
            filteredHistory = history
        }
        self.tableView?.reloadData()
        self.tableView?.adjustHeightOfTableView()
    }
    
    func searchCoordinatesForAddress(_ address: String) {
        self.mapTasks.geocodeAddress(address, withCompletionHandler: {

            (status, success) -> Void in
            
            if !success {
                
                print(status)
                
                if status == "ZERO_RESULTS" {
                    print("Nothing could be found")
                }
            } else {
                
                self.searchResults = self.mapTasks.resultsList
                self.tableView!.reloadData()
                self.tableView!.adjustHeightOfTableView()
    
            }
        })
        
    }
    func goToNewPickup() {
        self.performSegue(withIdentifier: "newPickupSegue", sender: self)
    }
}
extension BPMapViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let trimmedString =
            searchBar.text!.trimmingCharacters(in: CharacterSet.whitespaces)
        
        if trimmedString != "" {
            searchCoordinatesForAddress(searchBar.text!)
        }
        filterContentForSearchText(searchBar.text!)

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        self.view.addSubview(self.tableView!)
        tableView!.reloadData()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {

        self.tableView?.removeFromSuperview()
    }
}

extension BPMapViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        
        var cell =
            tableView.dequeueReusableCell(withIdentifier: "searchTableViewCell")
                as? BPRecentAddressTableViewCell
        
        if cell == nil {
            cell =
                BPRecentAddressTableViewCell(
                    style: .default,
                    reuseIdentifier: "searchTableViewCell")

        }
        
        if (indexPath as NSIndexPath).section == 0 && self.filteredHistory.count > 0 {
            if  self.searchBar!.text != "" {
                cell!.address = filteredHistory[(indexPath as NSIndexPath).row]
            } else {
                cell!.address = history[(indexPath as NSIndexPath).row]
            }
        } else {
            cell!.address = self.searchResults[(indexPath as NSIndexPath).row]
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        mapView.clear()
        view.endEditing(true)
        
        guard let cellSelected =
            tableView.cellForRow(at: indexPath)
                as? BPRecentAddressTableViewCell else {
            fatalError("Could not convert cell")
        }
        
        if let address = cellSelected.address {
            
            let clLocation = CLLocation(
                latitude: address.location.latitude,
                longitude: address.location.longitude)
            centerMapOnLocation(clLocation)
            let  position = CLLocationCoordinate2DMake(
                address.location.latitude,
                address.location.longitude)
            marker = GMSMarker(position: position)
            marker.title = address.formattedAddress
            marker.map = mapView
            mapView.selectedMarker = marker
            self.pickup.address = address

            
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if self.filteredHistory.count == 0 && self.searchResults.count == 0 {
            return 0
        }
        
        if self.filteredHistory.count == 0 || self.searchResults.count == 0 {
            return 1
        }
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            
        if section == 0 && self.filteredHistory.count > 0 {
            if self.searchBar!.text != "" {
                return filteredHistory.count
                
            } else {
                return self.history.count
                
            }
            
        }
        
        return self.searchResults.count
        

    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var titleHeader = "Results"
        
        if section == 0 && self.filteredHistory.count > 0 {
            titleHeader = "Recent"
        }
        
        
        let viewHeader = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: self.tableView!.frame.size.width,
            height: headerHeight
            ))
        viewHeader.backgroundColor = UIColor.white
        let titleLabel = UILabel(frame: CGRect(
            x: 10,
            y: 0,
            width: viewHeader.frame.size.width,
            height: headerHeight
            ))
        titleLabel.font = UIFont.binnersFontWithSize(16)
        titleLabel.textColor = UIColor.black
        titleLabel.text = titleHeader
        viewHeader.addSubview(titleLabel)
        
        return viewHeader
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}
extension BPMapViewController: UIAlertViewDelegate {
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        
    }
}
extension BPMapViewController : GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        button.setTitle("+ Request pickup here", for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.backgroundColor = UIColor.binnersMapBlueColor()
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        goToNewPickup()
    }
}

extension BPMapViewController : CLLocationManagerDelegate {
    
    func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus) {
           // centerMapOnLocation(locationManager.location!)
    }
}
