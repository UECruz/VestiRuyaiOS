//
//  CustomerEditor.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 11/18/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class CustomerEditor: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var nav: UINavigationBar!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userEdit: UITextField!
    @IBOutlet weak var address1: UITextField!
    @IBOutlet weak var address2: UITextField!
    @IBOutlet weak var emailEdit: UITextField!
    @IBOutlet weak var passEdit: UITextField!
    
    var ref: DatabaseReference!
    var storageRef: StorageReference!
    let user = Auth.auth().currentUser?.uid
    var desiredProfile: UserProfile?
    
    var email:String?
    var password:String?
    
    var newEmail: String?
    var newPass: String?
    
    @IBAction func imageUpload(_ sender: Any) {
        
        let picking = UIImagePickerController()
        picking .delegate = self
        picking .allowsEditing = true
        picking .sourceType = .photoLibrary
        picking .mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picking , animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        nav.topItem?.title = "Customer Editor"
        ref = Database.database().reference()
        storageRef = Storage.storage().reference()
        userEdit.delegate = self
        address1.delegate = self
        address2.delegate = self
        
    }
    
    
    @IBAction func saveBtm(_ sender: Any) {
        updateInfo()
    }
    
    @IBAction func back(_ sender: Any){
        goBack()
    }
    
    func goBack(){
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "CustomerProfile") as! CustomerProfile
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    func goHome(){
        if let storyboard = self.storyboard{
            let vc = storyboard.instantiateViewController(withIdentifier: "CustomerHome") as! CustomerHome
            self.present(vc, animated: false, completion: nil)
 
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userEdit.resignFirstResponder()
        address1.resignFirstResponder()
        address2.resignFirstResponder()
        return true
    }
    
    func updateInfo(){
        if let userID = Auth.auth().currentUser?.uid{
            let storageItem = storageRef.child("customers_profile_images").child(userID)
            guard let image = imageView.image else {return}
            
            if let newImage = UIImagePNGRepresentation(image){
                storageItem.putData(newImage, metadata: nil, completion: {(metadata,error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                    
                    print(storageItem.name)
                    
                    storageItem.downloadURL(completion: {(url, error) in
                        if error != nil{
                            print(error!)
                            return
                        }
                        
                        if let profilePhotoURL = url?.absoluteString{
                            guard let name = self.userEdit.text else {return}
                            guard let add1 = self.address1.text else{return}
                            guard let add2 = self.address2.text else{return}
                            guard let pass = self.passEdit.text else{return}
                            guard let email = self.emailEdit.text else{return}
                            
                            let newUpated =
                                ["profilePic": profilePhotoURL,
                                 "username": name,
                                 "email": email,
                                 "password": pass,
                                 "address":add1,
                                 "City,State":add2]
                            
                            
                            self.ref.child("Customers").child(userID).updateChildValues(newUpated as Any as! [AnyHashable : Any], withCompletionBlock: {(error,refer) in
                                if error != nil{
                                    print(error!)
                                    return
                                }
                                
                                let user = Auth.auth().currentUser
                                user?.updatePassword(to: pass, completion: {(error) in
                                    if error == nil {
                                        print("Passowrd update is successfully")
                                        Alert.showAlert(self, title: "Password Updated", message: "Pass word is updated")
                                    } else {
                                        print("We have error sending email for password reset")
                                        Alert.showAlert(self, title: "Error", message: "We have error updating password")
                                    }
                                })
                                
                                user?.updateEmail(to: email, completion: {(error) in
                                    if error == nil {
                                        print("Passowrd resent email sent successfully")
                                        Alert.showAlert(self, title: "Email Updated", message: "PEmail is updated")
                                    } else {
                                        print("We have error sending email for password reset")
                                        Alert.showAlert(self, title: "Error", message: "We have error updating email")
                                    }
                                })
                                
                               
                                
                                print("Profile Successfully Update")
                                
                            })
                            
                            
                        }
                    })
                })
                
                goHome()
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var chosenImage = UIImage()
        print(info)
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
