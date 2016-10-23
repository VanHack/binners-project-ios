//
//  BPExpandedPickupCollectionViewCell.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 8/23/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit
import GoogleMaps

enum EditType {
    case address, time, date, rate
}

protocol EditPickupProtocol: class {
    
    func didClickEditButton(forCell cell:BPExpandedPickupCollectionViewCell, edit:EditType, pickup:BPPickup)
}

class BPExpandedPickupCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var map: GMSMapView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonRate: UIButton!
    
    @IBOutlet weak var buttonEditAddress: UIButton!
    @IBOutlet weak var buttonEditTime: UIButton!
    @IBOutlet weak var buttonEditDate: UIButton!
    
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
    weak var editDelegate: EditPickupProtocol?
    
    var editingIsEnabled = false {
        didSet {
            enableViews(editingIsEnabled)
        }
    }
    
    var pickup: BPPickup! {
        didSet{
            if let pickup = pickup {
                setupCellForPickup(pickup)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.white
        setupViewCorners()
        setupCell()
    }
    
    // MARK: Setup
    
    func setupCellForPickup(_ pickup:BPPickup) {
        labelStatus.text = pickup.status.statusString()
        labelAddress.text = pickup.address.formattedAddress
        labelTime.text = pickup.date.formattedDate(.time)
        labelDate.text = pickup.date.formattedDate(.date)
        labelBinnerName.text = "Adam"
        let location = CLLocation(
            latitude: pickup.address.location.latitude,
            longitude: pickup.address.location.longitude)
        centerMapOnLocation(location)
        
    }
    
    func setupCell() {
        labelStatus.textColor = UIColor.binnersGreenColor()
        labelBinnerName.textColor = UIColor.binnersGreenColor()
        labelTime.adjustsFontSizeToFitWidth = true
        labelAddress.adjustsFontSizeToFitWidth = true
        labelDate.adjustsFontSizeToFitWidth = true
        map.isUserInteractionEnabled = false
        enableViews(editingIsEnabled)
    }
    
    func setupViewCorners() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 7.0
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 2.0
        self.layer.shadowOffset = CGSize(width: -2.0, height: 2.0)
    }

    //MARK: Enable/Disable views for editing
    
    func enableViews(_ enabled:Bool) {
        
        buttonEditDate.isEnabled =    enabled
        buttonEditAddress.isEnabled = enabled
        buttonEditTime.isEnabled =    enabled
        buttonEditDate.isHidden =     !enabled
        buttonEditAddress.isHidden =  !enabled
        buttonEditTime.isHidden =     !enabled
    }
    
    // MARK: Map
    
    func centerMapOnLocation(_ location: CLLocation) {
        self.map.camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 15.0)
    }

    // MARK: Button Actions
    
    @IBAction func editAddressButtonClicked(_ sender: UIButton) {
        editDelegate?.didClickEditButton(forCell: self, edit: .address,pickup: pickup)
    }
    
    @IBAction func editTimeButtonClicked(_ sender: UIButton) {
        editDelegate?.didClickEditButton(forCell: self, edit: .time, pickup: pickup)
    }
    @IBAction func editDateButtonCliked(_ sender: UIButton) {
        editDelegate?.didClickEditButton(forCell: self, edit: .date, pickup: pickup)
    }
    
    @IBAction func editButtonClicked(_ sender: UIButton) {
        editingIsEnabled = !editingIsEnabled
        
        // save after clicking twice?
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        // cancels pickup
    }
    
    @IBAction func ratingButtonClicked(_ sender: UIButton) {
        // rate pickup
        self.editDelegate?.didClickEditButton(forCell: self, edit: .rate, pickup: pickup)
    }
    
    
}
