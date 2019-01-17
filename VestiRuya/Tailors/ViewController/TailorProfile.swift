//
//  TailorProfile.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 11/13/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase
import FirebaseDatabase
import FirebaseAuth

class TailorProfile: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var add: UILabel!
    
    @IBOutlet weak var navi: UINavigationBar!
    var ref: DatabaseReference!
    var profile : [UserProfile] = []
    var pro : UserProfile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navi.topItem?.title = "Tailor Profile"

        // Do any additional setup after loading the view.
        let user = Auth.auth().currentUser?.uid
        ref = Database.database().reference()
        ref.child("Tailors").child("\(user!)").observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
             let email = value?["email"] as? String
            let pic = value?["profilePic"] as? String
            let city = value?["City,State"] as? String
            
            self.userLabel.text = username
            self.emailLabel.text = email
            self.profileImage.kf.setImage(with: URL(string: pic!))
            self.add.text = city
            
        }){ (error) in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func goToEdit(_ sender: Any){
        let vc = storyboard?.instantiateViewController(withIdentifier: "TailorEditor") as! TailorEditor
        self.present(vc, animated: false, completion: nil)
    }

    @IBAction func back(_ sender: Any) {
       let vc = storyboard?.instantiateViewController(withIdentifier: "TailorHome") as! TailorHome
        self.present(vc, animated: false, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func logOut(_ sender: Any) {
        try! Auth.auth().signOut()
        if let storyboard = self.storyboard {
               let vc = storyboard.instantiateViewController(withIdentifier: "Login") as! LoginController
            self.present(vc, animated: false, completion: nil)
        }
    }

}
