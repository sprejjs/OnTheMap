//
// Created by Vlad Spreys on 15/03/15.
// Copyright (c) 2015 Spreys.com. All rights reserved.
//

import UIKit
import Foundation
import MapKit

class LocationsMapViewController : UIViewController, MKMapViewDelegate, ApiFacadeDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var studentsLocations: [StudentLocation]?
    
    override func viewWillAppear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let apiFacade = appDelegate.apiFacade
        apiFacade.delegate = self
        
        apiFacade.getStudentsLocations(false)
    }
    
    func studentsLocationsRetrieved(studentsLocations: [StudentLocation]?) {
        self.studentsLocations = studentsLocations?
        
        for studentLocation in self.studentsLocations! {
            self.addMapAnnotation(studentLocation)
        }
    }
    
    func addMapAnnotation(studentLocation: StudentLocation){
        
        let annotation = MKPointAnnotation()
        annotation.setCoordinate(studentLocation.location)
        annotation.title = studentLocation.name
        annotation.subtitle = studentLocation.mediaUrlAsString
        mapView.addAnnotation(annotation)
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        
        let url = NSURL(string: view.annotation!.subtitle!)!

        UIApplication.sharedApplication().openURL(url)
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier("PinAnnotationView")

        if (pinView == nil)
        {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "PinAnnotationView")
            pinView.canShowCallout = true;
            pinView.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIButton
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
}
