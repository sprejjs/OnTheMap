//
// Created by Vlad Spreys on 12/03/15.
// Copyright (c) 2015 Spreys.com. All rights reserved.
//

import Foundation

protocol ApiFacadeDelegate {
    func studentsLocationsRetrieved(studentsLocations: [StudentLocation]?)
}

class ApiFacade : NSObject {

    private var studentsLocations : [StudentLocation]?
    var delegate : ApiFacadeDelegate?
    
    /**
     * Method retrieves Students Locations from the Prase API, deserialises them into arrya of Students Locations and returns to the calling method.
     * Unless forceRefresh is set to true, method returns pre-cached responses instead of retrieving information from the cloud every time.
    
     * Information returned in studentsLocationsRetrieved method of ApiFacadeDelegate
     */
    func getStudentsLocations(forceRefresh : Bool){
        
        if studentsLocations == nil || forceRefresh {
            let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
            request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
            
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request) { data, response, error in
                if error != nil { return }
                
                self.studentsLocations = ApiFactory.getStudentsLocations(data)            
                
                self.delegate!.studentsLocationsRetrieved(self.studentsLocations)
            }
            task.resume()
        } else {
            //Return cached value
            self.delegate!.studentsLocationsRetrieved(self.studentsLocations)
        }
    }
}