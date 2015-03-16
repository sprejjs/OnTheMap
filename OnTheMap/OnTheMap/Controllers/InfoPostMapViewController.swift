//
// Created by Vlad Spreys on 16/03/15.
// Copyright (c) 2015 Spreys.com. All rights reserved.
//

import UIKit
import Foundation
import MapKit

class InfoPostMapViewController : UIViewController, UITextFieldDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var txtUrl: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        var attrs = [NSForegroundColorAttributeName : UIColor.lightGrayColor()]
        self.txtUrl.attributedPlaceholder = NSAttributedString(string: "Enter URL", attributes: attrs)
        self.btnSubmit.layer.cornerRadius = 5
        self.btnSubmit.clipsToBounds = true
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.mapView.addAnnotation(appDelegate.personalLocation.selectedLocation)
        self.mapView.showAnnotations(mapView.annotations, animated: true)
    }
    

    @IBAction func submit() {
        //Hide the keyboard
        self.view.endEditing(true)
        
        //Validate URL
        if let url = NSURL(string: self.txtUrl.text) {
            //Url valid
            println(url == nil)
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            let alert = UIAlertController(title: nil, message: "Please enter a valid URL", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField == txtUrl){
            self.submit()
        }
        
        return true
    }
}
