//
//  ReviewCell.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 11/12/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import UIKit
import Cosmos

class ReviewCell: UITableViewCell {

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
        ratingView.rating = Double(rating.rating ?? 3)
        messageLabel.text = rating.message ?? ""
        dateLabel.text = rating.timeStamp ?? ""
        if let userProfilePic = rating.userImage {
            self.proficImage.af_setImage(withURL: URL(string: userProfilePic)!, placeholderImage: UIImage(named:  "flower sketch"))
        }
    }

}
