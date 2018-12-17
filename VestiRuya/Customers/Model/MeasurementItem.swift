//
//  MeasurementItem.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 11/8/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import Foundation
import UIKit

class MeasurementItem : NSObject{
    var height: String?
    var arm: String?
    var leg: String?
    var waist: String?
    var bust: String?
    var chest: String?
    var neck:String?
    
    init(
        height:String,
        arm:String,
        leg:String,
        bust:String,
        chest:String,
        neck:String,
        waisit: String){
        
      self.height = height
        self.arm = arm
        self.leg = leg
        self.bust = bust
        self.chest = chest
        self.neck = neck
        self.waist = waisit
        
    }
    
}
