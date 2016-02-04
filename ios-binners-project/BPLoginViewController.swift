//
//  ViewController.swift
//  ios-binners-project
//
//  Created by Rodrigo de Souza Reis on 11/01/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit
import AVFoundation
import TwitterKit


class BPLoginViewController: UIViewController {
    
    var player: AVPlayer?
    var videoView: UIView?
    var textFieldEmail: UITextField?
    var textFieldPassword: UITextField?
    let loginManager = BPLoginManager.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = NSBundle.mainBundle().pathForResource("BackgroundVideo", ofType: "mp4")
        player = AVPlayer(URL: NSURL(fileURLWithPath: path!))
        videoView = UIView(frame: self.view.frame)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = videoView!.frame
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoView!.layer.addSublayer(playerLayer)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerItemDidReachEnd", name: AVPlayerItemDidPlayToEndTimeNotification, object: player!.currentItem)
        
        player?.seekToTime(kCMTimeZero)
        player?.play()
        videoView?.addSubview(createForm())
        self.view.addSubview(videoView!)
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        // test purposes only
        FBSDKLoginManager().logOut()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if (userDefaults.boolForKey("FirstAppLaunch") == false)
        {
            performSegueWithIdentifier("presentDescriptionPages", sender: self)
            userDefaults.setBool(true, forKey: "FirstAppLaunch")
            userDefaults.synchronize()

        }
       
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "presentDescriptionPages"
        {
            // do setup if needed
        }
        
    }
    
    func playerItemDidReachEnd() {
        player!.seekToTime(kCMTimeZero)
        player?.play()
    }
    
    func createForm() -> UIView {
        let formView = UIView(frame: CGRectMake((self.view.frame.width - (self.view.frame.width * 0.7))/2, ((self.view.frame.height - 360) - 15), self.view.frame.width * 0.7, 360))
        formView.backgroundColor = UIColor.clearColor()
        formView.addSubview(createInputText(formView, index: 0))
        formView.addSubview(createInputPassword(formView, index:  1))
        formView.addSubview(createButton(formView, index: 2))
        formView.addSubview(createFacebookLoginButton(formView, index: 3))
        formView.addSubview(createTwitterLoginButton(formView, index: 4))
        formView.addSubview(createGoogleLoginButton(formView, index: 5))
        formView.addSubview(createForgoutLoginLink(formView, index: 6))
        formView.addSubview(createBinnerLoginLink(formView, index:  7))
        return formView
    }
    
    func createInputText(form:UIView, index:Int) -> UIView {
        let formView = UITextField(frame: CGRectMake(0, CGFloat(index * 45) , self.view.frame.width * 0.7, 40))
        formView.autocapitalizationType = .None
        formView.backgroundColor = UIColor.lightGrayColor()
        formView.alpha = 0.85
        formView.layer.cornerRadius = 4.0
        formView.clipsToBounds = true
        formView.placeholder = "email"
        formView.textAlignment = .Center
        textFieldEmail = formView
        return formView
    }
    
    func createInputPassword(form:UIView, index:Int) -> UIView {
        let formView = UITextField(frame: CGRectMake(0, CGFloat(index * 45) , self.view.frame.width * 0.7, 40))
        formView.backgroundColor = UIColor.lightGrayColor()
        formView.alpha = 0.85
        formView.layer.cornerRadius = 4.0
        formView.clipsToBounds = true
        formView.placeholder = "password"
        formView.secureTextEntry = true
        formView.textAlignment = .Center
        textFieldPassword = formView
        return formView
    }
    
    func createButton(form:UIView, index:Int) -> UIView {
        let formView = UIButton(frame: CGRectMake(0, CGFloat(index * 45) , self.view.frame.width * 0.7, 40))
        formView.backgroundColor = UIColor.lightGrayColor()
        formView.alpha = 1.0
        formView.layer.cornerRadius = 4.0
        formView.clipsToBounds = true
        let imageview = UIImageView(frame:CGRectMake(10,7,32 ,20)) //0,140,54
        imageview.image = UIImage(named: "iconGreen")
        formView.addSubview(imageview)
        formView.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        formView.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        formView.setTitle("Log in as Resident", forState: UIControlState.Normal)
        formView.backgroundColor = UIColor(red: 0, green: 140/255.0, blue: 54/255.0, alpha: 1.0)
        formView.addTarget(self, action: "makeResidentLogin", forControlEvents: .TouchUpInside)
        return formView
    }
    
    func createFacebookLoginButton(form:UIView, index:Int) -> UIView {
        let formView = FBSDKLoginButton(frame: CGRectMake(0, CGFloat(index * 45) , self.view.frame.width * 0.7, 40))
        formView.center = formView.center
        formView.delegate = self
        formView.readPermissions = ["public_profile","email"]
        
        return formView
    }
    
    func createGoogleLoginButton(form:UIView, index:Int) -> UIView {
        let formView = GIDSignInButton(frame: CGRectMake(0, CGFloat(index * 45) , self.view.frame.width * 0.7, 40))
        formView.center = formView.center
        return formView
    }
    
    func createTwitterLoginButton(form:UIView, index:Int) -> TWTRLogInButton {
        let logInButton = TWTRLogInButton(logInCompletion: { session, error in
            if (session != nil) {
                
            } else {
                
            }
        })
        logInButton.frame = CGRectMake(0, CGFloat(index * 45) , self.view.frame.width * 0.7, 40)
        
        return logInButton
    }
    
    func createForgoutLoginLink(form:UIView, index:Int) -> UIView {
        let formView = UIButton(frame: CGRectMake(0, CGFloat(index * 45) , self.view.frame.width * 0.7, 40))
        formView.center = formView.center
        formView.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        formView.titleLabel?.font = UIFont.systemFontOfSize(16)
        formView.setTitle("Forgout your password ?", forState: UIControlState.Normal)
        return formView
    }
    
    func createBinnerLoginLink(form:UIView, index:Int) -> UIView {
        let formView = UIButton(frame: CGRectMake(0, CGFloat(index * 46) , self.view.frame.width * 0.7, 40))
        formView.center = formView.center
        formView.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        formView.titleLabel?.font = UIFont.systemFontOfSize(16)
        formView.setTitle("You are a Binner, click here.", forState: UIControlState.Normal)
        return formView
    }
    
    func makeResidentLogin()
    {
        assert(textFieldEmail != nil && textFieldPassword != nil)
        
        guard textFieldEmail!.text != "" && textFieldPassword!.text != "" else
        {
            print("email and password can't be empty") // change to ui alert view later
            return
        }
        
        let email = textFieldEmail!.text!
        let password = textFieldPassword!.text!
        
        do {
            
            try loginManager.makeResidentStandardLogin(email, password: password, completion: {
                
                (inner:() throws -> AnyObject) in
                
                do {
                    
                    let value = try inner()
                    print(value)
                    
                }catch let error
                {
                    print(error)
                }
                
                
            })

        }catch let error
        {
            print(error)
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension BPLoginViewController: FBSDKLoginButtonDelegate
{
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!){
        
        loginManager.authFacebook = FBSDKAccessToken.currentAccessToken().tokenString
        
        do {
            
            try loginManager.authenticateFBUserOnBinnersServer() {
                
                (inner:() throws -> AnyObject) in
                
                do
                {
                    let value = try inner()
                    print(value)
                    
                    
                }catch let error
                {
                    print(error)
                }
                
            }

        }catch let error {
            
            print(error)
            
        }
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
}

extension BPLoginViewController : GIDSignInUIDelegate, GIDSignInDelegate
{
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
        
        
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        
        
        if (error == nil) {
            
            loginManager.authGoogle = user.authentication.accessToken
            
            do {
                
                try loginManager.authenticateGoogleUserOnBinnersServer() {
                    
                    (inner:() throws -> AnyObject) in
                    
                    do
                    {
                        let value = try inner()
                        print(value)
                        
                        
                    }catch let error
                    {
                        print(error)
                    }
                    
                }
                
            }catch let error {
                
                print(error)
                
            }

            
            
            
            
        } else {
            print("\(error.localizedDescription)")
        }
        
    }

}

