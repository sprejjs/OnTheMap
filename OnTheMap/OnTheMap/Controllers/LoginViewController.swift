//
// Created by Vlad Spreys on 15/03/15.
// Copyright (c) 2015 Spreys.com. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController : UIViewController{
    @IBOutlet weak var btnLogin: UIButton!
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
    
    @IBAction func login(sender: UIButton) {
        //Display navigation bar before moving to the next view controller
        self.navigationController?.navigationBarHidden = false
        self.performSegueWithIdentifier("LoginCompleted", sender: self)
    }
    
    
    @IBAction func signUp(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signin")!)
    }
}
