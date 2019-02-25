//
//  CheckView.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 10/27/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import Kingfisher

class CheckView: UIViewController {

    @IBOutlet weak var customerName: UILabel!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var dresstype: UILabel!
    @IBOutlet weak var fabric: UILabel!
    @IBOutlet weak var backDetail: UILabel!
    @IBOutlet weak var embell: UILabel!
    @IBOutlet weak var neckline: UILabel!
    @IBOutlet weak var sleeve: UILabel!
    @IBOutlet weak var strap: UILabel!
    
    @IBOutlet weak var dressPic1: UIImageView!
    
    @IBOutlet weak var dressPic2: UIImageView!
    
    @IBOutlet weak var dressPic3: UIImageView!
    
    var orderInfo: Dictionary<String, AnyObject>?
    
    var ref: DatabaseReference!
    var desiredTailorJob: TailorJob!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.topItem?.title = "Checking"
        populateData()
        
        let storageRef = StorageReference()
        
        for  i in 1...3 {
            let sampleStorageReference =  storageRef.child("orders_images").child("\(desiredTailorJob.userId ?? "")_File_\(i)")
            
            sampleStorageReference.downloadURL { (imageURL, error) in
                if error == nil {
                    if i == 1 {
                        self.dressPic1.kf.setImage(with: imageURL)
                    } else if i == 2 {
                        self.dressPic2.kf.setImage(with: imageURL)
                    } else {
                        self.dressPic3.kf.setImage(with: imageURL)
                    }
                } else {
                    print("We have error = \(error?.localizedDescription ?? "")")
                }
                
            }
        }
    }
    
    func populateData() {
        customerName.text = desiredTailorJob.name
        dresstype.text = desiredTailorJob.items?.dressType
        fabric.text = desiredTailorJob.items?.fabric
        backDetail.text = desiredTailorJob.items?.backDetail
        embell.text = desiredTailorJob.items?.embellish
        neckline.text = desiredTailorJob.items?.neckline
        sleeve.text = desiredTailorJob.items?.slevee
        strap.text = desiredTailorJob.items?.strap
        
        print(desiredTailorJob.userId?.description ?? "")
        print(desiredTailorJob.name?.description ?? "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func cancelBTM(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func confirmBTM(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PayView") as! PayView
        vc.desiredSummary = desiredTailorJob
        if let navController = self.navigationController{
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.present(vc, animated: true, completion: nil)
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
