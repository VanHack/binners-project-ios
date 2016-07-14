//
//  ViewController.swift
//  ios-binners-project
//
//  Created by Rodrigo de Souza Reis on 11/01/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//
// swiftlint:disable trailing_whitespace
// swiftlint:disable line_length
import UIKit
import AVFoundation
import TwitterKit

let mainMenuSegueIdentifier = "MainMenuSegue"

let LoginButtonTag = 1

class BPLoginViewController: UIViewController {
    
    var textFieldEmail: UITextField?
    var textFieldPassword: UITextField?
    var loginViewModel = BPLoginViewModel()
    var activityIndicator:UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(createResidentForm())
        GIDSignIn.sharedInstance().uiDelegate = self
        textFieldEmail?.text = "matheus.ruschel@gmail.com"
        textFieldPassword?.text = "12345"
        self.loginViewModel.loginDelegate = self
        self.loginViewModel.passwordForgotDelegate = self
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if userDefaults.boolForKey("FirstAppLaunch") == false {
            performSegueWithIdentifier("presentDescriptionPages", sender: self)
            userDefaults.setBool(true, forKey: "FirstAppLaunch")
            userDefaults.synchronize()
        }
       
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    func createResidentForm() -> UIView {
        let formView = UIView(frame: CGRect(
            x: (self.view.frame.width - (self.view.frame.width * 0.9))/2,
            y: (self.view.frame.height * 0.4),
            width: self.view.frame.width * 0.9,
            height: (self.view.frame.height * 0.6)))
        
        formView.tag = 999
        
        formView.addSubview(createInputText(formView, index: 1))
        formView.addSubview(createInputPassword(formView, index:  2))
        formView.addSubview(createButton(formView, index: 3))
        formView.addSubview(createFacebookLoginButton(formView, index: 4))
        formView.addSubview(createTwitterLoginButton(formView, index: 5))
        formView.addSubview(createGoogleLoginButton(formView, index: 6))
        formView.addSubview(createAnAccountLink(formView, index: 7))
        formView.addSubview(createForgotPasswordLink(formView, index: 8))
        
        return formView
    }
    
    func createAnAccountLink(form: UIView, index: Int) -> UIView {
        let formView = UIButton(frame: CGRect(
            x: 0,
            y: form.frame.height * 0.9,
            width: 120,
            height: 27))
        formView.center = formView.center
        formView.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        formView.titleLabel!.textAlignment = .Left
        formView.titleLabel?.font = UIFont.binnersFontWithSize(12)
        formView.setTitle("Create an account", forState: UIControlState.Normal)
        return formView
    }
    
