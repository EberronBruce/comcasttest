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
            
            if let title = jsonItem["title"] as? String, let description = jsonItem["description"] as? String, let link = jsonItem["link"] as? String {
                
                var type: String?
                
                if let imageType = jsonItem["type"] as? String {
                    let typeChange = imageType.stringByReplacingOccurrencesOfString("image/", withString: "")
                    type = typeChange
                    
                } else {
                    type = nil
                }
                
                putDataIntoContainer(title: title, description: description, link: link, type: type)
            }
        }
    }
    
    private func putDataIntoContainer(title title: String, description: String, link: String, type: String?) {
        let data = DataContainer(title: title, description: description, type: type, link: link)
        dataContainer.append(data)
    }
    
    private func sendNotificationOut() {
        NSNotificationCenter.defaultCenter().postNotificationName(API_NOTIFY, object: self, userInfo: [NOTIFY_DICT_KEY:dataContainer])
    }
    
    func downloadImage(urlString link: String, imageAquired:(image: UIImage, success: Bool) -> Void) {
        if let url = NSURL(string: link) {
            if let data = NSData(contentsOfURL: url) {
                if let img = UIImage(data: data) {
                    print("Image downloaded")
                    imageAquired(image: img, success: true)
                } else {
                    print("Cannot convert image data")
                }
            } else {
                print("Could not get Image Data from URL")
            }
        } else {
            print("Could not get URL from String")
        }
    }
    
    
    
}
