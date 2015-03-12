//
// Created by Vlad Spreys on 12/03/15.
// Copyright (c) 2015 Spreys.com. All rights reserved.
//

import Foundation

class ApiFacade : NSObject {

    private var studentsLocations : [StudentLocation]?
    
    /**
     * Method retrieves Students Locations from the Prase API, deserialises them into arrya of Students Locations and returns to the calling method.
     * Unless forceRefresh is set to true, method returns pre-cached responses instead of retrieving information from the cloud every time.
     */
    func getStudentsLocations(forceRefresh : Bool) -> [StudentLocation]?{
        
        if studentsLocations == nil || forceRefresh {
            let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
            request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
            
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request) { data, response, error in
                if error != nil { // Handle error...
                    return
                }
                println(NSString(data: data, encoding: NSUTF8StringEncoding))
                
                let jsonDict = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                
                if jsonDict.count > 0 && jsonDict["results"]?.count > 0 {
                    let results = jsonDict["results"] as NSArray
                    
                    self.studentsLocations = []
                    for(var i = 0; i < results.count; i++){
                        self.studentsLocations?.append(StudentLocation(dictionary: results[i] as NSDictionary))
                    }
                }
            }
            task.resume()
        }
        
        return studentsLocations
    }
}