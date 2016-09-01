//
//  BPExpandedPickupCollectionViewCell.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 8/23/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit
import GoogleMaps

class BPExpandedPickupCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var map: GMSMapView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonRate: UIButton!
    
    @IBOutlet weak var labelStatusText: UILabel!
    @IBOutlet weak var labelAddressText: UILabel!
    @IBOutlet weak var labelTimeText: UILabel!
    @IBOutlet weak var labelBinnerText: UILabel!
    @IBOutlet weak var labelBottlesText: UILabel!
    @IBOutlet weak var labelDateText: UILabel!
    
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelBinnerName: UILabel!
    @IBOutlet weak var labelBottles: UILabel!
    let formatter:NSDateFormatter = NSDateFormatter()
    
    var pickup: BPPickup! {
        didSet{
            setupCellForPickup()
        }
    }
    
    func setupCellForPickup() {
        labelStatus.text = pickup!.status
        labelAddress.text = pickup!.address.formattedAddress
        formatter.timeStyle = .ShortStyle
        formatter.dateStyle = .NoStyle
        labelTime.text = formatter.stringFromDate(pickup.date)
        formatter.timeStyle = .NoStyle
        formatter.dateStyle = .ShortStyle
        labelDate.text = formatter.stringFromDate(pickup.date)
        labelBinnerName.text = "Adam"
        let location = CLLocation(
            latitude: pickup.address.location.latitude,
            longitude: pickup.address.location.longitude)
        centerMapOnLocation(location)
        map.userInteractionEnabled = false

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.whiteColor()
        setupViewCorners()
        setupCell()
    }
    
    func setupCell() {
        labelStatus.textColor = UIColor.binnersGreenColor()
        labelBinnerName.textColor = UIColor.binnersGreenColor()
    }
    
    func setupViewCorners() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 7.0
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 2.0
        self.layer.shadowOffset = CGSize(width: -2.0, height: 2.0)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        self.map.camera = GMSCameraPosition.cameraWithTarget(location.coordinate, zoom: 15.0)
    }

}