    func createForgotPasswordLink(form: UIView, index: Int) -> UIView {
        let formView = UIButton(frame: CGRect(
            x: form.frame.width - 120,
            y: form.frame.height * 0.9,
            width: 120,
            height: 27))
        formView.tag = LoginButtonTag
        formView.center = formView.center
        formView.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        formView.titleLabel!.textAlignment = .Right
        formView.titleLabel?.font = UIFont.binnersFontWithSize(12)
        formView.setTitle("Forgot your password?", forState: UIControlState.Normal)
        formView.addTarget(self,
                           action: #selector(presentForgotPasswordForm),
                           forControlEvents: .TouchUpInside)
        return formView
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
        
        let yPosButton = form.frame.height * 0.1
        
        let formView = UITextField(frame: CGRect(x: 0,
            y: yPosButton,
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
        
        let yPos = form.frame.size.height * 0.4
        
        let formView = UIButton(frame: CGRect(x: 0,
            y: yPos,
            width: form.frame.width,
            height: form.frame.height * 0.15))
        
        activityIndicator = UIActivityIndicatorView(
            frame: CGRect(x: 0,y: 0,width: 50,height: formView.frame.height))
        
        formView.backgroundColor = UIColor(netHex: 0x008DF0)
        formView.layer.cornerRadius = 4.0
        formView.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        formView.titleLabel?.font = UIFont.binnersFontWithSize(16)
        formView.setTitle("Log In", forState: UIControlState.Normal)
        formView.addTarget(self,
                           action: #selector(BPLoginViewController.makeResidentLogin),
                           forControlEvents: .TouchUpInside)
        return formView
    }
    
    func createFacebookLoginButton(form: UIView, index: Int) -> UIView {
        
        //Screen and divider dimensions
        let buttomWidth = CGFloat(form.frame.width/3 - 10)
        let buttomHeight = CGFloat(50)
        
        let formView = UIButton(frame: CGRect(x: 0,
            y: form.frame.height * 0.6,
            width: buttomWidth,
            height: buttomHeight))
        
        let imageName = "facebookButton"
        let image = UIImage(named: imageName)
        formView.layer.contents = image!.CGImage
        formView.layer.contentsGravity = kCAGravityResizeAspect
        
        formView.addTarget(self,
                           action: #selector(BPLoginViewController.loginWithFacebook(_:)),
                           forControlEvents: UIControlEvents.TouchUpInside)
        
        return formView
    }
    
    func createGoogleLoginButton(form: UIView, index: Int) -> UIView {
        let buttomWidth = CGFloat(form.frame.width/3 - 10)
        let buttomHeight = CGFloat(50)
        let formView = UIButton(frame: CGRect(x: buttomWidth+10,
            y: form.frame.height * 0.6,
            width: buttomWidth,
            height: buttomHeight))
        let imageName = "googleButton"
        let image = UIImage(named: imageName)
        formView.layer.contents = image!.CGImage
        formView.layer.contentsGravity = kCAGravityResizeAspect
        formView.addTarget(self,
                           action: #selector(BPLoginViewController.loginWithGoogle(_:)),
                           forControlEvents: UIControlEvents.TouchUpInside)
        return formView
    }
    
    func createTwitterLoginButton(form: UIView, index: Int) -> UIView {
        let buttomWidth = CGFloat(form.frame.width/3 - 10)
        let buttomHeight = CGFloat(50)
        let formView = UIButton(frame: CGRect(
            x: (buttomWidth*2)+20,
            y: form.frame.height * 0.6,
            width: buttomWidth,
            height: buttomHeight))
        let imageName = "TwitterButton"
        let image = UIImage(named: imageName)
        formView.layer.contents = image!.CGImage
        formView.layer.contentsGravity = kCAGravityResizeAspect
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
    
    func makeResidentLogin(sender: UIButton) {
        
        let email = textFieldEmail!.text
        let password = textFieldPassword!.text
        
        let status = loginViewModel.validate(email, password: password)
        
        switch status {
        case .Failed(let msg):
            BPMessageFactory.makeMessage(.ERROR, message: msg).show()
        default:
            if let button = self.view.viewWithTag(LoginButtonTag) as? UIButton {
                button.enabled = false
            }
            do {
                try loginViewModel.loginResident(email!, password: password!)
                sender.addSubview(self.activityIndicator)
                self.activityIndicator.startAnimating()
            } catch let error as NSError {
                BPMessageFactory.makeMessage(.ERROR, message: error.description).show()
            }
        }
        
    }
    
    func presentForgotPasswordForm() {
        
        let alert = BPMessageFactory.makeMessage(
            .TEXT,
            message: "Please provide your email, so we can reset your password.")
        alert.delegate = self
        alert.show()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension BPLoginViewController : LoginDelegate {
    
    func didLogin(success: Bool, errorMsg: String?) {
        
        if let button = self.view.viewWithTag(LoginButtonTag) as? UIButton {
            button.enabled = true
            self.activityIndicator.removeFromSuperview()
        }
        
        switch success {
        case true: self.performSegueWithIdentifier(mainMenuSegueIdentifier, sender: self)
        default: BPMessageFactory.makeMessage(.ERROR, message: errorMsg!).show()
        }
        
    }
}
extension BPLoginViewController : GIDSignInUIDelegate {
    
}
extension BPLoginViewController : UIAlertViewDelegate {
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if let textField = alertView.textFieldAtIndex(0) {
            
            if buttonIndex == 0 { // send
                
                switch loginViewModel.validateEmail(textField.text) {
                case .Failed(let msg):
                    BPMessageFactory.makeMessage(.ERROR, message: msg).show()
                case .Passed:
                    let email = textField.text!
                    do {
                        try loginViewModel.sendPasswordForgottenEmail(email)
                    } catch let error as NSError {
                        BPMessageFactory.makeMessage(
                            .ALERT,
                            message: error.description).show()
                    }
                    
                }
                
            }
            
        }
        
    }
}
extension BPLoginViewController : ForgotPasswordDelegate {
    
    func didSendEmail(success:Bool, errorMsg:String?) {
        
        if success {
            BPMessageFactory.makeMessage(
                .ALERT,
                message: "We've sent you an email with instructions to reset your password, please check you email").show()
        } else {
            BPMessageFactory.makeMessage(
                .ALERT,
                message: errorMsg!).show()
        }
        
    }
}
