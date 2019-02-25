//
//  CustomerOrder.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 10/19/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import Foundation
import UIKit

class CustomerOrder: NSObject{
    
    var username: String?
    var totalPrice: Double
    var dateDue: String?
    var orderItems : OrderItems
    var isJobConfirmed: Bool?
    
    init(username:String, dateDue:String,priceTotal: Double, items: OrderItems, isJobConfirmed: Bool){
        self.username = username
        self.totalPrice = priceTotal
        self.orderItems = items
        self.dateDue = dateDue
        self.isJobConfirmed = isJobConfirmed
    }
}
