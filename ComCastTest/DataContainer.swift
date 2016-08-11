//
//  DataContainer.swift
//  ComCastTest
//
//  Created by Bruce Burgess on 8/9/16.
//  Copyright © 2016 Red Raven Computing Studios. All rights reserved.
//

import Foundation
import UIKit

class DataContainer {
    
    private var _title: String!
    private var _description: String!
    private var _type: String?
    private var _link: String!
    private var _image: UIImage?
    
    init(title: String, description: String, type: String?, link: String) {
        self._title = title
        self._description = description
        self._type = type
        self._link = link
    }
    
    var title: String{
        return _title
    }
    
    var description: String {
        return _description
    }
    
    var type: String? {
        if _type != nil {
            return _type!
        } else {
            return nil
        }
    }
    
    var image: UIImage? {
        set{
            _image = newValue
        }
        get {
            if _image != nil {
                return _image
            } else{
                return nil
            }
        }
    }
    
    var link: String {
        return _link
    }
    
}