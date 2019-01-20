//
//  TailorInfo.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 10/27/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SVProgressHUD

class TailorInfo: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    

    @IBOutlet weak var tailorPic: UIImageView!
    
    @IBOutlet weak var naviga: UINavigationBar!
    @IBOutlet weak var reviewTable: UITableView!
    @IBOutlet weak var tailorName: UILabel!
    @IBOutlet weak var tailorLoc: UILabel!
    
    @IBOutlet weak var sample1: UIImageView!
    @IBOutlet weak var sample2: UIImageView!
    @IBOutlet weak var sample3: UIImageView!
    @IBOutlet weak var jobConfirmationButton: UIButton!
    
    var appDelegate: AppDelegate!
    var tailorInfo: Dictionary<String, AnyObject>?
    var jobs: [TailorJob] = [TailorJob]()
    var reader: [ReviewReader] = [ReviewReader]()
    var posts: Dictionary<String,AnyObject>?
    var databaseRef = Database.database().reference()
    var desiredTailorJob: TailorJob! {
        didSet {
            populateData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        naviga.topItem?.title = "Tailor Info"
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        self.appDelegate = appDelegate
        
        fetchJobInformation()
        fetchReview()

        // Do any additional setup after loading the view.
        guard let tailorProfile = tailorInfo else {
            return
        }
        
        if let tailorname = tailorProfile["tailorname"] as? String {
            tailorName.text = tailorname
        }
        
        if let tailorLocation = tailorProfile["tailorLoc"] as? String{
            tailorLoc.text = tailorLocation
        }
        
        if let tailorPicURL = tailorProfile["tailorPic"] as? String{
            tailorPic.kf.setImage(with: URL(string: tailorPicURL))
        }
        guard let tailorID = tailorProfile["tailorID"] as? String else {
            return
        }
        
        let storageRef = StorageReference()
        
        for  i in 1...3 {
            let sampleStorageReference =  storageRef.child("tailors_sample_images").child("\(tailorID)_File_\(i)")
           
            sampleStorageReference.downloadURL { (imageURL, error) in
                if error == nil {
                    if i == 1 {
                    self.sample1.kf.setImage(with: imageURL)
                    } else if i == 2 {
                         self.sample2.kf.setImage(with: imageURL)
                    } else {
                         self.sample3.kf.setImage(with: imageURL)
                    }
                } else {
                    print("We have error = \(error?.localizedDescription ?? "")")
                }
                
            }
        }
    }
    
    func fetchReview(){
        
        guard let orders = tailorInfo else {
            return
        }
        
        print(tailorInfo?.description ?? "")
        
        guard let tailorID = orders["tailorID"] as? String else {
            return
        }
        
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
                
                _ = self.reader.filter({(x) -> Bool in
                    x.tailorId == tailorID
                })
                
                self.reviewTable.reloadData()
               
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reader.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell02", for: indexPath) as! ReviewCell
        let rating = reader[indexPath.row]
        cell.configure(with: rating)
        return cell
    }
    
    @IBAction func chatBtm(_ sender: Any) {
        let ref = Database.database().reference()
        ref.child("Customers").child(Auth.auth().currentUser!.uid).observe(.value, with: {(snapshot) in
            
            let val = snapshot.value as? NSDictionary
            
            print(val?.description ?? "")
            
            guard let otherId = self.tailorInfo!["tailorID"] as? String,
                let otherImageUrl = self.tailorInfo!["tailorPic"] as? String,
                let currentUserImageUrl = val?["profilePic"] as? String,
                let currentUserId = Auth.auth().currentUser?.uid, let loggedinUserName = val?["username"] as? String else { return }
            
            DispatchQueue.main.async {
                SVProgressHUD.show()
            }
            
            ImageDownloader.default.downloadImage(with: URL(string: otherImageUrl)!, options: [], progressBlock: nil) {
                (otherImage, error, url, data) in
                if let img = otherImage {
                    ImageCache.default.store(img, forKey: otherImageUrl)
                }
                ImageDownloader.default.downloadImage(with:URL(string:currentUserImageUrl)!, options: [], progressBlock: nil) {
                    (currentUserImage, error, url, data) in
                    if let img = currentUserImage {
                        ImageCache.default.store(img, forKey: currentUserImageUrl)
                    }
                    let chatContainerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatContainerViewController") as! ChatContainerViewController
                    let _ = chatContainerViewController.view // load the view to instantiate the ChatViewController itself
                    chatContainerViewController.setup(myId: currentUserId,
                                                      otherId: otherId,
                                                      currentUserImage:currentUserImage,
                                                      otherImage: otherImage, loggedinUserName: loggedinUserName)
                    
                    SVProgressHUD.dismiss()
                    if let navController = self.navigationController{
                       self.navigationController?.pushViewController(chatContainerViewController, animated: true)
                    }else{
                        self.present(chatContainerViewController, animated: true, completion: nil)
                    }
                    
                }
            }
        })
    }
    
    @IBAction func confirmed(_ sender: Any){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CheckView") as! CheckView
        
        if let navController = self.navigationController{
            vc.desiredTailorJob = desiredTailorJob
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.present(vc, animated: true, completion: nil)
        }
        
    }

    private func fetchJobInformation() {
        let ref = Database.database().reference()
        
        // Do any additional setup after loading the view.
        
        guard let orders = tailorInfo else {
            return
        }
        
        print(tailorInfo?.description ?? "")
        
        guard let tailorID = orders["tailorID"] as? String else {
            return
        }
        
        print("Job: \(tailorID)")
        
        ref.child("Tailors").child("Job").observe(.value) { snapshot in
            if snapshot.childrenCount > 0 {
                print(snapshot.value ?? "")
                self.jobs.removeAll()
                for tailorJob in snapshot.children.allObjects as! [DataSnapshot] {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: tailorJob.value as Any, options: .prettyPrinted)
                        let decoder = JSONDecoder()
                        let job = try decoder.decode(TailorJob.self, from: data)
                        
            
                        self.jobs.append(job)
                    } catch let error {
                        print(error)
                    }
                }
                

                
                let tailorJob = self.jobs.filter({ (job) -> Bool in
                    job.userId == tailorID && job.customerId == Auth.auth().currentUser?.uid
                })
                
                print(tailorJob.description )
              

                
                
                
                if tailorJob.count > 0 {
                    self.desiredTailorJob = tailorJob.first
                }
            }
        }
    }
    
    private func populateData() {
        if desiredTailorJob.isConfimed ?? false {
            let identifier = "ORDERREMINDER_" + String(arc4random_uniform(100000))
            let components = Calendar.current.dateComponents([.second, .minute, .hour], from: Date().addingTimeInterval(3))
            appDelegate.createNotification(title: "Order Update", subtitle: "", body: "Your order is completed.", components: components, identifier: identifier)
            jobConfirmationButton.setImage(#imageLiteral(resourceName: "New Job_black"), for: .normal)
        } else {
            jobConfirmationButton.setImage(#imageLiteral(resourceName: "New Job_white"), for: .normal)
        }
    }
}
