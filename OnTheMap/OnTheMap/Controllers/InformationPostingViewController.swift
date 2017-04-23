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
        self.btnFindOnTheMap.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#FFFFFF")), for: UIControlState())
        self.btnFindOnTheMap.layer.cornerRadius = 10
        self.btnFindOnTheMap.clipsToBounds = true
        
        //Customise the text field placeholder
        let color = UIColor.lightGray
        let attrs = [NSForegroundColorAttributeName : color]
        self.txtLocation.attributedPlaceholder = NSAttributedString(string: "Enter Details", attributes: attrs)
        
        //Hide navigation bar
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func findOnTheMap() {
        //Hide keyboard
        self.view.endEditing(true)
        
        //Try to geocode string
        let address = self.txtLocation.text

        //Display activity indicator
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address!) {
            (placemarks, error) -> Void in
            
            //Hide activity indicator
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if let firstPlacemark = placemarks?[0] {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.personalLocation.selectedLocation = MKPlacemark(placemark: firstPlacemark)
                appDelegate.personalLocation.mapString = address
                
                self.performSegue(withIdentifier: "MoveToMap", sender: self)
            } else {
                //Display an alert view
                let alert = UIAlertController(title: "Alert", message: "Unable to find this address", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        };
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == txtLocation){
            findOnTheMap()
        }
        return true
    }
}
