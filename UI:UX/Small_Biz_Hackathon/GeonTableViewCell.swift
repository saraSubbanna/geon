//
//  GeonTableViewCell.swift
//  Small_Biz_Hackathon
//
//  Created by Srividhya Gopalan on 8/1/15.
//  Copyright (c) 2015 Srividhya Gopalan. All rights reserved.
//

import UIKit

class GeonTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImage.layer.cornerRadius = 40
        profileImage.layer.masksToBounds = true
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
