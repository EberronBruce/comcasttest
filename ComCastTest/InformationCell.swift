//
//  InformationCell.swift
//  ComCastTest
//
//  Created by Bruce Burgess on 8/10/16.
//  Copyright © 2016 Red Raven Computing Studios. All rights reserved.
//

import UIKit

class InformationCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUpCell(title title:String, description: String) {
        self.titleLabel.text = title
        self.descriptionLabel.text = description
    }
}
