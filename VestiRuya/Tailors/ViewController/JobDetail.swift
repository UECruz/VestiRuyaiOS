//
//  JobDetail.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 10/23/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import Firebase
import FirebaseDatabase
import FirebaseAuth
import Kingfisher

class JobDetail: UIViewController {

    @IBOutlet weak var proficImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var dresstype: UILabel!
    @IBOutlet weak var backDetail: UILabel!
    @IBOutlet weak var embellishment: UILabel!
    
    @IBOutlet weak var fabric: UILabel!
    @IBOutlet weak var neckline: UILabel!
    @IBOutlet weak var slevee: UILabel!
    
    @IBOutlet weak var strap: UILabel!
    var selects : OrderData?
    var dataRef = Database.database().reference()
    var customerOrders:[Dictionary<String, AnyObject>] = []
    var user = [AcceptedTailorUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        dataRef = Database.database().reference()
        
        desc()
    }
    
    func desc(){
        
        var imageUrl = ""
        if let image = selects?.picUrl{
            imageUrl = image
        }
        self.name.text = selects?.username
        self.price.text = String(format: "$%.2f",(selects?.totalPrice)!)
        self.proficImage.kf.setImage(with: URL(string: imageUrl))
        self.dresstype.text = selects?.orderItems.bodyType
        self.backDetail.text = selects?.orderItems.backDetail
        self.embellishment.text = selects?.orderItems.embellishment
        self.fabric.text = selects?.orderItems.fabric
        self.neckline.text = selects?.orderItems.neckline
        self.slevee.text = selects?.orderItems.sleeves
        self.strap.text = selects?.orderItems.straps
        
    }
    
    @IBAction func acceptJob(_ sender: UIButton) {
       
        
        let tailorUser = Auth.auth().currentUser?.uid
        dataRef = Database.database().reference()
        dataRef.child("Tailors").child("\(tailorUser!)").observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary

            print(snapshot.value ?? "")

             let username = value?["username"] as? String ?? ""
             let pic = value?["profilePic"] as? String ?? ""
             let state = value?["City,State"] as? String ?? ""
            
            
            let ordesAccepted = ["isJobAccepted": true, "tailorID":tailorUser ?? "", "tailorname":username, "tailorPic": pic, "tailorLoc": state] as [String : Any]
            
            
            print(ordesAccepted.description)
            self.selects?.intrestsShown.append(ordesAccepted as AnyObject)
            let tailorIntrested = ["interestsShown":self.selects?.intrestsShown]
            self.dataRef.child("Customers").child("Orders").child((self.selects?.orderID)!).updateChildValues(tailorIntrested as Any as! [AnyHashable : Any])
            
            print(tailorIntrested)


        }){(error) in
            print(error.localizedDescription)
        }
        
        
        var dict1 = Dictionary<String,AnyObject>()
        let accepted :Bool = true
        let customerId = self.selects?.orderID
        print(customerId?.description ?? "")
        dict1.updateValue(tailorUser! as AnyObject, forKey: "userId")
        dict1.updateValue(selects?.orderID as AnyObject, forKey: "customerId")
        dict1.updateValue(name.text as AnyObject, forKey: "userName")
        dict1.updateValue(price.text as AnyObject, forKey: "price")
        dict1.updateValue(selects?.picUrl as AnyObject, forKey: "profileImageURL")
        dict1.updateValue(accepted as AnyObject, forKey: "jobAccept")
        dict1.updateValue(dresstype.text as AnyObject, forKey: "dressType")
        dict1.updateValue(fabric.text as AnyObject, forKey: "fabric")
        dict1.updateValue(embellishment.text as AnyObject, forKey: "embellish")
        dict1.updateValue(backDetail.text as AnyObject, forKey: "backDetail")
        dict1.updateValue(slevee.text as AnyObject, forKey: "sleeve")
        dict1.updateValue(strap.text as AnyObject, forKey: "straps")
        dict1.updateValue(neckline.text as AnyObject, forKey: "neckline")
        customerOrders.append(dict1)
        print(customerOrders.description)
        
        let orderlistDict = ["userId": tailorUser!,"name": name.text ?? "", "price": price.text ?? "", "pics": selects?.picUrl ?? "","customerId": selects?.customerId ?? "", "isAccepted": accepted,"isConfimed": false,"items": ["dressType": dresstype.text, "fabric": fabric.text, "embellish": embellishment.text, "backDetail": backDetail.text, "slevee": slevee.text, "neckline": neckline.text, "strap": strap.text]] as [String : Any]
        
        self.dataRef.child("Tailors").child("Job").childByAutoId().updateChildValues(orderlistDict)
        
        NotificationCenter.default.post(name:Notification.Name("JobAccepted"),object:nil,
                                        userInfo:["OrderAccept":customerOrders])
        
        for vc in (self.navigationController?.viewControllers)! {
            if vc is TailorHome {
                _ = self.navigationController?.popToViewController(vc, animated: true)
                break
            }
        }

    }
    
    @IBAction func cancel(_ sender: Any) {
        if let navController = self.navigationController{
            self.navigationController?.popViewController(animated: true)
        }else{
            dismiss(animated: true, completion: nil)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
