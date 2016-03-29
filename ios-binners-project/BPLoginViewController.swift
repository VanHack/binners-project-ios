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
    
    var textFieldEmail: UITextField?
    var textFieldPassword: UITextField?

    let loginManager = BPLoginManager.sharedInstance
    let user = BPUser.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(createBackground(self.view))
        self.view.addSubview(createLogo(self.view))
        self.view.addSubview(createLoginOptionSelector(self.view))
        
        self.view.addSubview(createResidentForm())
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        self.view.bringSubviewToFront(self.view.viewWithTag(124)!)
        
        
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
        
        if segue.identifier == "loginSegue"
        {
            print("loginSegue")
        }
    }
    
    func createBackground(form:UIView) -> UIView {
        let imageName = "login-background"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(frame: CGRectMake(0, 0, form.frame.width, form.frame.height))
        imageView.image = image!
        return imageView
    }
    
    func createLogo(form:UIView) -> UIView {
        let imageName = "login-top-logo"
        let image = UIImage(named: imageName)
        
        //Screen and logo dimensions
        let screenWidth = CGFloat(form.frame.width)
        let imageWidth = CGFloat(162)
        let imageHeight = CGFloat(80)

        //Positioning the logo horizonatally centered
        let imageView = UIImageView(frame: CGRectMake((screenWidth/2) - (imageWidth/2), 40, imageWidth, imageHeight))
        
        imageView.image = image!
        imageView.tag = 122
        return imageView
    }
    
    func createLoginOptionSelector(form:UIView) -> UIView {
        
        let logoView = form.viewWithTag(122)
        let initYPos = logoView!.frame.height + logoView!.frame.origin.y + logoView!.frame.height * 0.1 + 5
        
        let options = ["Binner", "Resident"]
        
        let segControl = UISegmentedControl(items: options)
        segControl.tag = 124
        
        // Style the Segmented Control
        segControl.layer.cornerRadius = 5.0
        segControl.tintColor = UIColor.whiteColor()
        
        //Default selected option
        segControl.selectedSegmentIndex = 1 //Resident
        
        // Set up Frame and SegmentedControl
        let screenWidth = CGFloat(form.frame.width)
        
        segControl.frame = CGRectMake((screenWidth/2) - (235/2), initYPos, 235, 29)

        // Add target action method
        segControl.addTarget(self, action: "segmentedControlOptionChanged:", forControlEvents: .ValueChanged)
        
        return segControl
    }
    
    
    //This is the segmented control handler
    func segmentedControlOptionChanged(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
            
            case 0:
                print("Binners login option selected")
                if let viewWithTag = self.view.viewWithTag(999) {
                    viewWithTag.removeFromSuperview()
                }
                self.view.addSubview(createBinnerForm())
            case 1:
                print("Residente login option selected")
                if let viewWithTag = self.view.viewWithTag(998) {
                    viewWithTag.removeFromSuperview()
                }
                //self.view.addSubview(createBackground(self.view))
                //self.view.addSubview(createLogo(self.view))
                //self.view.addSubview(createLoginOptionSelector(self.view))
                self.view.addSubview(createResidentForm())
            default:
                print("Resident login option selected")
        }
    }
    
    func createResidentForm() -> UIView {
        let formView = UIView(frame: CGRectMake((self.view.frame.width - (self.view.frame.width * 0.9))/2, ((self.view.frame.height - 340) - 15), self.view.frame.width * 0.9, 340))
        
        formView.tag = 999
        
        formView.addSubview(createInputText(formView, index: 1))
        formView.addSubview(createInputPassword(formView, index:  2))
        formView.addSubview(createButton(formView, index: 3))
        formView.addSubview(createOrDivider(formView, index: 4))
        formView.addSubview(createFacebookLoginButton(formView, index: 5))
        formView.addSubview(createTwitterLoginButton(formView, index: 6))
        formView.addSubview(createGoogleLoginButton(formView, index: 7))
        formView.addSubview(createAnAccountLink(formView, index: 8))
        formView.addSubview(createForgotPasswordLink(formView, index: 9))
        
        return formView
    }
    
    
    func createBinnerForm() -> UIView {
        let formView = UIView(frame: CGRectMake((self.view.frame.width - (self.view.frame.width * 0.9))/2, ((self.view.frame.height - 249) - 15), self.view.frame.width * 0.9, 249))
        
        formView.tag = 998
        
        return formView
    }
    
    func createInputText(form:UIView, index:Int) -> UIView {
        
        let yPosButton = CGFloat((165) / 2)
        let segControl = self.view.viewWithTag(124)
        let convertedRect = self.view.convertRect(segControl!.frame, toView: form)
        //let yPos = convertedRect.origin.y + convertedRect.height + form.frame.size.height * 0.05
        let yPos = (yPosButton + convertedRect.origin.y + convertedRect.height) / 2 - 5
        
        let formView = UITextField(frame: CGRectMake(0, yPos, form.frame.width , 20))
        formView.tag = 123
        formView.autocapitalizationType = .None
        formView.background = UIImage(named: "login-email-input-field.png")
        formView.textColor = UIColor.whiteColor()
        formView.attributedPlaceholder =
            NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        formView.textAlignment = .Center
        
        textFieldEmail = formView
        return formView
    }
    
    func createInputPassword(form:UIView, index:Int) -> UIView {
        
        let viewEmail = form.viewWithTag(123)
        let initialPos = viewEmail!.frame.origin.y + viewEmail!.frame.height + viewEmail!.frame.height * 0.9
        
        let formView = UITextField(frame: CGRectMake(0, initialPos, form.frame.width , 20))
        formView.autocapitalizationType = .None
        formView.background = UIImage(named: "login-password-input-field.png")
        formView.secureTextEntry = true
        formView.textColor = UIColor.whiteColor()
        formView.attributedPlaceholder =
            NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        formView.textAlignment = .Center
        textFieldPassword = formView
        formView.tag = 121
        return formView
    }
    
    func createButton(form:UIView, index:Int) -> UIView {
        
        let yPos = (165) / 2 + form.frame.size.height * 0.1
        
        let formView = UIButton(frame: CGRectMake(0, yPos, form.frame.width, 35))
        formView.backgroundColor = UIColor.darkGrayColor()
        formView.layer.cornerRadius = 4.0
        formView.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        formView.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
        formView.setTitle("Login", forState: UIControlState.Normal)
        formView.addTarget(self, action: "makeResidentLogin", forControlEvents: .TouchUpInside)
        return formView
    }
    
    func createOrDivider(form:UIView, index:Int) -> UIView {
        let imageName = "login-divider-between-logins"
        let image = UIImage(named: imageName)

        //Screen and divider dimensions
        let imageWidth = CGFloat(form.frame.width)
        let imageHeight = CGFloat(8)
        
        //Positioning the divider horizonatally centered
        let imageView = UIImageView(frame: CGRectMake(0, 165, imageWidth, imageHeight))
        
        imageView.image = image!
        return imageView
    }
    
    func createFacebookLoginButton(form:UIView, index:Int) -> UIView {
        
        //Screen and divider dimensions
        let buttomWidth = CGFloat(form.frame.width/3 - 10)
        let buttomHeight = CGFloat(40)
        
        let formView = UIButton(frame: CGRectMake(0, 200, buttomWidth, buttomHeight))
        
        let imageName = "login-facebook-buttom"
        let image = UIImage(named: imageName)
        
        formView.setImage(image, forState: .Normal)
        
        formView.addTarget(self, action: "loginWithFacebook:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return formView
    }
    
    func loginWithFacebook(sender:UIButton) {
        let fbloginManager = FBSDKLoginManager()
        fbloginManager.logInWithReadPermissions(["public_profile", "email"], handler: {(result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
            if (error != nil) {
                // Process error
                self.removeFbData()
            } else if result.isCancelled {
                // User Cancellation
                self.removeFbData()
            } else {
                //Success
                if result.grantedPermissions.contains("email") && result.grantedPermissions.contains("public_profile") {
                    //Do work
                    self.loginManager.authFacebook = FBSDKAccessToken.currentAccessToken().tokenString
                    
                    do {
                        
                        try self.loginManager.authenticateFBUserOnBinnersServer() {
                            
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
                    //Handle error
                }
            }
        })
    }
    
    func removeFbData() {
        //Remove FB Data
        let fbManager = FBSDKLoginManager()
        fbManager.logOut()
        FBSDKAccessToken.setCurrentAccessToken(nil)
    }
    
    func createGoogleLoginButton(form:UIView, index:Int) -> UIView {
        let buttomWidth = CGFloat(form.frame.width/3 - 10)
        let buttomHeight = CGFloat(40)
        let formView = UIButton(frame: CGRectMake(buttomWidth+10, 200, buttomWidth, buttomHeight))
        let imageName = "login-google-buttom"
        let image = UIImage(named: imageName)
        formView.setImage(image, forState: .Normal)
        formView.addTarget(self, action: "loginWithGoogle:", forControlEvents: UIControlEvents.TouchUpInside)
        return formView
    }
    
    
    func loginWithGoogle(sender:UIButton)
    {
        GIDSignIn.sharedInstance().signIn()
    }

    func createTwitterLoginButton(form:UIView, index:Int) -> UIView {
        let buttomWidth = CGFloat(form.frame.width/3 - 10)
        let buttomHeight = CGFloat(40)
        let formView = UIButton(frame: CGRectMake((buttomWidth*2)+20, 200, buttomWidth, buttomHeight))
        let imageName = "login-twitter-buttom"
        let image = UIImage(named: imageName)
        formView.setImage(image, forState: .Normal)
        formView.addTarget(self, action: "loginWithTwitter:", forControlEvents: UIControlEvents.TouchUpInside)
        return formView
    }
    
    func loginWithTwitter(sender: UIButton) {
        Twitter.sharedInstance().logInWithCompletion(
            {session, error in
                if let unwrappedSession = session {
                    print("User \(unwrappedSession.userName) has logged in")
                    
                    self.loginManager.authTwitter = unwrappedSession.authToken
                    self.loginManager.authSecretTwitter = unwrappedSession.authTokenSecret
                    
                    /* do {
                        
                        try self.loginManager.authenticateTwitterUserOnBinnersServer() {

                            
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
                        
                    } */
                    
                } else {
                    NSLog("Login error: %@", error!.localizedDescription);
                }
            })
    }
    
   
    func createAnAccountLink(form:UIView, index:Int) -> UIView {
        let formView = UIButton(frame: CGRectMake(0, form.frame.height - 40, 120, 27))
        formView.center = formView.center
        formView.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        formView.titleLabel?.font = UIFont.systemFontOfSize(11)
        formView.setTitle("Create an account", forState: UIControlState.Normal)
        return formView
    }
 
    func createForgotPasswordLink(form:UIView, index:Int) -> UIView {
        let formView = UIButton(frame: CGRectMake(form.frame.width - 120, form.frame.height - 40, 120, 27))
        formView.center = formView.center
        formView.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        formView.titleLabel?.font = UIFont.systemFontOfSize(11)
        formView.setTitle("Forgot your password?", forState: UIControlState.Normal)
        formView.addTarget(self, action: #selector(presentForgotPasswordForm), forControlEvents: .TouchUpInside)
        return formView
    }
    
    func presentForgotPasswordForm() {
        
    }
    
    func makeResidentLogin()
    {
        assert(textFieldEmail != nil && textFieldPassword != nil)
        
        guard textFieldEmail!.text != "" && textFieldPassword!.text != "" else
        {
            print("email and password can't be empty") // change to ui alert view later
            
            BPMessageFactory.makeMessage(BPMessageType.ALERT, message: "Please inform your email and password").show()
        
            return
        }
        
        let email = textFieldEmail!.text!
        let password = textFieldPassword!.text!
        
        do {
            
            try loginManager.makeResidentStandardLogin(email, password: password, completion: {
                
                (inner:() throws -> AnyObject) in
                
                do {
                    
                    let value = try inner()
                    
                    let token = try BPServerResponseParser.parseTokenFromServerResponse(value) 
                    BPUser.sharedInstance.saveAuthToken(token)
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
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
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                    
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
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                        
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

