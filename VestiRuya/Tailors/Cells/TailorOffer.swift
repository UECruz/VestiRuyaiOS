//
//  TailorOffer.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 10/26/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import UIKit

class TailorOffer: UITableViewCell {

    @IBOutlet weak var check: UIImageView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var tailorName: UILabel!
    @IBOutlet weak var tailorPic: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
