//
//  ConfirmCustomer.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 11/2/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class ConfirmCustomer: UIViewController {

    @IBOutlet weak var thanksLabel: UILabel!
    @IBOutlet weak var dressType: UILabel!
    @IBOutlet weak var fabric: UILabel!
    @IBOutlet weak var backDetail: UILabel!
    @IBOutlet weak var embell: UILabel!
    @IBOutlet weak var neck: UILabel!
    @IBOutlet weak var sleeve: UILabel!
    @IBOutlet weak var strap: UILabel!
    @IBOutlet weak var tailorName: UILabel!
    @IBOutlet weak var customerAddress: UILabel!
    @IBOutlet weak var dueDate: UILabel!
    
    @IBOutlet weak var price: UILabel!
    var confirm: [TailorJob] = [TailorJob]()
    var desiredConfirm: TailorJob?
    var isTailorFlow: Bool? = false
    
    var ref: DatabaseReference!
    var desiredTailorJob: TailorJob!
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        populateData()
        getTailorName()
        getCustomerAddress()
        getImages()
    }
    
    private func populateData() {
        dressType.text = desiredConfirm?.items?.dressType
        fabric.text = desiredConfirm?.items?.fabric
        backDetail.text = desiredConfirm?.items?.backDetail
        embell.text = desiredConfirm?.items?.embellish
        neck.text = desiredConfirm?.items?.neckline
        sleeve.text = desiredConfirm?.items?.slevee
        strap.text = desiredConfirm?.items?.strap
        price.text = desiredConfirm?.price
        dueDate.text = desiredConfirm?.date
        
        if isTailorFlow ?? false {
            thanksLabel.isHidden = true
        }
    }
    
    private func getTailorName() {
        Database.database().reference().child("Tailors").child(desiredConfirm?.userId ?? "").observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            self.tailorName.text = username
        }){(error) in
            print(error.localizedDescription)
        }
    }
    
    private func getCustomerAddress() {
        Database.database().reference().child("Customers").child(desiredConfirm?.customerId ?? "").observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let state = value?["address"] as? String ?? ""
            self.customerAddress.text = state
        }){(error) in
            print(error.localizedDescription)
        }
    }
    
    private func getImages(){
        let storageRef = StorageReference()
        
        for  i in 1...3 {
            let sampleStorageReference =  storageRef.child("orders_images").child("\(desiredConfirm?.userId ?? "")_File_\(i)")
            
            sampleStorageReference.downloadURL { (imageURL, error) in
                if error == nil {
                    if i == 1 {
                        self.image1.kf.setImage(with: imageURL)
                    } else if i == 2 {
                        self.image2.kf.setImage(with: imageURL)
                    } else {
                        self.image3.kf.setImage(with: imageURL)
                    }
                } else {
                    print("We have error = \(error?.localizedDescription ?? "")")
                }
                
            }
        }
    }
    
    @IBAction func doneBtm(_ sender: UIButton){
        if isTailorFlow ?? false {
            if let _ = navigationController {
                navigationController?.popViewController(animated: true)
            } else {
                dismiss(animated: true)
            }
        } else {
            let vc = storyboard?.instantiateViewController(withIdentifier: "CustomerHome") as! CustomerHome
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
