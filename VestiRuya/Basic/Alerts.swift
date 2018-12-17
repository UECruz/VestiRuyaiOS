//
//  Alerts.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 10/2/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import UIKit

class Alert{
    static func showAlert(_ inViewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        inViewController.present(alert, animated: true, completion: nil)
    }
}
