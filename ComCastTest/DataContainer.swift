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
    private var _layout: String?
    private var _type: String?
    private var _link: String?
    private var _image: UIImage!
    
    init(title: String, description: String, layout: String, type: String, link: String) {
        self._title = title
        self._description = description
        self._layout = layout
        self._type = type
        self._link = link
    }
    
}