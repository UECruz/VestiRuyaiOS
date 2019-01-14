//
//  Home.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 10/10/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SVProgressHUD

class TailorAdditionInfo: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var tailorPic: UIImageView!
    @IBOutlet weak var tailorName: UILabel!
    @IBOutlet weak var tailorEmail: UILabel!
    @IBOutlet weak var tailorPassword: UILabel!
    @IBOutlet weak var tailorStateCity: UILabel!
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    
    var ref: DatabaseReference!
    var storageRef: StorageReference!
    
    var sample1: UIImagePickerController?
    var sample2: UIImagePickerController?
    var sample3: UIImagePickerController?
    
    @IBOutlet weak var navigation: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigation.topItem?.title = "Register Extra"
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        storageRef = Storage.storage().reference()
        showingInfo()
        alertPopup()
    }
    
    @IBAction func imageUpload1(_ sender: Any) {
        sample1 = UIImagePickerController()
        sample1! .delegate = self
        sample1! .allowsEditing = false
        sample1! .sourceType = .photoLibrary
        sample1! .mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(sample1! , animated: true, completion: nil)
    }
    
    @IBAction func imageUpload2(_ sender: Any) {
        sample2 = UIImagePickerController()
        sample2! .delegate = self
        sample2! .allowsEditing = false
        sample2! .sourceType = .photoLibrary
        sample2! .mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(sample2! , animated: true, completion: nil)
    }
    
    @IBAction func imageUpload3(_ sender: Any) {
        sample3 = UIImagePickerController()
        sample3! .delegate = self
        sample3! .allowsEditing = false
        sample3! .sourceType = .photoLibrary
        sample3! .mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(sample3! , animated: true, completion: nil)
    }
    
    @IBAction func saveSampleWork(_ sender: Any){
        savingSamples()
    }
    
    func alertPopup(){
        Alert.showAlert(self, title: "Advice", message: "Please select all the images to continue")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func savingSamples(){
        let tailorUser = Auth.auth().currentUser?.uid
        
        guard let image1 = self.image1.image else {return}
        guard let image2 = self.image2.image else {return}
        guard let image3 = self.image3.image else {return}
        
        let imageArray = [image1,image2,image3]
        
        var index = 1
        SVProgressHUD.show()
        for im in imageArray{
            let storageRef = self.storageRef.child("tailors_sample_images").child("\(tailorUser!)_File_\(index)")
            let data: NSData = NSData(data: UIImagePNGRepresentation(im)!)
            storageRef.putData(data as Data,metadata:nil,completion: {(metadata,error) in
                if error != nil{
                    print(error!)
                    SVProgressHUD.dismiss()
                    return
                }
            })
            index = index + 1
        }
        SVProgressHUD.dismiss()
        self.naviagteToHomeScreen()

    }
    
    func naviagteToHomeScreen() {
        let tailorHomeVC = self.storyboard?.instantiateViewController(withIdentifier: "TailorHome") as! TailorHome
        self.navigationController?.pushViewController(tailorHomeVC, animated: true)
    }
    
    @objc func naviagteToHome () {
        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "TailorHome") as! TailorHome
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
    func showingInfo(){
        
        let tailorUser = Auth.auth().currentUser?.uid
        let storageRef = self.storageRef.child("tailors_profile_images").child(tailorUser!)
        SVProgressHUD.show()
        ref.child("Tailors").child("\(tailorUser!)").observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            
            //  print(value?.description)
            print(snapshot.value ?? "")
            
            let username = value?["username"] as? String ?? ""
            let email = value?["email"] as? String ?? ""
            let password = value?["password"] as? String ?? ""
            let stateCity = value?["City,State"] as? String ?? ""
            let pic = value?["profilePic"] as? String ?? ""
            
            self.tailorName.text = "Username: " + username
            self.tailorEmail.text = "Email: " + email
            self.tailorPassword.text = "Password: " + password
            self.tailorStateCity.text = "City,State: " + stateCity
            
            print("Test 1")
            print(username)
            print(pic)
            print("Test 2")
            
            if let url = URL(string: pic) {
                let data = NSData(contentsOf: url)
                let userPhoto = UIImage(data: data! as Data)
                self.tailorPic.image = userPhoto
            }
            SVProgressHUD.dismiss()
            
            if let userID = Auth.auth().currentUser?.uid{
                let storageItem1 = storageRef.child("sample_images").child(userID)
                
                guard let image1 = self.image1.image else {return}
                guard let image2 = self.image2.image else {return}
                guard let image3 = self.image3.image else {return}
                
                let imageArray = [image1,image2,image3]
                
                for im in imageArray{
                    let data: NSData = NSData(data: UIImagePNGRepresentation(im)!)
                    
                    storageItem1.putData(data as Data,metadata:nil,completion: {(metadata,error) in
                        if error != nil{
                            print(error!)
                            return
                        }
                        
                        storageItem1.downloadURL(completion: {(url,error) in
                            if error != nil{
                                print(error!)
                                return
                            }
                            
                            if let photoURL = url?.absoluteString{
                                
                                let newvalueInfo = ["photo": pic,
                                                    "username": username,
                                                    "email": email,
                                                    "password": password,
                                                    "city:state": stateCity ,
                                                    "samples": photoURL]
                                
                                
                                self.ref.child("Tailors").child(userID).updateChildValues(newvalueInfo, withCompletionBlock: {(error,refer) in
                                    if error != nil{
                                        print(error!)
                                        return
                                    }
                                    print("Profile Successfully Update")
                                })
                            }
                            
                            
                        })
                    })
                }
                
            }
            
            
        }){(error) in
            SVProgressHUD.dismiss()
            print(error.localizedDescription)
            Alert.showAlert(self, title: "Error", message: error.localizedDescription)
        }
    }
    
    func Next(){
        self.performSegue(withIdentifier: "NextHome", sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if picker == sample1{
             let image = info[UIImagePickerControllerOriginalImage] as? UIImage
            self.image1.image = image
        }else if picker == sample2{
            let image = info[UIImagePickerControllerOriginalImage] as? UIImage
            self.image2.image = image
            
        }else if picker == sample3{
            let image = info[UIImagePickerControllerOriginalImage] as? UIImage
            self.image3.image = image
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }


}
