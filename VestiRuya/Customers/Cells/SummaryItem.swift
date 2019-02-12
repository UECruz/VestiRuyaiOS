//
//  SummaryItem.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 10/20/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import UIKit

class SummaryItem: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var bodyType: UILabel!
    @IBOutlet weak var fabric: UILabel!
    @IBOutlet weak var embell: UILabel!
    @IBOutlet weak var backDetail: UILabel!
    @IBOutlet weak var neckline: UILabel!
    @IBOutlet weak var straps: UILabel!
    @IBOutlet weak var sleeves: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
