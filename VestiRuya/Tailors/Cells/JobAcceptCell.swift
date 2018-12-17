//
//  JobAcceptCell.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 10/26/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import UIKit

class JobAcceptCell: UITableViewCell {

    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var imageView2: UIImageView!{
        didSet {
            imageView2.layer.cornerRadius = imageView2.bounds.width/2
            imageView2.layer.masksToBounds = true
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
