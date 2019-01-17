//
//  CustomerRegister.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 10/2/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SVProgressHUD

class CustomerRegister: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var stateCityText: UITextField!
    @IBOutlet weak var addressText:UITextField!
    @IBOutlet weak var okBtm: UIButton!
    
    var ref:DatabaseReference!
    var storageRef: StorageReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        storageRef = Storage.storage().reference()
        
        usernameText.delegate = self
        emailText.delegate = self
        passwordText.delegate = self
        stateCityText.delegate = self
        addressText.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameText{
            emailText.becomeFirstResponder()
        }else{
            emailText.resignFirstResponder()
        }
        
        if textField == emailText{
            passwordText.becomeFirstResponder()
        }else{
            passwordText.resignFirstResponder()
        }
        
        if textField == passwordText{
            addressText.becomeFirstResponder()
        }else{
            addressText.resignFirstResponder()
        }
        
        if textField == addressText{
            stateCityText.becomeFirstResponder()
        }else{
            stateCityText.resignFirstResponder()
        }
        
        return true
    }
    
    @IBAction func imageUpload(_ sender: Any) {
        
        let picking = UIImagePickerController()
        picking .delegate = self
        picking .allowsEditing = false
        picking .sourceType = .photoLibrary
        picking .mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picking , animated: true, completion: nil)
    }
    
    @IBAction func submit(_ sender: Any) {
        //saveInfo()
    }
    
    func saveInfo(){
        let email = emailText.text
        let password = passwordText.text
        let username = usernameText.text
        let stateCity = stateCityText.text
        let address = addressText.text
        
        if ((email?.isEmpty)! && (password?.isEmpty)! && (username?.isEmpty)! && (stateCity?.isEmpty)! && (address?.isEmpty)!){
            Alert.showAlert(self, title: "Error", message: "Please fill in the box.")
        }else{
            SVProgressHUD.show()
            Auth.auth().createUser(withEmail: email!, password: password!, completion: { (user, error) in
                if let error = error {
                     SVProgressHUD.dismiss()
                    if let errCode = AuthErrorCode(rawValue: error._code) {
                        switch errCode {
                        case .invalidEmail:
                            Alert.showAlert(self, title: "Error", message: "Enter a valid email.")
                        case .emailAlreadyInUse:
                            Alert.showAlert(self, title: "Error", message: "Email already in use.")
                        default:
                            Alert.showAlert(self, title: "Error", message: error.localizedDescription)
                        }
                    }
                    return
                }else{
                    let user = Auth.auth().currentUser?.uid
                    let storageRef = self.storageRef.child("customers_profile_images").child(user!)
                    let eMail = email
                    let passWord = password
                    let userName = username
                    let sc = stateCity
                    let ad = address
                    
                    guard let image = self.imageView.image else {return}
                    
                    if let profileImage = UIImagePNGRepresentation(image){
                        storageRef.putData(profileImage, metadata: nil, completion: {(metadata,error) in
                            if error != nil{
                                print(error!)
                                return
                            }
                            
                            storageRef.downloadURL(completion: {(url, error) in
                                if error != nil{
                                    print(error!)
                                    return
                                }
                                
                                let photoURL = url?.absoluteString
                                self.ref.child("Customers").child("\(user!)").setValue(["username":"\(userName!)","email":"\(eMail!)","password":"\(passWord!)", "City,State":"\(sc!)","address": "\(ad!)", "profilePic" : "\(photoURL!)","type" : "customers"])
                                self.Next()
                            })
                            
                        })
                    }
                    
                    
                }
            })
            
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
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "signUpSegue" {
            saveInfo()
            return false
        }
        return true
    }
    
    func Next(){
        SVProgressHUD.dismiss()
        self.performSegue(withIdentifier: "signUpSegue", sender: nil)
    }

}
