//
// Created by Vlad Spreys on 15/03/15.
// Copyright (c) 2015 Spreys.com. All rights reserved.
//

import UIKit
import Foundation

class LocationsTableViewController: UITableViewController, ApiFacadeDelegate {
    
    var studentsLocations: [StudentLocation]?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let apiFacade = appDelegate.apiFacade
        apiFacade.delegate = self
        
        apiFacade.getStudentsLocations(false)
    }
    
    func studentsLocationsRetrieved(studentsLocations: [StudentLocation]?) {
        self.studentsLocations = studentsLocations?
        
        //Needs to be called on the main thread, to ensure the view is updated
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })

    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let studentsLocations = self.studentsLocations? {
            return studentsLocations.count
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("NameCell", forIndexPath: indexPath) as UITableViewCell
        
        var studentLocation = self.studentsLocations![indexPath.item] as StudentLocation
        
        cell.textLabel?.text = studentLocation.name
        cell.imageView?.image = UIImage(named: "PinIcon")
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let studentLocation = self.studentsLocations![indexPath.item] as StudentLocation
        
        UIApplication.sharedApplication().openURL(studentLocation.mediaUrl)
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
