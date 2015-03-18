//
// Created by Vlad Spreys on 15/03/15.
// Copyright (c) 2015 Spreys.com. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import MapKit

class InformationPostingViewController : UIViewController, UITextFieldDelegate {
    @IBOutlet weak var btnFindOnTheMap: UIButton!
    @IBOutlet weak var txtLocation: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Customise the find button
        self.btnFindOnTheMap.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#FFFFFF")), forState: .Normal)
        self.btnFindOnTheMap.layer.cornerRadius = 10
        self.btnFindOnTheMap.clipsToBounds = true
        
        //Customise the text field placeholder
        var color = UIColor.lightGrayColor()
        var attrs = [NSForegroundColorAttributeName : color]
        self.txtLocation.attributedPlaceholder = NSAttributedString(string: "Enter Details", attributes: attrs)
        
        //Hide navigation bar
        self.navigationController?.navigationBarHidden = true
    }
    
    @IBAction func findOnTheMap() {
        //Hide keyboard
        self.view.endEditing(true)
        
        //Try to geocode string
        var address = self.txtLocation.text

        //Display activity indicator
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true

        var geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) {
            //Hide activity indicator
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false

            let placemakrs = $0
            let error = $1
            if let placemarks = $0 {
                
                if let placemark = placemakrs[0] as? CLPlacemark {
                    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
                    appDelegate.personalLocation.selectedLocation = MKPlacemark(placemark: placemark)
                    appDelegate.personalLocation.mapString = address
                    
                    self.performSegueWithIdentifier("MoveToMap", sender: self)
                }
                
            } else {
                //Display an alert view
                let alert = UIAlertController(title: "Alert", message: "Unable to find this address", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        };
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField == txtLocation){
            findOnTheMap()
        }
        return true
    }
}
