//
//  Material.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 10/17/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import Foundation
import UIKit

class Material:NSObject{
    var title: String?
    var pic: String?
    var image: UIImage?
    var isItemSelected = false
    
    //Intializers
    init(title: String, picURL: String) {
        self.title = title
        self.pic = picURL
    }
}
