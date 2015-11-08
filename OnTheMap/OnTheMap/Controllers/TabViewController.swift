//
// Created by Vlad Spreys on 12/03/15.
// Copyright (c) 2015 Spreys.com. All rights reserved.
//

import UIKit
import Foundation

class TabViewController : UITabBarController, ApiFacadeDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "On The Map"
    }

    @IBAction func refreshStudentsLocations(sender: UIBarButtonItem) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let apiFacade = appDelegate.apiFacade
        apiFacade.delegate = self
        
        apiFacade.getStudentsLocations(true)
    }
    
    func studentsLocationsRetrieved(studentsLocations: [StudentLocation]?) {
        self.updateChildViewControllers(studentsLocations!, childViewControllers: self.childViewControllers)
    }
    
    /**
    * Method recursively goes through all of the child view controllers and updates their students locations if they confront to ApiFacadeDelegate
    * protocol
    */
    func updateChildViewControllers(studentsLocations: [StudentLocation], childViewControllers: [AnyObject]?){
        
        for childViewController in childViewControllers! {
            if let apiFacadeDelegate = childViewController as? ApiFacadeDelegate {
                apiFacadeDelegate.studentsLocationsRetrieved!(studentsLocations)
            }
            
            if childViewController.childViewControllers != nil {
                self.updateChildViewControllers(studentsLocations, childViewControllers: childViewController.childViewControllers)
            }
        }
        
    }
}
