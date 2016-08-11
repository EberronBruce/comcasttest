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
    
    private var dataContainer = [DataContainer]()
    
    //Mark: - This starts the API call give a string that represents the URL for the API
    func getInformationFromApi(urlString: String) {
        if let url = NSURL(string: urlString) {
            let session = NSURLSession.sharedSession()
            session.dataTaskWithURL(url, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) in
                
                if let responseData = data {
                    self.retrieveJSON(responseData)
                    
                    //Send back Data
                    self.sendNotificationOut()
                } else if (error != nil) {
                    print(error.debugDescription)
                }
                
            }).resume()
        } else {
            print("URL is not valid")
        }
        
    }
    
    //Mark: - This retrieves the JSon objects from the data response
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
    
    
    //Mark: - This function parses the json that is given to it as an array.
    private func parseJsonDataArray(jsonArray: NSArray) {
        for jsonItem in jsonArray {
            
            if let title = jsonItem["title"] as? String, let link = jsonItem["link"] as? String {
                var description = jsonItem["description"] as? String
                    
                if description == nil {
                    description = "No Description"
                }
                
                var type: String?
                
                //This little bit replaces the type with a just the type of the image and remove the prefix of "image/"
                if let imageType = jsonItem["type"] as? String {
                    let typeChange = imageType.stringByReplacingOccurrencesOfString("image/", withString: "")
                    type = typeChange
                    
                } else {
                    type = nil
                }
                putDataIntoContainer(title: title, description: description!, link: link, type: type)
            }
        }
    }
    
    //Mark: - This function puts the data that is collected into the data container array.
    private func putDataIntoContainer(title title: String, description: String, link: String, type: String?) {
        let data = DataContainer(title: title, description: description, type: type, link: link)
        dataContainer.append(data)
    }
    //Mark: - This function sends out the notification and gives it the data key so that the data can be retrieve from the listener.
    private func sendNotificationOut() {
        NSNotificationCenter.defaultCenter().postNotificationName(API_NOTIFY, object: self, userInfo: [NOTIFY_DICT_KEY:dataContainer])
    }
    
    
}
