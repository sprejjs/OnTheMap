//
// Created by Vlad Spreys on 15/03/15.
// Copyright (c) 2015 Spreys.com. All rights reserved.
//

import Foundation

class ApiFactory {
    

    /**
     * Method converts JSON data retrieved from the PARSE API to an array of StudentLocation
     */ 
    class func getStudentsLocations(data: NSData) -> [StudentLocation]{
        var studentsLocations = [] as [StudentLocation]
        
        let jsonDict = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
        
        if jsonDict.count > 0 && jsonDict["results"]?.count > 0 {
            let results = jsonDict["results"] as! NSArray
            
            for(var i = 0; i < results.count; i++){
                studentsLocations.append(StudentLocation(dictionary: results[i] as! NSDictionary))
            }
        }
        
        return studentsLocations
    }
}
