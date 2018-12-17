//
//  ReviewReader.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 11/13/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import Foundation

struct ReviewReader: Codable {
    let message: String?
    let rating: Int?
    let userImage: String?
    let userName: String?
    let customerId: String?
    let tailorId: String
    let timeStamp: String?
}
