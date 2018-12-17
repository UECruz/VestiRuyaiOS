//
//  JobCell.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 10/22/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import UIKit

class JobCell: UITableViewCell {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var profilePic: UIImageView!{
        didSet {
            profilePic.layer.cornerRadius = profilePic.bounds.width/2
            profilePic.layer.masksToBounds = true
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
