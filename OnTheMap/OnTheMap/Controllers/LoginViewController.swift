//
// Created by Vlad Spreys on 15/03/15.
// Copyright (c) 2015 Spreys.com. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController : UIViewController, ApiFacadeDelegate, UITextFieldDelegate{
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Customize login button
        self.btnLogin.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#f45500")), forState: .Normal)
        self.btnLogin.layer.cornerRadius = 5
        self.btnLogin.clipsToBounds = true
        
        //Customize text view placeholders
        var attrs = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.txtUsername.attributedPlaceholder = NSAttributedString(string: "Email", attributes: attrs)
        self.txtPassword.attributedPlaceholder = NSAttributedString(string: "Password", attributes: attrs)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Temporary hide navigation bar
        self.navigationController?.navigationBarHidden = true
    }
    
    @IBAction func login() {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let apiFacade = appDelegate.apiFacade
        apiFacade.delegate = self
        
        apiFacade.loginToUdacity(self.txtUsername.text, password: self.txtPassword.text)
        
        //show network activity indicator
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        disableButtons()
        
        //Hide keyboard
        self.view.endEditing(true)
    }
    
    @IBAction func signUp() {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signin")!)
    }
    
    func loginFinished(successfull: Bool, badCredentials: Bool) {
        //Hide network activity indicator
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        enableButtons()
        
        if(successfull) {
            
            //Has to be executed on the main thread to prevent crashing
            dispatch_async(dispatch_get_main_queue(), {
                //Display navigation bar before moving to the next view controller
                self.navigationController?.navigationBarHidden = false
                self.performSegueWithIdentifier("LoginCompleted", sender: self)
            });
            
        } else {
            //Show an error alert
            var message : String
            
            if(badCredentials){
                message = "Invalid Credentials"
            } else {
                message = "Unable to connect to service"
            }
            
            let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func disableButtons(){
        self.btnLogin.enabled = false
        self.btnSignUp.enabled = false
    }
    
    func enableButtons(){
        self.btnLogin.enabled = true
        self.btnSignUp.enabled = true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField == self.txtUsername){//Move to password field
            self.txtPassword.becomeFirstResponder()
        }
        
        if(textField == self.txtPassword){//Initiate login
            login()
        }
        
        return true;
    }
}
