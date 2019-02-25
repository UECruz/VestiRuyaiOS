//
//  Review02Cell.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 2/21/19.
//  Copyright © 2019 Ursula Cruz. All rights reserved.
//

import UIKit
import Cosmos


class Review02Cell: UITableViewCell {
    
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var proficImage: UIImageView!{
        didSet {
            proficImage.layer.cornerRadius = proficImage.bounds.width/2
            proficImage.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        ratingView.settings.updateOnTouch = false
    }
    
    public func configure(with rating: ReviewReader)
    {
        nameLabel.text = rating.userName ?? ""
        ratingView.rating = Double(rating.rating ?? 3)
        messageLabel.text = rating.message ?? ""
        dateLabel.text = rating.timeStamp ?? ""
        if let userProfilePic = rating.userImage {
            self.proficImage.af_setImage(withURL: URL(string: userProfilePic)!, placeholderImage: UIImage(named:  "flower sketch"))
        }
    }

}
