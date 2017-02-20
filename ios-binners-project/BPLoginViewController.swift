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

let mainMenuSegueIdentifier = "MainMenuSegue"
let SignInSegueIdentifier = "SignInSegue"


let LoginButtonTag = 1

class BPLoginViewController: UIViewController {
    
    var textFieldEmail: UITextField?
    var textFieldPassword: UITextField?
    var loginViewModel = BPLoginViewModel()
    var activityIndicator:UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BPLoginViewController.dismissKeyboard))
        
        self.view.addSubview(createResidentForm())
        GIDSignIn.sharedInstance().uiDelegate = self
        textFieldEmail?.text = "matheus.ruschel@gmail.com"
        textFieldPassword?.text = "12345"
        self.loginViewModel.loginDelegate = self
        self.loginViewModel.passwordForgotDelegate = self
        
        view.addGestureRecognizer(tap)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let userDefaults = UserDefaults.standard
        if userDefaults.bool(forKey: "FirstAppLaunch") == false {
            performSegue(withIdentifier: "presentDescriptionPages", sender: self)
            userDefaults.set(true, forKey: "FirstAppLaunch")
            userDefaults.synchronize()
        }
       
    }
    //teste
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SignInSegueIdentifier {
            if let destVC = segue.destination as? BPSignInViewController {
                destVC.dismissDelegate = self
            }
        }
        
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
    
    func createAnAccountLink(_ form: UIView, index: Int) -> UIView {
        let formView = UIButton(frame: CGRect(
            x: 0,
            y: form.frame.height * 0.9,
            width: 120,
            height: 27))
        formView.center = formView.center
        formView.setTitleColor(UIColor.white, for: UIControlState())
        formView.titleLabel!.textAlignment = .left
        formView.titleLabel?.font = UIFont.binnersFontWithSize(12)
        formView.setTitle("Create an account", for: UIControlState())
        formView.addTarget(self,
                           action: #selector(createAccountButtonClicked),
                           for: .touchUpInside)

        return formView
    }
    
    func createForgotPasswordLink(_ form: UIView, index: Int) -> UIView {
        let formView = UIButton(frame: CGRect(
            x: form.frame.width - 120,
            y: form.frame.height * 0.9,
            width: 120,
            height: 27))
        formView.tag = LoginButtonTag
        formView.center = formView.center
        formView.setTitleColor(UIColor.white, for: UIControlState())
        formView.titleLabel!.textAlignment = .right
        formView.titleLabel?.font = UIFont.binnersFontWithSize(12)
        formView.setTitle("Forgot your password?", for: UIControlState())
        formView.addTarget(self,
                           action: #selector(presentForgotPasswordForm),
                           for: .touchUpInside)
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
    
    func createInputText(_ form: UIView, index: Int) -> UIView {
        
        let yPosButton = form.frame.height * 0.1
        
        let formView = UITextField(frame: CGRect(x: 0,
            y: yPosButton,
            width: form.frame.width,
            height: 20))
        formView.tag = 123
        formView.autocapitalizationType = .none
        formView.background = UIImage(named: "login-email-input-field.png")
        formView.textColor = UIColor.white
        formView.attributedPlaceholder =
            NSAttributedString(string: "Email",
                               attributes: [NSForegroundColorAttributeName : UIColor.white])
        formView.textAlignment = .center
        formView.keyboardType = UIKeyboardType.emailAddress
        formView.endEditing(true)
        textFieldEmail = formView
        return formView
    }
    
    func createInputPassword(_ form: UIView, index: Int) -> UIView {
        
        let viewEmail = form.viewWithTag(123)
        let initialPos = viewEmail!.frame.origin.y +
            viewEmail!.frame.height +
            viewEmail!.frame.height * 0.9
        
        let formView = UITextField(frame: CGRect(
            x: 0,
            y: initialPos,
            width: form.frame.width,
            height: 20))
        formView.autocapitalizationType = .none
        formView.background = UIImage(named: "login-password-input-field.png")
        formView.isSecureTextEntry = true
        formView.textColor = UIColor.white
        formView.attributedPlaceholder =
            NSAttributedString(string: "Password",
                               attributes:
                [NSForegroundColorAttributeName : UIColor.white])
        formView.textAlignment = .center
        textFieldPassword = formView
        formView.tag = 121
        return formView
    }
    
    func createButton(_ form: UIView, index: Int) -> UIView {
        
        let yPos = form.frame.size.height * 0.4
        
        let formView = UIButton(frame: CGRect(x: 0,
            y: yPos,
            width: form.frame.width,
            height: form.frame.height * 0.15))
        
        activityIndicator = UIActivityIndicatorView(
            frame: CGRect(x: 0,y: 0,width: 50,height: formView.frame.height))
        
        formView.backgroundColor = UIColor(netHex: 0x008DF0)
        formView.layer.cornerRadius = 4.0
        formView.setTitleColor(UIColor.white, for: UIControlState())
        formView.titleLabel?.font = UIFont.binnersFontWithSize(16)
        formView.setTitle("Log In", for: UIControlState())
        formView.addTarget(self,
                           action: #selector(BPLoginViewController.makeResidentLogin),
                           for: .touchUpInside)
        return formView
    }
    
    func createFacebookLoginButton(_ form: UIView, index: Int) -> UIView {
        
        //Screen and divider dimensions
        let buttomWidth = CGFloat(form.frame.width/3 - 10)
        let buttomHeight = CGFloat(50)
        
        let formView = UIButton(frame: CGRect(x: 0,
            y: form.frame.height * 0.6,
            width: buttomWidth,
            height: buttomHeight))
        
        let imageName = "facebookButton"
        let image = UIImage(named: imageName)
        formView.layer.contents = image!.cgImage
        formView.layer.contentsGravity = kCAGravityResizeAspect
        
        formView.addTarget(self,
                           action: #selector(BPLoginViewController.loginWithFacebook(_:)),
                           for: UIControlEvents.touchUpInside)
        
        return formView
    }
    
    func createGoogleLoginButton(_ form: UIView, index: Int) -> UIView {
        let buttomWidth = CGFloat(form.frame.width/3 - 10)
        let buttomHeight = CGFloat(50)
        let formView = UIButton(frame: CGRect(x: buttomWidth+10,
            y: form.frame.height * 0.6,
            width: buttomWidth,
            height: buttomHeight))
        let imageName = "googleButton"
        let image = UIImage(named: imageName)
        formView.layer.contents = image!.cgImage
        formView.layer.contentsGravity = kCAGravityResizeAspect
        formView.addTarget(self,
                           action: #selector(BPLoginViewController.loginWithGoogle(_:)),
                           for: UIControlEvents.touchUpInside)
        return formView
    }
    
    func createTwitterLoginButton(_ form: UIView, index: Int) -> UIView {
        let buttomWidth = CGFloat(form.frame.width/3 - 10)
        let buttomHeight = CGFloat(50)
        let formView = UIButton(frame: CGRect(
            x: (buttomWidth*2)+20,
            y: form.frame.height * 0.6,
            width: buttomWidth,
            height: buttomHeight))
        let imageName = "TwitterButton"
        let image = UIImage(named: imageName)
        formView.layer.contents = image!.cgImage
        formView.layer.contentsGravity = kCAGravityResizeAspect
        formView.addTarget(self,
                           action: #selector(BPLoginViewController.loginWithTwitter(_:)),
                           for: UIControlEvents.touchUpInside)
        return formView
    }

    
    // MARK: Login - FB
    
    func loginWithFacebook(_ sender: UIButton) {
        loginViewModel.authenticateUserWithFacebook()
    }
    
    
    func loginWithGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }

    // MARK: Login - TWITTER
    
    func loginWithTwitter(_ sender: UIButton) {
        loginViewModel.authenticateUserWithTwitter()
    }
    
    // MARK: Login - Resident
    
    func makeResidentLogin(_ sender: UIButton) {
        
        let email = textFieldEmail!.text
        let password = textFieldPassword!.text
        
        let status = loginViewModel.validate(email, password: password)
        
        switch status {
        case .failed(let msg):
            BPMessageFactory.makeMessage(.error, message: msg).show()
        default:
            if let button = self.view.viewWithTag(LoginButtonTag) as? UIButton {
                button.isEnabled = false
            }
            loginViewModel.loginResident(email!, password: password!)
            sender.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
        }
        
    }
    
    func presentForgotPasswordForm() {
        
        let alert = BPMessageFactory.makeMessage(
            .text,
            message: "Please provide your email, so we can reset your password.")
        alert.delegate = self
        alert.show()
    }
    
    func createAccountButtonClicked() {
        self.performSegue(withIdentifier: SignInSegueIdentifier, sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }

}

