//
//  ViewController.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 10/2/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
     var isTailorSelected = 0
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  isTailorSelected == 1{
            _ = segue.destination as! TailorRegister
            
        }else if isTailorSelected == 2{
            _ = segue.destination as! CustomerRegister
        }
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

