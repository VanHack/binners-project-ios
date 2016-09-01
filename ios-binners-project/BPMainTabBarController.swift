//
//  BPMainTabBarController.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 1/15/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.

import UIKit

class BPMainTabBarController: UITabBarController {

    var centerButton:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTabBar()
        
        var tabItems = self.tabBar.items
        let tabItem0 = tabItems![0]
        let tabItem1 = tabItems![1]
        let tabItem2 = tabItems![2]
        let tabItem3 = tabItems![3]
        let tabItem4 = tabItems![4]
        
        tabItem0.title = "History"
        tabItem1.title = "On-Going"
        tabItem2.title = "New Pickup"
        tabItem3.title = "Notifications"
        tabItem4.title = "Donate"
        
        self.setupNavigationBar()

    }
    
    func setupTabBar() {
        
        self.tabBar.tintColor = UIColor.whiteColor()
        self.tabBar.translucent = false
        
        let unselectedColor = UIColor.grayColor()
        self.tabBar.configureFlatTabBarWithColor(UIColor.whiteColor(), selectedColor: unselectedColor)
        
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSForegroundColorAttributeName:unselectedColor],
            forState: .Normal)
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSForegroundColorAttributeName:UIColor.whiteColor()],
            forState: .Selected)
        
        UITabBar.appearance().selectionIndicatorImage =
            UIImage().makeImageWithColorAndSize(
                UIColor.binnersGreenColor(),
                size: CGSize(
                    width: tabBar.frame.width/5,
                    height: tabBar.frame.height))
        
        for item in self.tabBar.items! {
            item.image = item.selectedImage?.imageWithColor(
                unselectedColor).imageWithRenderingMode(
                UIImageRenderingMode.AlwaysOriginal)
        }

        
    }
    
    func showLateralMenu()
    {
        print("side menu")
    }
    
    func setupNavigationBar()
    {
        
        let button = UIBarButtonItem(
            image: UIImage(named: "1455939101_menu-alt.png"),
            style: .Done, target: self,
            action: #selector(BPMainTabBarController.showLateralMenu))
        
        button.tintColor = UIColor.whiteColor() 
        
        self.navigationItem.leftBarButtonItem = button
        self.navigationController?.navigationBar.barTintColor = UIColor.binnersGreenColor()
        self.navigationController?.navigationBar.topItem?.title = "Binner's Project"
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.backgroundColor = UIColor.binnersGreenColor()
    }
    
    
    func addCenterButtonWithViewButtonView(target:AnyObject?,action:Selector)
    {
        
        let button = UIButton(type: .Custom)
        button.frame = CGRect(x: 0.0, y: 0.0,width: 120.0, height: 120.0)
        button.backgroundColor = UIColor.binnersGreenColor()
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        
        let heightDifference = button.frame.size.height - self.tabBar.frame.size.height
        
        if heightDifference < 0
        {
            button.center = self.tabBar.center
        } else {
            let center = self.tabBar.center
            button.center = center
        }
        
        
        button.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        self.view.addSubview(button)
        self.centerButton = button
        
        // label setup
        
        let plusLabel = UILabel(frame: CGRect(
            x: (button.frame.size.width / 2.0) - 15.0,
            y: button.frame.size.height * 0.1,
            width: 30.0,
            height: 40.0))
        plusLabel.text = "+"
        plusLabel.font = UIFont.systemFontOfSize(40)
        plusLabel.textColor = UIColor.whiteColor()
        plusLabel.backgroundColor = UIColor.clearColor()
        plusLabel.textAlignment = .Center
        button.addSubview(plusLabel)
        
        let textLabel = UILabel(frame: CGRect(
            x: (button.frame.size.width / 2.0) - (button.frame.size.width / 2.0),
            y: plusLabel.frame.origin.y + plusLabel.frame.size.height,
            width: button.frame.size.width,
            height: 20.0))
        textLabel.text = "New Pick-Up"
        textLabel.font = UIFont.systemFontOfSize(10)
        textLabel.textColor = UIColor.whiteColor()
        textLabel.backgroundColor = UIColor.clearColor()
        textLabel.textAlignment = .Center
        button.addSubview(textLabel)
        
    }
    
    func buttonPressed(sender:UIButton)
    {
        self.selectedIndex = 0
        self.performSegueWithIdentifier("newPickupSegue", sender: self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        
        if let itemSelected = (tabBar.items)?[4] {
            
            if item == itemSelected {
                UIApplication.sharedApplication().openURL(
                    NSURL(string:"https://www.gifttool.com/donations/Donate?ID=1453&AID=503&PID=4805")!)
            }
            
        }
       // self.selectedViewController = (tabBar.items)![0] as! UIViewController
        
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
