//
//  CustomerProfile.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 11/13/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import Kingfisher

class CustomerProfile: UIViewController {
    
    @IBOutlet weak var navi: UINavigationBar!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var address1: UILabel!
    @IBOutlet weak var address2: UILabel!
    
    var ref: DatabaseReference!
    var profile : [UserProfile] = []
    var pro : UserProfile?
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navi.topItem?.title = "Customer Profile"

        // Do any additional setup after loading the view.
        let user = Auth.auth().currentUser?.uid
        ref = Database.database().reference()
        ref.child("Customers").child("\(user!)").observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            let email = value?["email"] as? String
            let pic = value?["profilePic"] as? String
            let add1 = value?["address"] as? String
            let add2 = value?["City,State"] as? String
            
            self.userLabel.text = username
            self.emailLabel.text = email
            self.address1.text = add1
            self.address2.text = add2
            self.profileImage.kf.setImage(with: URL(string: pic!))
            
            
        }){ (error) in
            print(error.localizedDescription)
        }
        
        for  i in 1...3 {
            let sampleStorageReference =  Storage.storage().reference().child("customers_sample_images").child("\(Auth.auth().currentUser?.uid ?? "")_File_\(i)")
            
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
    
    
    
    @IBAction func goToEdit(_ sender: Any){
        let vc = storyboard?.instantiateViewController(withIdentifier: "CustomerEditor") as! CustomerEditor
        self.present(vc, animated: false, completion: nil)
    }

    
    @IBAction func back(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CustomerHome") as! CustomerHome
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func logOut(_ sender: Any) {
        try! Auth.auth().signOut()
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "Login") as! LoginController
            self.present(vc, animated: false, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
