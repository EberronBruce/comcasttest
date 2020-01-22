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
        if let url = URL(string: urlString) {
            let session = URLSession.shared
            session.dataTask(with: url) { (data, response, error) in

                
                if let responseData = data {
                    self.retrieveJSON(responseData: responseData as NSData)
                    
                    //Send back Data
                    self.sendNotificationOut()
                } else if (error != nil) {
                    print(error.debugDescription)
                }
                
            }.resume()
        } else {
            print("URL is not valid")
        }
        
    }
    
    //Mark: - This retrieves the JSon objects from the data response
    private func retrieveJSON(responseData: NSData) {
        do {
            let json = try JSONSerialization.jsonObject(with: responseData as Data, options: JSONSerialization.ReadingOptions.allowFragments)
            
            if let dictionary = json as? Dictionary<String, Any> {
                if let jsonInfoArray = dictionary[DATA_KEY] as? [Dictionary<String, Any>] {
                    self.parseJsonDataArray(jsonArray: jsonInfoArray)
                } else {
                    print("Cannot Get JSON from DATA KEY")
                }
            }
            
//            if json is Dictionary<String, Any> {
//                if let jsonInfoArray = json[DATA_KEY] as? NSArray {
//                    self.parseJsonDataArray(jsonInfoArray)
//
//                } else {
//                    print("Cannot Get JSON from DATA KEY")
//                }
//
//            }
            
            
        } catch {
            print("Unable to get Data from JSON")
        }
    }
    
    
    //Mark: - This function parses the json that is given to it as an array.
    private func parseJsonDataArray(jsonArray: [Dictionary<String,Any>]) {
        for jsonItem in jsonArray {
            
            if let title = jsonItem["title"] as? String, let link = jsonItem["link"] as? String {
                var description = jsonItem["description"] as? String
                    
                if description == nil {
                    description = "No Description"
                }
                
                var type: String?
                
                //This little bit replaces the type with a just the type of the image and remove the prefix of "image/"
                if let imageType = jsonItem["type"] as? String {
                    let typeChange = imageType.replacingOccurrences(of: "image/", with: "")
                    type = typeChange
                    
                } else {
                    type = nil
                }
                putDataIntoContainer(title: title, description: description!, link: link, type: type)
            }
        }
    }
    
    //Mark: - This function puts the data that is collected into the data container array.
    private func putDataIntoContainer(title: String, description: String, link: String, type: String?) {
        let data = DataContainer(title: title, description: description, type: type, link: link)
        dataContainer.append(data)
    }
    //Mark: - This function sends out the notification and gives it the data key so that the data can be retrieve from the listener.
    private func sendNotificationOut() {
        NotificationCenter.default.post(name: NSNotification.Name(API_NOTIFY), object: self, userInfo: [NOTIFY_DICT_KEY:dataContainer])
    }
    
    
}
