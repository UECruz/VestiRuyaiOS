//
//  OrdeDetail.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 10/27/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import UIKit
import Kingfisher
import UserNotifications
import Firebase
import FirebaseAuth
import FirebaseDatabase

class OrdeDetail: UIViewController {

    @IBOutlet weak var customerPic: UIImageView!
    
    @IBOutlet weak var strap: UILabel!
    @IBOutlet weak var sleeve: UILabel!
    @IBOutlet weak var neckline: UILabel!
    @IBOutlet weak var backdeail: UILabel!
    @IBOutlet weak var embell: UILabel!
    @IBOutlet weak var fabric: UILabel!
    @IBOutlet weak var dressType: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    let checkedImage = UIImage(named: "Checked Black")
    let unCheckedImage = UIImage(named: "Checked White")
    
    let value = ["isConfimed": true]
    var orderInfo: Dictionary<String, AnyObject>?
    var custoInfo : Dictionary<String,AnyObject>?
    var selects : JobOrders?
    var transfer: SideJob?
    var customerId: String?
     var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertPopup()
        
        ref = Database.database().reference()
        self.navigationBar.topItem?.title = "Order Detail"

        // Do any additional setup after loading the view.
        customerName.text = transfer?.name
        customerPic.kf.setImage(with: URL(string: (transfer?.urlPic)!))
        strap.text = transfer?.items.straps
        neckline.text = transfer?.items.neckline
        backdeail.text = transfer?.items.backDetail
        embell.text = transfer?.items.embellishment
        fabric.text = transfer?.items.fabric
        dressType.text = transfer?.items.bodyType
        sleeve.text = transfer?.items.sleeves
        price.text = String(format: "$%.2f",(transfer?.price)!)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        customerPic.isUserInteractionEnabled = true
        customerPic.addGestureRecognizer(tapGestureRecognizer)
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: {didAllow,error in
            
        })
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        _ = tapGestureRecognizer.view as! UIImageView
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomerInfo") as! CustomerInfo
         vc.select = self.transfer
        vc.selects = self.selects
        
        if let navController = self.navigationController{
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func BackBtm(_ sender: Any) {
        if let navController = self.navigationController {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func alertPopup(){
        Alert.showAlert(self, title: "Advice", message: "Click on image to get detail on the current customer")
    }
    
    // send confirmation to customer to let them know the order is ready?
    @IBAction func finishBTM(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TailorHome") as! TailorHome
        
        ref.child("Tailors").child("Job").observe(.value){(snapshot) in
            if snapshot.childrenCount > 0 {
                for y in snapshot.children.allObjects as! [DataSnapshot]{
                    if let obj = y.value as? [String:Any] {
                        
                        guard let userID = obj["userId"] as? String else{return}
                        
                        if userID != Auth.auth().currentUser?.uid {
                            continue
                        }
                        print(snapshot.value ?? "")
                        print(userID)
                    
                        let x = obj["isConfimed"] as? String
                        let updatedJob = ["isConfimed" : true] as [String : Any]
                        
                        self.ref.child("Tailors").child("Job").child(y.key).updateChildValues(updatedJob, withCompletionBlock: { (error, reference) in
                            if error == nil {
                                print("Object: \(String(describing: x?.description))")
                            }
                        })
                    }
                }
            }
            
        }
        print(value.description)
        
        if let navController = self.navigationController{
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.present(vc, animated: true, completion: nil)
        }
         
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
