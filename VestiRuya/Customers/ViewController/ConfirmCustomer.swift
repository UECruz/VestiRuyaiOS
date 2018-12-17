//
//  ConfirmCustomer.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 11/2/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import UIKit

class ConfirmCustomer: UIViewController {

    @IBOutlet weak var dressType: UILabel!
    @IBOutlet weak var fabric: UILabel!
    @IBOutlet weak var backDetail: UILabel!
    @IBOutlet weak var embell: UILabel!
    @IBOutlet weak var neck: UILabel!
    @IBOutlet weak var sleeve: UILabel!
    @IBOutlet weak var strap: UILabel!
    
    var confirm: [TailorJob] = [TailorJob]()
    var desiredConfirm: TailorJob?
    
    
    private func populateData() {
        dressType.text = desiredConfirm?.items?.dressType
        fabric.text = desiredConfirm?.items?.fabric
        backDetail.text = desiredConfirm?.items?.backDetail
        embell.text = desiredConfirm?.items?.embellish
        neck.text = desiredConfirm?.items?.neckline
        sleeve.text = desiredConfirm?.items?.slevee
        strap.text = desiredConfirm?.items?.strap
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         populateData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneBtm(_ sender: UIButton){
        let vc = storyboard?.instantiateViewController(withIdentifier: "CustomerHome") as! CustomerHome
        self.navigationController?.pushViewController(vc, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
