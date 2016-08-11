//
//  Constants.swift
//  ComCastTest
//
//  Created by Bruce Burgess on 8/9/16.
//  Copyright © 2016 Red Raven Computing Studios. All rights reserved.
//

import Foundation


// URL For the API
let API_URL = "https://api.myjson.com/bins/4je7x"

// Key to get array for information on API call
let DATA_KEY = "data"

//This is used for the Notification after API call is finished
let API_NOTIFY = "api.notify.finish"
let NOTIFY_DICT_KEY = "data"

//This sets up private constants for the username and password
class privateConstants {
    private let _USERNAME = "john"
    private let _PASSWORD = "doe"
    
    var USERNAME: String{
        return _USERNAME
    }
    
    var PASSWORD: String{
        return _PASSWORD
    }
}