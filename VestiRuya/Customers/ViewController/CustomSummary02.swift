//
//  CustomSummary02.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 2/22/19.
//  Copyright © 2019 Ursula Cruz. All rights reserved.
//

import UIKit

class CustomSummary02: UIViewController,UITextViewDelegate,UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    var customDress:[Dictionary<String, AnyObject>]!
    var dress: [Dictionary<String, AnyObject>]!
    
     @IBOutlet weak var collectionSummary: UICollectionView!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var prices: UITextField!
    
    @IBOutlet weak var datepiker: UIDatePicker!
    
    var resultText = ""
    var dateText = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       navigationBar.topItem?.title = "Customer Summary"
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return dress.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellSummary", for: indexPath) as! SummaryItem02
        
        let bT = dress[indexPath.row]
        cell.label.text = bT["type"]?.capitalized?.uppercased()
        cell.imageview.kf.setImage(with: URL(string: (bT["image"] as? String ?? "")))
        
        return cell
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
    
    @IBAction func datePickerChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, YYYY"
        dateText = dateFormatter.string(from: sender.date)
        
        print(dateText)
    }
    
    @IBAction func postBTM(_ sender: Any) {
        
        if (prices.text?.isEmpty)!{
            Alert.showAlert(self, title: "Error", message: "Please enter price")
        }else{
            var dict = Dictionary<String, AnyObject>()
            dict.updateValue(prices.text as AnyObject, forKey: "price")
            dict.updateValue(datepiker.date.description as AnyObject, forKey: "date")
            customDress.append(dict)
            
            //Using notification as passing class
            NotificationCenter.default.post(name: Notification.Name("ORDEROPLACED"), object: nil, userInfo: ["order":customDress])
            
            if let viewControllers = self.navigationController?.viewControllers{
                for vc in viewControllers{
                    if vc is CustomerHome {
                        _ = self.navigationController?.popToViewController(vc, animated: true)
                        break
                    }
                }
            }else{
                let customerHomeVc = self.storyboard?.instantiateViewController(withIdentifier: "CustomerHome") as! CustomerHome
                self.present(customerHomeVc, animated: true, completion: nil)
            }
           
        }
    }

}
