//
// Created by Vlad Spreys on 12/03/15.
// Copyright (c) 2015 Spreys.com. All rights reserved.
//

import Foundation
import CoreLocation

class StudentLocation : NSObject {
    private(set) var createdAt : NSDate
    private(set) var firstName : String
    private(set) var lastName : String
    private(set) var latitude : Double
    private(set) var longitude : Double
    private(set) var mapString : String
    private(set) var mediaUrl : NSURL
    private(set) var objectId : String
    private(set) var uniqueKey : String
    private(set) var updatedAt : NSDate

    init(dictionary: NSDictionary){
        //Parse Strings
        self.firstName = dictionary["firstName"] as String
        self.lastName = dictionary["lastName"] as String
        self.objectId = dictionary["objectId"] as String
        self.uniqueKey = dictionary["uniqueKey"] as String
        self.mapString = dictionary["mapString"] as String
        
        //Parse URL
        self.mediaUrl = NSURL(string: dictionary["mediaURL"] as String)!
        
        //Parse Doubles
        self.latitude = dictionary["latitude"] as Double
        self.longitude = dictionary["longitude"] as Double
        
        //Parse Dates
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        self.createdAt = dateFormatter.dateFromString(dictionary["createdAt"] as String)!
        self.updatedAt = dateFormatter.dateFromString(dictionary["updatedAt"] as String)!
    }
    
    //Computed property returns first and last name combined
    var name : String {
        get {
            return self.firstName + " " + self.lastName
        }
    }
    
    //Computed property, returns student location as CLLocationCoordinate2D struct
    var location : CLLocationCoordinate2D {
        get {
            let studentInstance = self
            return CLLocationCoordinate2D(
                latitude: studentInstance.latitude,
                longitude: studentInstance.longitude
            )
        }
    }
    
    //Computed property, returns student's media url as string
    var mediaUrlAsString : String {
        get {
            return self.mediaUrl.absoluteString!
        }
    }
}
