//
//  AcceptedTailorUser.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 10/29/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import Foundation
import UIKit

class AcceptedTailorUser: NSObject{
    var tailorID:String?
    var username: String?
    var picUrl: String?
    var stateCity: String?
    
    init(id: String, name: String, pic: String, sc: String){
        self.tailorID = id
        self.username = name
        self.picUrl = pic
        self.stateCity = sc
    }
    
}
