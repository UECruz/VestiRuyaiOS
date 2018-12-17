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
    var orderItems : OrderItems
    
    init(username:String, priceTotal: Double, items: OrderItems){
        self.username = username
        self.totalPrice = priceTotal
        self.orderItems = items
    }
}
