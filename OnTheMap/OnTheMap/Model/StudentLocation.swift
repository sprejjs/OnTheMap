//
// Created by Vlad Spreys on 12/03/15.
// Copyright (c) 2015 Spreys.com. All rights reserved.
//

import Foundation

class StudentLocation : NSObject {
    //TODO none of the variables should be optional
    //TODO all of them should be readonly
    var createdAt : NSDate?
    var firstName : String?
    var lastName : String?
    var latitude : Float?
    var longitude : Float?
    var mapString : String?
    var mediaUrl : NSURL?
    var objectId : String?
    var uniqueKey : String?
    var updatedAt : String?

    init(dictionary: NSDictionary){
        //TODO add jSON parsing logic here
        self.createdAt = nil//dictionary["createdAt"]
        self.firstName = nil
        self.lastName = nil
        self.latitude = nil
        self.longitude = nil
        self.mapString = nil
        self.mediaUrl = nil
        self.objectId = nil
        self.uniqueKey = nil
        self.updatedAt = nil
    }
}
