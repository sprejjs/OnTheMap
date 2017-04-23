//
// Created by Vlad Spreys on 12/03/15.
// Copyright (c) 2015 Spreys.com. All rights reserved.
//

import Foundation
import CoreLocation

class StudentLocation : NSObject {
    fileprivate(set) var createdAt : Date
    fileprivate(set) var firstName : String
    fileprivate(set) var lastName : String
    fileprivate(set) var latitude : Double
    fileprivate(set) var longitude : Double
    fileprivate(set) var mediaUrl : URL?
    fileprivate(set) var objectId : String
    fileprivate(set) var uniqueKey : String
    fileprivate(set) var updatedAt : Date

    init(dictionary: NSDictionary){
        //Parse Strings
        self.firstName = dictionary["firstName"] as! String
        self.lastName = dictionary["lastName"] as! String
        self.objectId = dictionary["objectId"] as! String
        self.uniqueKey = dictionary["uniqueKey"] as! String
        
        //Parse URL
        self.mediaUrl = URL(string: dictionary["mediaURL"] as! String)
        
        //Parse Doubles
        self.latitude = dictionary["latitude"] as! Double
        self.longitude = dictionary["longitude"] as! Double
        
        //Parse Dates
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        self.createdAt = dateFormatter.date(from: dictionary["createdAt"] as! String)!
        self.updatedAt = dateFormatter.date(from: dictionary["updatedAt"] as! String)!
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
            if mediaUrl != nil {
                return mediaUrl!.absoluteString
            } else {
                return ""
            }
        }
    }
}
