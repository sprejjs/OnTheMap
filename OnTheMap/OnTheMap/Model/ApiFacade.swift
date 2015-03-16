//
// Created by Vlad Spreys on 12/03/15.
// Copyright (c) 2015 Spreys.com. All rights reserved.
//

import UIKit
import Foundation

//@obj added so that we can downcat from AnyObject to ApiFacadeDelegate
@objc protocol ApiFacadeDelegate {
    optional func studentsLocationsRetrieved(studentsLocations: [StudentLocation]?)
    optional func loginFinished(successfull: Bool, badCredentials: Bool)
    optional func accountDetailsRetrieved(successfull: Bool)
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
        
        var httpBodyAsString = "{\"udacity\": {\"username\": \"" + username + "\", \"password\": \"" + password + "\"}}"
        
        request.HTTPBody = httpBodyAsString.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                self.delegate!.loginFinished!(false, badCredentials: false)
            }
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
            let jsonDict = NSJSONSerialization.JSONObjectWithData(newData, options: nil, error: nil)! as NSDictionary
            
            //Check status for error
            if let status = jsonDict["status"] as? Double {
                switch status as Double{
                    case 403, 400:
                        self.delegate!.loginFinished!(false, badCredentials: true)
                    default:
                        self.delegate!.loginFinished!(false, badCredentials: false)
                }
                return;
            }
            
            //Check if login was successfull
            if let account = jsonDict["account"] as? NSDictionary {
                let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
                appDelegate.personalLocation.accountId = account["key"] as? String
                
                if let session = jsonDict["session"] as? NSDictionary{
                    appDelegate.personalLocation.sessionId = session["id"] as? String
                    self.delegate!.loginFinished!(true, badCredentials: false)
                    return
                }
            }
            
            //We should never reach the statement below. Something went wrong
            self.delegate!.loginFinished!(false, badCredentials: false)
        }
        task.resume()
    }
    
    /**
     * Method gets account details from the Udacity API. When request is completed method will notify ApiFacade delegate through accountDetailsRetrieved method
     */
    func getAccountDetails(accountId: String){
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/" + accountId)!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                self.delegate!.accountDetailsRetrieved!(false)
                return
            }
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            let jsonDict = NSJSONSerialization.JSONObjectWithData(newData, options: nil, error: nil)! as NSDictionary
            
            if let user = jsonDict["user"] as? NSDictionary {
                let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
                appDelegate.personalLocation.firstName = user["first_name"] as? String
                appDelegate.personalLocation.lastName = user["last_name"] as? String
                
                //Request was successfull
                self.delegate!.accountDetailsRetrieved!(true)
            }
            
            //We should never reach the statement below. Something went wrong
            self.delegate!.accountDetailsRetrieved!(false)
            println(NSString(data: newData, encoding: NSUTF8StringEncoding))
        }
        task.resume()
    }
}