extension BPLoginViewController : LoginDelegate {
    
    func didLogin(_ success: Bool, errorMsg: String?) {
        
        if let button = self.view.viewWithTag(LoginButtonTag) as? UIButton {
            button.isEnabled = true
            self.activityIndicator.removeFromSuperview()
        }
        
        switch success {
        case true: self.performSegue(withIdentifier: mainMenuSegueIdentifier, sender: self)
        default: BPMessageFactory.makeMessage(.error, message: errorMsg!).show()
        }
        
    }
}
extension BPLoginViewController : GIDSignInUIDelegate {
    
}
extension BPLoginViewController : UIAlertViewDelegate {
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        
        if let textField = alertView.textField(at: 0) {
            
            if buttonIndex == 0 { // send
                
                switch loginViewModel.validateEmail(textField.text) {
                case .failed(let msg):
                    BPMessageFactory.makeMessage(.error, message: msg).show()
                case .passed:
                    let email = textField.text!
                    loginViewModel.sendPasswordForgottenEmail(email)
                }
                
            }
            
        }
        
    }
}
extension BPLoginViewController : ForgotPasswordDelegate {
    
    func didSendEmail(_ success:Bool, errorMsg:String?) {
        
        if success {
            BPMessageFactory.makeMessage(
                .alert,
                message: "We've sent you an email with instructions to reset your password, please check your email").show()
        } else {
            BPMessageFactory.makeMessage(
                .alert,
                message: errorMsg!).show()
        }
        
    }
}
extension BPLoginViewController : SignInDismissDelegate {
    
    func didDismissView() {
        self.performSegue(withIdentifier: mainMenuSegueIdentifier, sender: self)
    }
}

