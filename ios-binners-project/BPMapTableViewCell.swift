//
//  BPMapTableViewCell.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 3/16/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.

import UIKit
import GoogleMaps

class BPMapTableViewCell: UITableViewCell {

    @IBOutlet weak var locationLabel: UILabel! {
        didSet {
            self.locationLabel!.textAlignment = .center
            self.locationLabel!.font = UIFont.binnersFontWithSize(15.0)
        }
    }
    @IBOutlet weak var mapView: GMSMapView! {
        
        didSet {
            self.mapView.settings.setAllGesturesEnabled(false)
        }
    }
    @IBOutlet weak var pickupTextLabel: UILabel! {
        didSet {
            self.pickupTextLabel!.font = UIFont.binnersFontWithSize(17.0)

        }
    }
    
    var address:BPAddress? {
        
        didSet {
            self.locationLabel.text = address!.formattedAddress
            self.mapView.camera = GMSCameraPosition.camera(
                withLatitude: address!.location.latitude,
                longitude: address!.location.longitude,
                zoom: 15.0)
            let  position = CLLocationCoordinate2DMake(
                address!.location.latitude,
                address!.location.longitude)
            let marker = GMSMarker(position: position)
            marker.map = mapView
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.locationLabel.backgroundColor = UIColor.white
        self.backgroundColor = UIColor.binnersGrayBackgroundColor()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
