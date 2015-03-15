//
// Created by Vlad Spreys on 12/03/15.
// Copyright (c) 2015 Spreys.com. All rights reserved.
//

import Foundation

//@obj added so that we can downcat from AnyObject to ApiFacadeDelegate
@objc protocol ApiFacadeDelegate {
    optional func studentsLocationsRetrieved(studentsLocations: [StudentLocation]?)
    optional func loginFinished(successfull: Bool, badCredentials: Bool)
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
                
                self.delegate!.studentsLocationsRetrieved!(self.studentsLocations)
            }
            task.resume()
        } else {
            //Return cached value
            self.delegate!.studentsLocationsRetrieved!(self.studentsLocations)
        }
    }
    
    func loginToUdacity(username: String, password: String){
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"account@domain.com\", \"password\": \"********\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                self.delegate!.loginFinished!(false, badCredentials: false)
            }
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            println(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            let jsonDict = NSJSONSerialization.JSONObjectWithData(newData, options: nil, error: nil)! as NSDictionary
            
            switch jsonDict["status"] as Double{
                case 403:
                    self.delegate!.loginFinished!(false, badCredentials: true)
                default:
                    self.delegate!.loginFinished!(false, badCredentials: false)
            }
        }
        task.resume()
    }
}