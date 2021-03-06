//
// Created by Vlad Spreys on 16/03/15.
// Copyright (c) 2015 Spreys.com. All rights reserved.
//

import UIKit
import Foundation
import MapKit

class InfoPostMapViewController : UIViewController, UITextFieldDelegate, MKMapViewDelegate, ApiFacadeDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var txtUrl: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        let attrs = [NSForegroundColorAttributeName : UIColor.lightGray]
        self.txtUrl.attributedPlaceholder = NSAttributedString(string: "Enter URL", attributes: attrs)
        self.btnSubmit.layer.cornerRadius = 5
        self.btnSubmit.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.mapView.addAnnotation(appDelegate.personalLocation.selectedLocation!)
        self.mapView.showAnnotations(mapView.annotations, animated: true)
    }
    

    @IBAction func submit() {
        //Hide the keyboard
        self.view.endEditing(true)
        
        //Disable button
        self.btnSubmit.isEnabled = false
        
        //Validate URL
        let addedUrl = self.txtUrl.text
        
        if isValidUrl(addedUrl!) {
            //Url valid
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.personalLocation.mediaUrl = URL(string: addedUrl!) 
            
            //Make the service call
            appDelegate.apiFacade.delegate = self
            appDelegate.apiFacade.getAccountDetails(appDelegate.personalLocation.accountId!)
        } else {
            let alert = UIAlertController(title: nil, message: "Please enter a valid URL", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func accountDetailsRetrieved(_ successfull: Bool) {
        self.btnSubmit.isEnabled = true
        if(!successfull){
            let alert = UIAlertController(title: nil, message: "Unable to retrieve your information from the Udacity API. Please try again later.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        } else {            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.apiFacade.delegate = self
            appDelegate.apiFacade.submitPersonalLocation(appDelegate.personalLocation)
        }
    }
    
    func userLocationSubmitted(_ successfull: Bool) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /**
     * Method is meant to validate the URL address. It checks wheter connection can be made to the supplied URL address.
     * Method will return false either if url is not valid or connection to the URL address cannot be made (due to the network failure
     * for example). As per the stackoverflow (http://stackoverflow.com/questions/1471201/how-to-validate-an-url-on-the-iphone) there is no
     * perfect solution 
     */
    func isValidUrl(_ url: String) -> Bool {
        let request = URLRequest(url: URL(string: url)!)
        
        return NSURLConnection.canHandle(request)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == txtUrl){
            self.submit()
        }
        
        return true
    }
}
