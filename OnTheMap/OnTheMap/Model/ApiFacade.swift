//
// Created by Vlad Spreys on 12/03/15.
// Copyright (c) 2015 Spreys.com. All rights reserved.
//

import UIKit
import Foundation

//@obj added so that we can downcat from AnyObject to ApiFacadeDelegate
@objc protocol ApiFacadeDelegate {
    @objc optional func studentsLocationsRetrieved(_ studentsLocations: [StudentLocation]?)
    @objc optional func loginFinished(_ successfull: Bool, badCredentials: Bool)
    @objc optional func accountDetailsRetrieved(_ successfull: Bool)
    @objc optional func userLocationSubmitted(_ successfull: Bool)
}

class ApiFacade : NSObject {

    fileprivate var studentsLocations : [StudentLocation]?
    var delegate : ApiFacadeDelegate?
    
    /**
     * Method retrieves Students Locations from the Prase API, deserialises them into arrya of Students Locations and returns to the calling method.
     * Unless forceRefresh is set to true, method returns pre-cached responses instead of retrieving information from the cloud every time.
    
     * Information returned in studentsLocationsRetrieved method of ApiFacadeDelegate
     */
    func getStudentsLocations(_ forceRefresh : Bool){
        
        if studentsLocations == nil || forceRefresh {
            let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
            request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
            
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                if error != nil {
                    //Send nil to the delegate, so that it can be handled appropriately.
                    self.delegate!.studentsLocationsRetrieved!(nil)
                    return
                }
                
                self.studentsLocations = ApiFactory.getStudentsLocations(data!)
                
                self.delegate!.studentsLocationsRetrieved!(self.studentsLocations)
            }) 
            task.resume()
        } else {
            //Return cached value
            self.delegate!.studentsLocationsRetrieved!(self.studentsLocations)
        }
    }
    
    func loginToUdacity(_ username: String, password: String){
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let httpBodyAsString = "{\"udacity\": {\"username\": \"" + username + "\", \"password\": \"" + password + "\"}}"
        
        request.httpBody = httpBodyAsString.data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            if error != nil {
                self.delegate!.loginFinished!(false, badCredentials: false)
            }
            let newData = data!.subdata(in: Range(5..<data!.count))
            
            let jsonDict = try! JSONSerialization.jsonObject(with: newData, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            
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
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.personalLocation.accountId = account["key"] as? String
                
                if let session = jsonDict["session"] as? NSDictionary{
                    appDelegate.personalLocation.sessionId = session["id"] as? String
                    self.delegate!.loginFinished!(true, badCredentials: false)
                    return
                }
            }
            
            //We should never reach the statement below. Something went wrong
            self.delegate!.loginFinished!(false, badCredentials: false)
        }) 
        task.resume()
    }
    
    /**
     * Method gets account details from the Udacity API. When request is completed method will notify ApiFacade delegate through accountDetailsRetrieved method
     */
    func getAccountDetails(_ accountId: String){
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/users/" + accountId)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            if error != nil { // Handle error...
                self.delegate!.accountDetailsRetrieved!(false)
                return
            }
            let newData = data!.subdata(in: Range(5..<data!.count)) /* subset response data! */
            let jsonDict = try! JSONSerialization.jsonObject(with: newData, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            
            if let user = jsonDict["user"] as? NSDictionary {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.personalLocation.firstName = user["first_name"] as? String
                appDelegate.personalLocation.lastName = user["last_name"] as? String
                
                //Request was successfull
                self.delegate!.accountDetailsRetrieved!(true)
                return
            }
            
            //We should never reach the statement below. Something went wrong
            self.delegate!.accountDetailsRetrieved!(false)
        }) 
        task.resume()
    }
    
    func submitPersonalLocation(_ personalLocation: PersonalLocation){
        var requestString = "{\"uniqueKey\": \"" + personalLocation.accountId! + "\", \"firstName\": \"" + personalLocation.firstName! + "\", \"lastName\": \""
        
        requestString += personalLocation.lastName! + "\",\"mapString\": \"" + personalLocation.mapString! + "\""
        requestString += ", \"mediaURL\": \"" + personalLocation.mediaUrl!.absoluteString + "\",\"latitude\": \(personalLocation.latitude), \"longitude\": \(personalLocation.longitude)}"
        
        let request = NSMutableURLRequest(url: URL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestString.data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            if error != nil {
                self.delegate!.userLocationSubmitted!(false)
                return
            }
            
            print("data")
            let jsonDict = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            
            if jsonDict["createdAt"] != nil {
                //Request successfull
                self.delegate!.userLocationSubmitted!(true)
            } else {
                self.delegate!.userLocationSubmitted!(false)
            }
        }) 
        task.resume()
    }
}
