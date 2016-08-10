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