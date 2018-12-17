//
//  HistoryCell.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 10/24/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {
    
    @IBOutlet weak var orderImageView: UIImageView!
    @IBOutlet weak var orderLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        orderImageView.image = nil
       // orderLabel.text = ""
    }

}
