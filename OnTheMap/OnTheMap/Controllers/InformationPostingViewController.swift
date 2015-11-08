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
        let color = UIColor.lightGrayColor()
        let attrs = [NSForegroundColorAttributeName : color]
        self.txtLocation.attributedPlaceholder = NSAttributedString(string: "Enter Details", attributes: attrs)
        
        //Hide navigation bar
        self.navigationController?.navigationBarHidden = true
    }
    
    @IBAction func findOnTheMap() {
        //Hide keyboard
        self.view.endEditing(true)
        
        //Try to geocode string
        let address = self.txtLocation.text

        //Display activity indicator
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true

        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address!) {
            (placemarks, error) -> Void in
            
            //Hide activity indicator
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            if let firstPlacemark = placemarks?[0] {
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.personalLocation.selectedLocation = MKPlacemark(placemark: firstPlacemark)
                appDelegate.personalLocation.mapString = address
                
                self.performSegueWithIdentifier("MoveToMap", sender: self)
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
