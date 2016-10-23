//
//  BPOnGoingPickupCollectionViewCell.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 5/5/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.

import UIKit
import GoogleMaps

class BPOnGoingPickupCollectionViewCell: UICollectionViewCell {
    
    var pickup: BPPickup! {
        didSet{
            setupCell()
        }
    }
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var labelPickupStatus: UILabel!
    @IBOutlet weak var labelDateText: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelBinnerText: UILabel!
    @IBOutlet weak var labelBinnerName: UILabel!
    @IBOutlet weak var labelTimeText: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    let formatter:DateFormatter = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.white
        setupViewCorners()
        setupLabels()
    }
    
    func setupLabels() {
        labelBinnerName.textColor = UIColor.binnersGreenColor()
        labelPickupStatus.textColor = UIColor.binnersGreenColor()
    }
    
    func setupCell() {
        labelPickupStatus.text = pickup.status.statusString()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        labelDate.text = formatter.string(from: pickup.date as Date)
        labelBinnerName.text = "Adam"
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        labelTime.text = formatter.string(from: pickup.date as Date)
        let location = CLLocation(
            latitude: pickup.address.location.latitude,
            longitude: pickup.address.location.longitude)
        centerMapOnLocation(location)
        
        mapView.isUserInteractionEnabled = false
    }
    
    func setupViewCorners() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 7.0
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 2.0
        self.layer.shadowOffset = CGSize(width: -2.0, height: 2.0)
    }
    
    func centerMapOnLocation(_ location: CLLocation) {
        self.mapView.camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 15.0)
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    
}
