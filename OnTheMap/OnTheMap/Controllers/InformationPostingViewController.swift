//
// Created by Vlad Spreys on 15/03/15.
// Copyright (c) 2015 Spreys.com. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class InformationPostingViewController : UIViewController {
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
    }
    
    @IBAction func findOnTheMap() {
        //Try to geocode string
        var address = self.txtLocation.text
        
        var geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) {
            let placemakrs = $0
            let error = $1
            if let placemarks = $0 {
                println("geocoder is successfull")
            } else {
                //Display an alert view
                let alert = UIAlertView()
                alert.title = "Alert"
                alert.message = "Unable to find this address"
                alert.addButtonWithTitle("OK")
                alert.show()
            }
        };
    }
}
