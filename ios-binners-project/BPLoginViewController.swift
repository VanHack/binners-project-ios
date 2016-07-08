//
//  ViewController.swift
//  ios-binners-project
//
//  Created by Rodrigo de Souza Reis on 11/01/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//
// swiftlint:disable trailing_whitespace
import UIKit
import AVFoundation
import TwitterKit

let mainMenuSegueIdentifier = "MainMenuSegue"

class BPLoginViewController: UIViewController {
    
    var textFieldEmail: UITextField?
    var textFieldPassword: UITextField?
    var loginViewModel = BPLoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(createBackground(self.view))
        self.view.addSubview(createLogo(self.view))
        self.view.addSubview(createLoginOptionSelector(self.view))
        
        self.view.addSubview(createResidentForm())
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        self.view.bringSubviewToFront(self.view.viewWithTag(124)!)
        
        textFieldEmail?.text = "matheus.ruschel@gmail.com"
        textFieldPassword?.text = "12345"
        
        self.loginViewModel.loginDelegate = self
        
        // test purposes only
        FBSDKLoginManager().logOut()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if userDefaults.boolForKey("FirstAppLaunch") == false {
            performSegueWithIdentifier("presentDescriptionPages", sender: self)
            userDefaults.setBool(true, forKey: "FirstAppLaunch")
            userDefaults.synchronize()

        }
       
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    func createBackground(form: UIView) -> UIView {
        let imageName = "login-background"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(frame: CGRect(
            x: 0,
            y: 0,
            width: form.frame.width,
            height: form.frame.height))
        imageView.image = image!
        return imageView
    }
    
    func createLogo(form: UIView) -> UIView {
        let imageName = "login-top-logo"
        let image = UIImage(named: imageName)
        
        //Screen and logo dimensions
        let screenWidth = CGFloat(form.frame.width)
        let imageWidth = CGFloat(162)
        let imageHeight = CGFloat(80)

        //Positioning the logo horizonatally centered
        let imageView = UIImageView(frame: CGRect(
            x: (screenWidth/2) - (imageWidth/2),
            y: 40,
            width: imageWidth,
            height: imageHeight))
        
        imageView.image = image!
        imageView.tag = 122
        return imageView
    }
    
