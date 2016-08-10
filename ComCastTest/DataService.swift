//
//  DataService.swift
//  ComCastTest
//
//  Created by Bruce Burgess on 8/9/16.
//  Copyright © 2016 Red Raven Computing Studios. All rights reserved.
//

import Foundation
import UIKit


class DataService {
    
    func getInformationFromApi(urlString: String) {
        if let url = NSURL(string: urlString) {
            let session = NSURLSession.sharedSession()
            session.dataTaskWithURL(url, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) in
                
                if let responseData = data {
                    self.retrieveJSON(responseData)
                    
                    //Send back Data
                } else if (error != nil) {
                    print(error.debugDescription)
                }
                
            }).resume()
        } else {
            print("URL is not valid")
        }
        
    }
    
    private func retrieveJSON(responseData: NSData) {
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.AllowFragments)
            
            if json is Dictionary<String, AnyObject> {
                if let jsonInfoArray = json[DATA_KEY] as? NSArray {
                    self.parseJsonDataArray(jsonInfoArray)
                    
                } else {
                    print("Cannot Get JSON from DATA KEY")
                }
                
            }
            
            
        } catch {
            print("Unable to get Data from JSON")
        }
    }
    
    private func parseJsonDataArray(jsonArray: NSArray) {
        for jsonItem in jsonArray {
            
            if let type = jsonItem["type"] as? String {
                let typeChange = type.stringByReplacingOccurrencesOfString("image/", withString: "")
                //TODO
            } else {
                
            }
        }
    }
    
}
