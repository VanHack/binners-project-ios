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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigationBar()
        setupSearchBarAndTableView()
        self.mapView.delegate = self
    }
    
    func setupSearchBarAndTableView() {
        
         searchBar = UISearchBar(frame: CGRectMake(
            self.view.frame.origin.x + (self.mapView.frame.size.width) * 0.02,
            mapView.bounds.origin.y + 5,
            self.view.frame.size.width - (self.mapView.frame.size.width) * 0.04,
            40))
        
        searchBar!.delegate = self
        self.mapView.addSubview(searchBar!)
        
        let tableViewOriginY = searchBar!.frame.origin.y + searchBar!.frame.size.height
        
        tableView = UITableView(frame: CGRectMake(
            searchBar!.frame.origin.x,
            searchBar!.frame.origin.y + searchBar!.frame.size.height + 5,
            searchBar!.frame.size.width,
            mapView.frame.size.height/2 - tableViewOriginY
            
            ),style:.Grouped)

        //tableView!.delegate = self
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension BPMapViewController : UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
     
        
    }
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
        self.mapView.addSubview(self.tableView!)
    }
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
       // searchBar.endEditing(true)
        self.tableView?.removeFromSuperview()
    }
    
}

extension BPMapViewController : MKMapViewDelegate {
    
    
    
}
