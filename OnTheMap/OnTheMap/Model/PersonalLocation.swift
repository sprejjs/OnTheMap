//
// Created by Vlad Spreys on 16/03/15.
// Copyright (c) 2015 Spreys.com. All rights reserved.
//

import MapKit
import Foundation

class PersonalLocation : NSObject {
    
    var selectedLocation : MKPlacemark?
    var sessionId : String?
    var accountId : String?
    var firstName : String?
    var lastName : String?
    var mediaUrl : URL?
    var mapString : String?
    
    //computed property. Retuns latitude from the location selected by the user
    var latitude : Double{
        get {
            return selectedLocation?.coordinate.latitude as Double!
        }
    }
    
    //compputed property. Return logitued from the location selected by the suer
    var longitude : Double {
        get {
            return selectedLocation?.coordinate.longitude as Double!
        }
    }
    
}
