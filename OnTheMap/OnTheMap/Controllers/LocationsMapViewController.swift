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
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let apiFacade = appDelegate.apiFacade
        apiFacade.delegate = self
        
        apiFacade.getStudentsLocations(false)
    }
    
    func studentsLocationsRetrieved(_ studentsLocations: [StudentLocation]?) {
        self.studentsLocations = studentsLocations

        //Show an error message if no locations returned
        if(studentsLocations == nil){
            let alert = UIAlertController(title: nil, message: "Unable to retrieve student's locations. Please try again later",
                    preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        }
        
        //Clear old annotations
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        //Display newly received annotations
        for studentLocation in self.studentsLocations! {
            self.addMapAnnotation(studentLocation)
        }
    }
    
    func addMapAnnotation(_ studentLocation: StudentLocation){
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = studentLocation.location
        annotation.title = studentLocation.name
        annotation.subtitle = studentLocation.mediaUrlAsString
        mapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let url = URL(string: view.annotation!.subtitle!!)!

        UIApplication.shared.openURL(url)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "PinAnnotationView")

        if (pinView == nil)
        {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "PinAnnotationView")
            pinView!.canShowCallout = true;
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)// UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIButton
        } else {
            pinView!.annotation = annotation;
        }
        return pinView;
    }
}
