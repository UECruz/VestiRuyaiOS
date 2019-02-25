//
//  TailorJob.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 11/2/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import Foundation

struct TailorJob: Codable {
    let isAccepted: Bool?
    let isConfimed: Bool?
    let items: Item?
    let name: String?
    let pics: String?
    let price: String?
    let userId: String?
    let customerId: String?
    let date: String?

    struct Item: Codable {
        let backDetail: String?
        let dressType: String?
        let fabric: String?
        let neckline: String?
        let slevee: String?
        let strap: String?
        let embellish: String?
    }
}

