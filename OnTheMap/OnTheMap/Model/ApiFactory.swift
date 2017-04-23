//
// Created by Vlad Spreys on 15/03/15.
// Copyright (c) 2015 Spreys.com. All rights reserved.
//

import Foundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class ApiFactory {
    

    /**
     * Method converts JSON data retrieved from the PARSE API to an array of StudentLocation
     */ 
    class func getStudentsLocations(_ data: Data) -> [StudentLocation]{
        var studentsLocations = [] as [StudentLocation]
        
        let jsonDict = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
        
        if jsonDict.count > 0 && (jsonDict["results"] as AnyObject).count > 0 {
            let results = jsonDict["results"] as! NSArray
            
            for result in results {
                studentsLocations.append(StudentLocation(dictionary: result as! NSDictionary))
            }
        }
        
        return studentsLocations
    }
}
