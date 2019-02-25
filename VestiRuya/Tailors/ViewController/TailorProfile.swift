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

class TailorProfile: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var reviewTable: UITableView!
    @IBOutlet weak var add: UILabel!
    
    @IBOutlet weak var navi: UINavigationBar!
    var ref: DatabaseReference!
    var profile : [UserProfile] = []
    var pro : UserProfile?
    var reader: [ReviewReader] = [ReviewReader]()
    var tailorInfo: Dictionary<String, AnyObject>?
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    
    fileprivate func prepopulateDate() {
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
        
        for  i in 1...3 {
            let sampleStorageReference =  Storage.storage().reference().child("tailors_sample_images").child("\(Auth.auth().currentUser?.uid ?? "")_File_\(i)")
            
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navi.topItem?.title = "Tailor Profile"

        prepopulateDate()
        fetchReview()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reader.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "review02", for: indexPath) as! Review02Cell
        let rating = reader[indexPath.row]
        cell.configure(with: rating)
        return cell
    }
    
    func fetchReview(){
        
        let user = Auth.auth().currentUser?.uid
        
        let ref = Database.database().reference()
        ref.child("Customers").child("Reviews").observe(.value) { snapshot in
            if snapshot.childrenCount > 0 {
                print(snapshot.value ?? "")
                self.reader.removeAll()
                for x in snapshot.children.allObjects as! [DataSnapshot] {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: x.value as Any, options: .prettyPrinted)
                        let decoder = JSONDecoder()
                        let y = try decoder.decode(ReviewReader.self, from: data)
                        
                        self.reader.append(y)
                    } catch let error {
                        print(error)
                    }
                }
                
                self.reader = self.reader.filter({(x) -> Bool in
                    x.tailorId == user
                })
                
                self.reviewTable.reloadData()
                
            }
        }
    }
    
    
    @IBAction func logOut(_ sender: Any) {
        try! Auth.auth().signOut()
        if let storyboard = self.storyboard {
               let vc = storyboard.instantiateViewController(withIdentifier: "Login") as! LoginController
            self.present(vc, animated: false, completion: nil)
        }
    }

}
