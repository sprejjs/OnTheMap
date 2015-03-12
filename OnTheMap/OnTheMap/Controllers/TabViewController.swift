//
// Created by Vlad Spreys on 12/03/15.
// Copyright (c) 2015 Spreys.com. All rights reserved.
//

import UIKit
import Foundation

class TabViewController : UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "On The Map"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let apiFacade = appDelegate.apiFacade
        
        apiFacade.getStudentsLocations(false)
    }
}
