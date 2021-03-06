//
//  TailorRegister.swift
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

class TailorRegister: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var stateCityText: UITextField!
    @IBOutlet weak var okBtm: UIButton!
    
    var ref:DatabaseReference!
    var storageRef: StorageReference!
    
    var picking = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        storageRef = Storage.storage().reference()
        
        usernameText.delegate = self
        emailText.delegate = self
        passwordText.delegate = self
        stateCityText.delegate = self
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
            stateCityText.becomeFirstResponder()
        }else{
            stateCityText.resignFirstResponder()
        }
        
        return true
    }
    
    
    @IBAction func imageUpload(_ sender: Any) {
        
        picking .delegate = self
        picking .allowsEditing = false
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
        }
        
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openGallery(){
        if(UIImagePickerController .isSourceTypeAvailable(.photoLibrary)){
            picking.sourceType = .photoLibrary
            picking .mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            present(picking, animated: true, completion: nil)
        }
    }
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picking.sourceType = .camera
            picking .mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
            present(picking, animated: true, completion: nil)
        } else {
            let alertWarning = UIAlertController(title: "Warning", message: "Camera not avaible", preferredStyle: .alert)
            alertWarning.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertWarning, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    @IBAction func submit(sender:Any){
        // saveInfo()
    }
    
    func saveInfo(){
        LoginController.isTailor = true
        let email = emailText.text
        let password = passwordText.text
        let username = usernameText.text
        let stateCity = stateCityText.text
        
        if ((email?.isEmpty)! && (password?.isEmpty)! && (username?.isEmpty)! && (stateCity?.isEmpty)!){
            Alert.showAlert(self, title: "Error", message: "Please fill in the box.")
        } else if !isValidPassword(password ?? "") {
            Alert.showAlert(self, title: "Security Alert", message: "Password must be minimum 8 characters long with at least 1 Alphabet and 1 Number.")
        }else{
            SVProgressHUD.show()
            Auth.auth().createUser(withEmail: email!, password: password!, completion: { (user, error) in
                if let error = error {
                    SVProgressHUD.dismiss()
                    
                    if let errCode = AuthErrorCode(rawValue: error._code) {
                        switch errCode {
                        case .emailAlreadyInUse:
                            Alert.showAlert(self, title: "Error", message: "Email already in use.")
                        case .invalidEmail:
                            Alert.showAlert(self, title: "Error", message: "Enter a valid email.")
                        default:
                            Alert.showAlert(self, title: "Error", message: error.localizedDescription)
                        }
                    }
                    return
                }else{
                    
                    let user = Auth.auth().currentUser?.uid
                    let storageRef = self.storageRef.child("tailors_profile_images").child(user!)
                    let eMail = email
                    let passWord = password
                    let userName = username
                    let sc = stateCity
                    
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
                                self.ref.child("Tailors").child("\(user!)").setValue(["username":"\(userName!)","email":"\(eMail!)","password":"\(passWord!)", "City,State":"\(sc!)", "profilePic" : "\(photoURL!)","type" : "tailors"])
                                self.Next()
                            })
                            
                        })
                    }
                    
                    
                }
            })
            
        }
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
    
    public func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
}
