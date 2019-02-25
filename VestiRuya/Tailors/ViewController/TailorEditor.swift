//
//  TailorEditor.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 11/18/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD

class TailorEditor: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var nav: UINavigationBar!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userEdit: UITextField!
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
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    
    var sample1: UIImagePickerController?
    var sample2: UIImagePickerController?
    var sample3: UIImagePickerController?
    var picking = UIImagePickerController()
    
    @IBAction func imageUpload(_ sender: Any) {
        
        picking .delegate = self
        picking .allowsEditing = true
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
    
    @IBAction func imageUpload1(_ sender: Any) {
        sample1 = UIImagePickerController()
        sample1!.delegate = self
        sample1!.allowsEditing = false
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera1()
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallery1()
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
    
    @IBAction func imageUpload2(_ sender: Any) {
        sample2 = UIImagePickerController()
        sample2! .delegate = self
        sample2! .allowsEditing = false
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera2()
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallery2()
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
    
    @IBAction func imageUpload3(_ sender: Any) {
        sample3 = UIImagePickerController()
        sample3! .delegate = self
        sample3! .allowsEditing = false
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera3()
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallery3()
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
    
    func openGallery1(){
        if(UIImagePickerController .isSourceTypeAvailable(.photoLibrary)){
            sample1!.sourceType = .photoLibrary
            sample1! .mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            present(sample1!, animated: true, completion: nil)
        }
    }
    
    func openCamera1(){
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            sample1!.sourceType = .camera
            sample1! .mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
            present(sample1!, animated: true, completion: nil)
        } else {
            let alertWarning = UIAlertController(title: "Warning", message: "Camera not avaible", preferredStyle: .alert)
            alertWarning.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertWarning, animated: true, completion: nil)
        }
    }
    
    func openGallery2(){
        if(UIImagePickerController .isSourceTypeAvailable(.photoLibrary)){
            sample2!.sourceType = .photoLibrary
            sample2! .mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            present(sample2!, animated: true, completion: nil)
        }
    }
    
    func openCamera2(){
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            sample2!.sourceType = .camera
            sample2! .mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
            present(sample2!, animated: true, completion: nil)
        } else {
            let alertWarning = UIAlertController(title: "Warning", message: "Camera not avaible", preferredStyle: .alert)
            alertWarning.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertWarning, animated: true, completion: nil)
        }
    }
    
    func openGallery3(){
        if(UIImagePickerController .isSourceTypeAvailable(.photoLibrary)){
            sample3!.sourceType = .photoLibrary
            sample3! .mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            present(sample3!, animated: true, completion: nil)
        }
    }
    
    func openCamera3(){
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            sample3!.sourceType = .camera
            sample3! .mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
            present(sample3!, animated: true, completion: nil)
        } else {
            let alertWarning = UIAlertController(title: "Warning", message: "Camera not avaible", preferredStyle: .alert)
            alertWarning.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertWarning, animated: true, completion: nil)
        }
    }
    
    @IBAction func saveSampleWork(_ sender: Any){
        savingSamples()
    }
    
    //Replace photos
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
        
    }
    
    fileprivate func prepoluateData() {
        ref.child("Tailors").child("\(user!)").observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            let email = value?["email"] as? String
            let pic = value?["profilePic"] as? String
            let city = value?["City,State"] as? String
            let password = value?["password"] as? String
            
            self.userEdit.text = username
            self.emailEdit.text = email
            self.imageView.kf.setImage(with: URL(string: pic!))
            self.address2.text = city
            self.passEdit.text = password
            
        }){ (error) in
            print(error.localizedDescription)
        }
        
        for  i in 1...3 {
            let sampleStorageReference =  storageRef.child("tailors_sample_images").child("\(Auth.auth().currentUser?.uid ?? "")_File_\(i)")
            
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
        
        // Do any additional setup after loading the view.
        nav.topItem?.title = "Tailor Editor"
        ref = Database.database().reference()
        storageRef = Storage.storage().reference()
        userEdit.delegate = self
        address2.delegate = self
        emailEdit.delegate = self
        passEdit.delegate = self
        
        prepoluateData()
        
    }
    
    
    @IBAction func saveBtm(_ sender: Any) {
        savingSamples()
        updateInfo()
    }
    
    @IBAction func back(_ sender: Any){
        goBack()
    }
    
    func goBack(){
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "TailorProfile") as! TailorProfile
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    func goHome(){
        if let storyboard = self.storyboard{
            let vc = storyboard.instantiateViewController(withIdentifier: "TailorHome") as! TailorHome
            self.present(vc, animated: false, completion: nil)
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == userEdit{
            address2.becomeFirstResponder()
        }else{
            address2.resignFirstResponder()
        }
        if textField == address2{
            emailEdit.becomeFirstResponder()
        }else{
            emailEdit.resignFirstResponder()
        }
        
        if textField == emailEdit{
            passEdit.becomeFirstResponder()
        }else{
            passEdit.resignFirstResponder()
        }
        return true
    }
    
    func updateInfo(){
        if let userID = Auth.auth().currentUser?.uid{
            let storageItem = storageRef.child("tailors_profile_images").child(userID)
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
                            guard let add2 = self.address2.text else{return}
                            guard let pass = self.passEdit.text else{return}
                            guard let email = self.emailEdit.text else{return}
                            
                            let newUpated =
                                ["profilePic": profilePhotoURL,
                                 "username": name,
                                 "email": email,
                                 "password": pass,
                                 "City,State":add2]
                            
                            
                            self.ref.child("Tailors").child(userID).updateChildValues(newUpated as Any as! [AnyHashable : Any], withCompletionBlock: {(error,refer) in
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
        if picker == sample1 {
            image1.image = chosenImage
        } else if picker == sample2 {
            image2.image = chosenImage
        } else if picker == sample3 {
            image3.image = chosenImage
        } else {
            imageView.image = chosenImage
        }
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
