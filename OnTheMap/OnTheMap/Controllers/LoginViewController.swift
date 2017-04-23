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
        self.btnLogin.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#f45500")), for: UIControlState())
        self.btnLogin.layer.cornerRadius = 5
        self.btnLogin.clipsToBounds = true
        
        //Customize text view placeholders
        let attrs = [NSForegroundColorAttributeName : UIColor.white]
        self.txtUsername.attributedPlaceholder = NSAttributedString(string: "Email", attributes: attrs)
        self.txtPassword.attributedPlaceholder = NSAttributedString(string: "Password", attributes: attrs)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Temporary hide navigation bar
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func login() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let apiFacade = appDelegate.apiFacade
        apiFacade.delegate = self
        
        apiFacade.loginToUdacity(self.txtUsername.text!, password: self.txtPassword.text!)
        
        //show network activity indicator
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        disableButtons()
        
        //Hide keyboard
        self.view.endEditing(true)
    }
    
    @IBAction func signUp() {
        UIApplication.shared.openURL(URL(string: "https://www.udacity.com/account/auth#!/signin")!)
    }
    
    func loginFinished(_ successfull: Bool, badCredentials: Bool) {
        //Hide network activity indicator
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        enableButtons()
        
        if(successfull) {
            
            //Has to be executed on the main thread to prevent crashing
            DispatchQueue.main.async(execute: {
                //Display navigation bar before moving to the next view controller
                self.navigationController?.isNavigationBarHidden = false
                self.performSegue(withIdentifier: "LoginCompleted", sender: self)
            });
            
        } else {
            //Show an error alert
            var message : String
            
            if(badCredentials){
                message = "Invalid Credentials"
            } else {
                message = "Unable to connect to service"
            }
            
            let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func disableButtons(){
        self.btnLogin.isEnabled = false
        self.btnSignUp.isEnabled = false
    }
    
    func enableButtons(){
        self.btnLogin.isEnabled = true
        self.btnSignUp.isEnabled = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == self.txtUsername){//Move to password field
            self.txtPassword.becomeFirstResponder()
        }
        
        if(textField == self.txtPassword){//Initiate login
            login()
        }
        
        return true;
    }
}
