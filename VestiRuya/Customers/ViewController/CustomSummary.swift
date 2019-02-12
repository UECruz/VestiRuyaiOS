//
//  CustomSummary.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 10/20/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import UIKit



class CustomSummary: UIViewController, UITextFieldDelegate{
    
    var customDress:[Dictionary<String, AnyObject>]!

    @IBOutlet weak var bodyType: UILabel!
    @IBOutlet weak var Fabric: UILabel!
    @IBOutlet weak var sleeves: UILabel!
    @IBOutlet weak var straps: UILabel!
    @IBOutlet weak var neckline: UILabel!
    @IBOutlet weak var backDetail: UILabel!
    @IBOutlet weak var embellish: UILabel!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var prices: UITextField!
    

    var resultText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationBar.topItem?.title = "Summary"
        
        prices.delegate = self
        
        
        if let bT = customDress[0] as? Dictionary<String,AnyObject>{
            bodyType.text = bT["bodytype"]?.capitalized
        }
        
        if let fab = customDress[1] as? Dictionary<String,AnyObject>{
            Fabric.text = fab["fabrics"]?.capitalized
        }
        
        if let neckLines = customDress[2] as? Dictionary<String,AnyObject>{
            neckline.text = neckLines["neckline"]?.capitalized
        }
        
        if let sleve = customDress[3] as? Dictionary<String,AnyObject>{
            sleeves.text = sleve["sleeves"]?.capitalized
        }
        
        if let strap = customDress[4] as? Dictionary<String,AnyObject>{
            straps.text = strap["straps"]?.capitalized
        }
        
        if let bD = customDress[5] as? Dictionary<String,AnyObject>{
            backDetail.text = bD["backDetails"]?.capitalized
        }
        
        if let embell = customDress[6] as? Dictionary<String,AnyObject>{
            embellish.text = embell["embellishment"]?.capitalized
        }
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        prices.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func redoBTM(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CustomerHome") as! CustomerHome
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func postBTM(_ sender: Any) {
        
        if (prices.text?.isEmpty)!{
            Alert.showAlert(self, title: "Error", message: "Please enter price")
        }else{
            var dict = Dictionary<String, AnyObject>()
            dict.updateValue(prices.text as AnyObject, forKey: "price")
            customDress.append(dict)
            
            //Using notification as passing class
            NotificationCenter.default.post(name: Notification.Name("ORDEROPLACED"), object: nil, userInfo: ["order":customDress])
            
            for vc in (self.navigationController?.viewControllers)! {
                if vc is CustomerHome {
                    _ = self.navigationController?.popToViewController(vc, animated: true)
                    break
                }
                
            }
        }
    }


}
