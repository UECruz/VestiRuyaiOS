//
//  User.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 12/13/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import Foundation
class UserProfile{
    var id : String
    var name: String
    var address: String
    var state: String
    var pic:String
    
    init(id: String, name: String, picURL: String, state: String, add: String){
        self.id = id
        self.name = name
        self.address = add
        self.pic = picURL
        self.state = state
    }
}

