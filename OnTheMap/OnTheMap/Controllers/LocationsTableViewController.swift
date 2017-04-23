//
// Created by Vlad Spreys on 15/03/15.
// Copyright (c) 2015 Spreys.com. All rights reserved.
//

import UIKit
import Foundation

class LocationsTableViewController: UITableViewController, ApiFacadeDelegate {
    
    var studentsLocations: [StudentLocation]?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let apiFacade = appDelegate.apiFacade
        apiFacade.delegate = self
        
        apiFacade.getStudentsLocations(false)
    }
    
    func studentsLocationsRetrieved(_ studentsLocations: [StudentLocation]?) {
        self.studentsLocations = studentsLocations

        if(studentsLocations == nil) {
            let alert = UIAlertController(title: nil, message: "Unable to retrieve student's locations. Please try again later",
                    preferredStyle: UIAlertControllerStyle.alert)
            present(alert, animated: true, completion: nil);
        }
        
        //Needs to be called on the main thread, to ensure the view is updated
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if studentsLocations != nil {
            return studentsLocations!.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath) as UITableViewCell
        
        let studentLocation = self.studentsLocations![indexPath.item] as StudentLocation
        
        cell.textLabel?.text = studentLocation.name
        cell.imageView?.image = UIImage(named: "PinIcon")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentLocation = self.studentsLocations![indexPath.item] as StudentLocation
        
        UIApplication.shared.openURL(studentLocation.mediaUrl as! URL)
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
