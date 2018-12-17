//
//  CustomerUsers.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 11/9/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import Foundation
import UIKit

class CustomerUser: NSObject{
    var id : String
    var name: String
    var address: String
    var state: String
    var pic: String
    var measureItem: MeasurementItem
    
    init(id: String, name: String, picURL: String, state: String, add: String, measure: MeasurementItem){
        self.id = id
        self.name = name
        self.address = add
        self.pic = picURL
        self.state = state
        self.measureItem = measure
    }
}