    func createLoginOptionSelector(form: UIView) -> UIView {
        
        let logoView = form.viewWithTag(122)
        let initYPos =
            logoView!.frame.height +
            logoView!.frame.origin.y +
            logoView!.frame.height * 0.1 + 5
        
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
        
        segControl.frame = CGRect(
            x: (screenWidth/2) - (235/2),
            y: initYPos,
            width: 235,
            height: 29)

        // Add target action method
        segControl.addTarget(
            self,
            action: #selector(BPLoginViewController.segmentedControlOptionChanged(_:)),
            forControlEvents: .ValueChanged)
        
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
        let formView = UIView(frame: CGRect(
            x: (self.view.frame.width - (self.view.frame.width * 0.9))/2,
            y: ((self.view.frame.height - 340) - 15),
            width: self.view.frame.width * 0.9,
            height: 340))
        
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
    
    func createAnAccountLink(form: UIView, index: Int) -> UIView {
        let formView = UIButton(frame: CGRect(
            x: 0,
            y: form.frame.height - 40,
            width: 120,
            height: 27))
        formView.center = formView.center
        formView.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        formView.titleLabel?.font = UIFont.systemFontOfSize(11)
        formView.setTitle("Create an account", forState: UIControlState.Normal)
        return formView
    }
    
    func createForgotPasswordLink(form: UIView, index: Int) -> UIView {
        let formView = UIButton(frame: CGRect(
            x: form.frame.width - 120,
            y: form.frame.height - 40,
            width: 120,
            height: 27))
        formView.center = formView.center
        formView.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        formView.titleLabel?.font = UIFont.systemFontOfSize(11)
        formView.setTitle("Forgot your password?", forState: UIControlState.Normal)
        formView.addTarget(self,
                           action: #selector(presentForgotPasswordForm),
                           forControlEvents: .TouchUpInside)
        return formView
    }
    
    func presentForgotPasswordForm() {
        
    }

    
    
    func createBinnerForm() -> UIView {
        let formView = UIView(frame: CGRect(
            x: (self.view.frame.width - (self.view.frame.width * 0.9))/2,
            y: ((self.view.frame.height - 249) - 15),
            width: self.view.frame.width * 0.9,
            height: 249))
        
        formView.tag = 998
        
        return formView
    }
    
    func createInputText(form: UIView, index: Int) -> UIView {
        
        let yPosButton = CGFloat((165) / 2)
        let segControl = self.view.viewWithTag(124)
        let convertedRect = self.view.convertRect(segControl!.frame, toView: form)
        let yPos = (yPosButton + convertedRect.origin.y + convertedRect.height) / 2 - 5
        
        let formView = UITextField(frame: CGRect(x: 0,
            y: yPos,
            width: form.frame.width,
            height: 20))
        formView.tag = 123
        formView.autocapitalizationType = .None
        formView.background = UIImage(named: "login-email-input-field.png")
        formView.textColor = UIColor.whiteColor()
        formView.attributedPlaceholder =
            NSAttributedString(string: "Email",
                               attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        formView.textAlignment = .Center
        
        textFieldEmail = formView
        return formView
    }
    
    func createInputPassword(form: UIView, index: Int) -> UIView {
        
        let viewEmail = form.viewWithTag(123)
        let initialPos = viewEmail!.frame.origin.y +
            viewEmail!.frame.height +
            viewEmail!.frame.height * 0.9
        
        let formView = UITextField(frame: CGRect(
            x: 0,
            y: initialPos,
            width: form.frame.width,
            height: 20))
        formView.autocapitalizationType = .None
        formView.background = UIImage(named: "login-password-input-field.png")
        formView.secureTextEntry = true
        formView.textColor = UIColor.whiteColor()
        formView.attributedPlaceholder =
            NSAttributedString(string: "Password",
                               attributes:
                [NSForegroundColorAttributeName : UIColor.whiteColor()])
        formView.textAlignment = .Center
        textFieldPassword = formView
        formView.tag = 121
        return formView
    }
    
    func createButton(form: UIView, index: Int) -> UIView {
        
        let yPos = (165) / 2 + form.frame.size.height * 0.1
        
        let formView = UIButton(frame: CGRect(x: 0,
            y: yPos,
            width: form.frame.width,
            height: 35))
        formView.backgroundColor = UIColor.darkGrayColor()
        formView.layer.cornerRadius = 4.0
        formView.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        formView.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
        formView.setTitle("Login", forState: UIControlState.Normal)
        formView.addTarget(self,
                           action: #selector(BPLoginViewController.makeResidentLogin),
                           forControlEvents: .TouchUpInside)
        return formView
    }
    
    func createOrDivider(form: UIView, index: Int) -> UIView {
        let imageName = "login-divider-between-logins"
        let image = UIImage(named: imageName)

        //Screen and divider dimensions
        let imageWidth = CGFloat(form.frame.width)
        let imageHeight = CGFloat(8)
        
        //Positioning the divider horizonatally centered
        let imageView = UIImageView(frame: CGRect(x: 0,
            y: 165,
            width: imageWidth,
            height: imageHeight))
        
        imageView.image = image!
        return imageView
    }
    
    func createFacebookLoginButton(form: UIView, index: Int) -> UIView {
        
        //Screen and divider dimensions
        let buttomWidth = CGFloat(form.frame.width/3 - 10)
        let buttomHeight = CGFloat(40)
        
        let formView = UIButton(frame: CGRect(x: 0,
            y: 200,
            width: buttomWidth,
            height: buttomHeight))
        
        let imageName = "login-facebook-buttom"
        let image = UIImage(named: imageName)
        
        formView.setImage(image, forState: .Normal)
        
        formView.addTarget(self,
                           action: #selector(BPLoginViewController.loginWithFacebook(_:)),
                           forControlEvents: UIControlEvents.TouchUpInside)
        
        return formView
    }
    
    func createGoogleLoginButton(form: UIView, index: Int) -> UIView {
        let buttomWidth = CGFloat(form.frame.width/3 - 10)
        let buttomHeight = CGFloat(40)
        let formView = UIButton(frame: CGRect(x: buttomWidth+10,
            y: 200,
            width: buttomWidth,
            height: buttomHeight))
        let imageName = "login-google-buttom"
        let image = UIImage(named: imageName)
        formView.setImage(image, forState: .Normal)
        formView.addTarget(self,
                           action: #selector(BPLoginViewController.loginWithGoogle(_:)),
                           forControlEvents: UIControlEvents.TouchUpInside)
        return formView
    }
    
    func createTwitterLoginButton(form: UIView, index: Int) -> UIView {
        let buttomWidth = CGFloat(form.frame.width/3 - 10)
        let buttomHeight = CGFloat(40)
        let formView = UIButton(frame: CGRect(
            x: (buttomWidth*2)+20,
            y: 200,
            width: buttomWidth,
            height: buttomHeight))
        let imageName = "login-twitter-buttom"
        let image = UIImage(named: imageName)
        formView.setImage(image, forState: .Normal)
        formView.addTarget(self,
                           action: #selector(BPLoginViewController.loginWithTwitter(_:)),
                           forControlEvents: UIControlEvents.TouchUpInside)
        return formView
    }

    
    // MARK: Login - FB
    
    func loginWithFacebook(sender: UIButton) {
        
        loginViewModel.authenticateUserWithFacebook()
    }
    
    
    func loginWithGoogle(sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }

    // MARK: Login - TWITTER
    
    func loginWithTwitter(sender: UIButton) {

        loginViewModel.authenticateUserWithTwitter()
    }
    
    // MARK: Login - Resident
    
    func makeResidentLogin() {
        
        let email = textFieldEmail!.text
        let password = textFieldPassword!.text
        
        let status = loginViewModel.validate(email, password: password)
        
        switch status {
        case .Failed(let msg):
            BPMessageFactory.makeMessage(.ERROR, message: msg).show()
        default:
            do {
                try loginViewModel.loginResident(email!, password: password!)
            } catch let error as NSError {
                BPMessageFactory.makeMessage(.ERROR, message: error.description).show()
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension BPLoginViewController : LoginDelegate {
    
    func didLogin(success: Bool, errorMsg: String?) {
        
        switch success {
        case true: self.performSegueWithIdentifier(mainMenuSegueIdentifier, sender: self)
        default: BPMessageFactory.makeMessage(.ERROR, message: errorMsg!).show()
        }
        
    }
}

extension BPLoginViewController : GIDSignInUIDelegate {
    
}
