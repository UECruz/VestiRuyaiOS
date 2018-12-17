//
//  CustomerOrder.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 10/18/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import Foundation
import UIKit

class OrderItems: NSObject{
    var bodyType: String?
    var fabric: String?
    var neckline: String?
    var backDetail: String?
    var straps: String?
    var sleeves:String?
    var embellishment: String?
    
    init(
         bodyType:String,
         fabric:String,
         neckline:String,
         backDetail:String,
         straps:String,
         sleeve:String,
         embell:String){
        
        self.bodyType = bodyType
        self.fabric = fabric
        self.embellishment = embell
        self.backDetail = backDetail
        self.sleeves = sleeve
        self.straps = straps
        self.neckline = neckline
        
    }
    
}
