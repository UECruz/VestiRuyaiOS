//
//  CustomerInfo.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 10/27/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Kingfisher
import SVProgressHUD

class CustomerInfo: UIViewController {

    @IBOutlet weak var pic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var neck: UILabel!
    @IBOutlet weak var chest: UILabel!
    @IBOutlet weak var waist: UILabel!
    @IBOutlet weak var bust: UILabel!
    @IBOutlet weak var arm: UILabel!
    @IBOutlet weak var leg: UILabel!
    
    @IBOutlet weak var bodyImage1: UIImageView!
    
    @IBOutlet weak var bodyImage2: UIImageView!
    @IBOutlet weak var bodyImage3: UIImageView!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    var customerInfo: Dictionary<String, AnyObject>?
    var selects : JobOrders?
    var select: SideJob?
    var ref: DatabaseReference!
    var custUser : [CustomerUser] = []
    var desiredUser: CustomerUser?
    var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.topItem?.title = "Customer Info"
        
        ref = Database.database().reference()

        // Do any additional setup after loading the view.
        name.text = select?.name
        pic.kf.setImage(with: URL(string: (select?.urlPic)!))
        
        guard let appDelagte = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        self.appDelegate = appDelagte
        
        guard let customerProfile = select else{
            return
        }
        
        if let customername = customerProfile.name{
            name.text = customername
        }
        
        if let customerPic = customerProfile.urlPic{
            pic.kf.setImage(with: URL(string: customerPic))
        }


        let storageRef = StorageReference()

        for  i in 1...3 {
            let sampleStorageReference =  storageRef.child("customers_sample_images").child("\(select?.originalId ?? "")_File_\(i)")

            sampleStorageReference.downloadURL { (imageURL, error) in
                if error == nil {
                    if i == 1 {
                        self.bodyImage1.kf.setImage(with: imageURL)
                    } else if i == 2 {
                        self.bodyImage2.kf.setImage(with: imageURL)
                    } else {
                        self.bodyImage3.kf.setImage(with: imageURL)
                    }
                } else {
                    print("We have error = \(String(describing: error?.localizedDescription))")
                }

            }
        }
        
        getInfo()

    }
    
    func getInfo(){
        ref.child("Customers").child("Measurement").observe(.value, with: {(snapshot) in
            if snapshot.childrenCount > 0{
                for x in snapshot.children.allObjects as! [DataSnapshot]{
                    if let obj = x.value as? [String:Any]{
                        
                        guard let userID = obj["userId"] as? String else{return}
                        
                        if userID != self.select?.originalId{continue}
                        

                        let measureItem = MeasurementItem(height: "", arm: "", leg: "", bust: "", chest: "", neck: "", waisit: "")

                        if let measure = obj["measureItem"] as? Dictionary<String, AnyObject>{

                            if let height = measure["height"] as? String{
                                measureItem.height = height
                                self.height.text = height
                            }

                            if let ar = measure["arm"] as? String{
                                measureItem.arm = ar
                                print(ar)
                                self.arm.text = ar
                            }
                            
                            if let wais = measure["waist"] as? String{
                                measureItem.waist = wais
                                self.waist.text = wais
                            }

                            if let chess = measure["chest"] as? String{
                                measureItem.chest = chess
                                self.chest.text = chess
                            }

                            if let buss = measure["bust"] as? String{
                                measureItem.bust = buss
                                self.bust.text = buss
                            }

                            if let leg = measure["leg"] as? String{
                                measureItem.leg = leg
                                self.leg.text = leg
                            }

                            if let neck = measure["neck"] as? String{
                                measureItem.neck = neck
                                self.neck.text = neck
                            }
                        }



                        self.ref.child("Customers").child((self.select?.originalId)!).observe(.value, with: {(snapshot) in
                            let value = snapshot.value as? NSDictionary
                            print(snapshot.value ?? "")

                            let username = value?["username"] as? String ?? ""
                            let pic = value?["profilePic"] as? String ?? ""
                            let add = value?["address"] as? String ?? ""
                            let state = value?["City,State"] as? String ?? ""
                            
                            self.address.text = add
                            self.state.text = state


                            let user = CustomerUser(id: userID, name: username, picURL: pic, state: state, add: add, measure: measureItem)

                            self.custUser.append(user)
                            print(self.custUser.description)

                        })
                    }
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backBTm(_ sender: Any) {
        
        if let navController = self.navigationController{
            self.navigationController?.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func chatBTm(_ sender: Any) {
        let ref = Database.database().reference()
        ref.child("Tailors").child(Auth.auth().currentUser!.uid).observe(.value, with: {(snapshot) in
            
            let val = snapshot.value as? NSDictionary
            
            print(val?["username"] ?? "")
     
            guard let otherId = self.selects?.userId,
                let otherImageUrl = self.selects?.urlPic,
                let currentUserImageUrl = val?["profilePic"] as? String,
                let loggedinUserName = val?["username"] as? String,
                let currentUserId = Auth.auth().currentUser?.uid else{
                    return
            }
            
            print(otherId)
            print(currentUserId)
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
                                                      otherId: self.select!.originalId,
                                                      currentUserImage:currentUserImage,
                                                      otherImage: otherImage, loggedinUserName: loggedinUserName)
                    print("Got here 2")
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                       
                        if let navController = self.navigationController{
                          self.navigationController?.pushViewController(chatContainerViewController, animated: true)
                        }else{
                            self.present(chatContainerViewController, animated: true, completion: nil)
                        }
                    }
                   
                }
            }
        })

        
    }

}
