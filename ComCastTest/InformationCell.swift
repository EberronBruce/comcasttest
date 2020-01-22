//
//  InformationCell.swift
//  ComCastTest
//
//  Created by Bruce Burgess on 8/10/16.
//  Copyright © 2016 Red Raven Computing Studios. All rights reserved.
//

/*
 This class is used to for custom cells for the table view
 
 */

import UIKit

class InformationCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageview: UIImageView!

    //Mark: - This take two strings, one for the title and other for the description and sets the labels to the text that is passed in.
    func setUpCell(title:String, description: String) {
        self.titleLabel.text = title
        self.descriptionLabel.text = description
    }
    //Mark: - This function takes an image and sets the image on the display to the one passed in.
    func updateCellImage(image: UIImage) {
        self.imageview.image = image
    }
}
