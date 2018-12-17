//
//  SideJob.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 11/13/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import Foundation
import UIKit

class SideJob: NSObject{
    var name: String?
    var urlPic: String?
    var price: Double
    var items: OrderItems
    var isConfirmed: Bool?
    var accepted: Bool?
    var userId: String
    var originalId: String
    
    init(username:String,pic: String, priceTotal: Double, items: OrderItems, opion: Bool, userId: String, custId:String,isConfirmed: Bool){
        
        self.name = username
        self.urlPic = pic
        self.price = priceTotal
        self.items = items
        self.userId = userId
        self.accepted = opion
        self.isConfirmed = isConfirmed
        self.originalId = custId
    }
}
