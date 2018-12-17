//
//  JobOrders.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 10/26/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import Foundation
import UIKit

class JobOrders: NSObject{
    var name: String?
    var urlPic: String?
    var price: Double
    var items: OrderItems
    var isConfirmed: Bool?
    var accepted: Bool?
    var userId: String
    
    init(username:String,pic: String, priceTotal: Double, items: OrderItems, opion: Bool, userId: String,isConfirmed: Bool){
        
        self.name = username
        self.urlPic = pic
        self.price = priceTotal
        self.items = items
        self.userId = userId
        self.accepted = opion
        self.isConfirmed = isConfirmed
    }
}
