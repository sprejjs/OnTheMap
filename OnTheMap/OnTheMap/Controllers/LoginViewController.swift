//
// Created by Vlad Spreys on 15/03/15.
// Copyright (c) 2015 Spreys.com. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController : UIViewController{
    
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
}
