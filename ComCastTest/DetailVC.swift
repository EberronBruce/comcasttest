//
//  DetailVC.swift
//  ComCastTest
//
//  Created by Bruce Burgess on 8/10/16.
//  Copyright © 2016 Red Raven Computing Studios. All rights reserved.
//

/*
 This view controller manages the detail screen and populates that information on that screen.
 */

import UIKit

class DetailVC: UIViewController {
    
    var data: DataContainer! = nil

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        descriptionLabel.text = data.description
        titleLabel.text = data.title
        if data.image != nil {
            imageView.image = data.image
        } else {
            imageView.image = UIImage(named: "empty")
        }
    }

}
