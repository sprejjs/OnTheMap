//
//  PreLoginViewController.swift
//  OnTheMap
//
//  Created by Vlad Spreys on 12/03/15.
//  Copyright (c) 2015 Spreys.com. All rights reserved.
//


import UIKit

class PreLoginViewController: UIViewController {
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // TODO Figure out if login required
        var segueIdentifier = false ? "ShowLoginView" : "ShowMainView"
        
        self.performSegueWithIdentifier(segueIdentifier, sender: self)
    }

}
