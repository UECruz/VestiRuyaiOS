//
//  OrderData.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 10/24/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import UIKit

class OrderData: NSObject{
    var orderID:String?
    var username: String?
    var customerId: String?
    var totalPrice: Double
    var orderItems : OrderItems
    var isJobConfirmed = false
    var tailorID :String?
    var picUrl: String?
    var intrestsShown = [AnyObject]()
    
    
    init(username:String,pc: String, priceTotal: Double, items: OrderItems){
        self.username = username
        self.picUrl = pc
        self.totalPrice = priceTotal
        self.orderItems = items
    }
}
