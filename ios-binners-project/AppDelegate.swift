//
//  AppDelegate.swift
//  ios-binners-project
//
//  Created by Rodrigo de Souza Reis on 11/01/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit
import Fabric
import TwitterKit
import GoogleMaps

let loginVCID = "loginViewController"
let mainTabBarVCID = "tabViewController"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // facebook sdk config
        FBSDKApplicationDelegate.sharedInstance().application(
            application,
            didFinishLaunchingWithOptions: launchOptions)
        
        // google sign in config
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        
        // Twitter skd config
        Fabric.with([Twitter.self])
        GMSServices.provideAPIKey("AIzaSyD3Jbm9orOVMiuz4RvrzWd2E9a8Ub2-s0k")
        
        pickLoginViewController()
        
        return true
    }
    
    func pickLoginViewController() {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        BPUserDefaults.clearUserInfoLocally()
        
        if BPUserDefaults.loadUser() != nil {
            // set root vc to main tab bar
            print(BPUser.sharedInstance.token)
            self.window?.rootViewController = mainStoryboard.instantiateViewController(withIdentifier: mainTabBarVCID)

        } else {
            // set root vc to login vc
            self.window?.rootViewController = mainStoryboard.instantiateViewController(withIdentifier: loginVCID)
        }
        
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                             options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        
        var option: String!
        var option2: String!
        
        if #available(iOS 9.0, *) {
             option = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
             option2 = options[UIApplicationOpenURLOptionsKey.annotation] as? String
        } else {
            // Fallback on earlier versions
             option = options[UIApplicationLaunchOptionsKey.sourceApplication.rawValue]
             option2 = options[UIApplicationLaunchOptionsKey.annotation.rawValue]

        }
        

        return GIDSignIn.sharedInstance().handle(url,
            sourceApplication: option,
            annotation: option2) ||
        FBSDKApplicationDelegate.sharedInstance().application(app,
                                                              open: url,
                                                              sourceApplication: option,
                                                              annotation: option2)
    }
    
    func application(_ application: UIApplication,
                     open url: URL,
                             sourceApplication: String?,
                             annotation: Any) -> Bool {
        
        var options: [String : AnyObject]?
        
        if #available(iOS 9.0, *) {

             options = [UIApplicationOpenURLOptionsKey.sourceApplication.rawValue: sourceApplication! as AnyObject,
                UIApplicationOpenURLOptionsKey.annotation.rawValue: annotation as AnyObject]
            
        } else {
            // Fallback on earlier versions
             options = [UIApplicationLaunchOptionsKey.sourceApplication.rawValue: sourceApplication! as AnyObject,
                UIApplicationLaunchOptionsKey.annotation.rawValue: annotation as AnyObject]
            
        }
        

        
        return FBSDKApplicationDelegate.sharedInstance().application(application,
                                                                     open: url,
                                                                     sourceApplication: sourceApplication,
                                                                     annotation: annotation)
            ||
            self.application(application,
            open: url,
            options: options as! [UIApplicationOpenURLOptionsKey : Any])

    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
