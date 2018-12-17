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

class TailorEditor: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userEdit: UITextField!
    @IBOutlet weak var adde: UITextField!
    
    var ref: DatabaseReference!
    var storageRef: StorageReference!
    
    var email:String?
    var password:String?
    
    @IBAction func imageUpload(_ sender: Any) {
        
        let picking = UIImagePickerController()
        picking .delegate = self
        picking .allowsEditing = false
        picking .sourceType = .photoLibrary
        picking .mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picking , animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        storageRef = Storage.storage().reference()
        
        userEdit.delegate = self
        adde.delegate = self
    }
    
    @IBAction func saveBtm(_ sender: Any) {
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userEdit.resignFirstResponder()
        adde.resignFirstResponder()
        return true
    }
    
    func updateInfo(){
        if let userID = Auth.auth().currentUser?.uid{
            let storageItem = storageRef.child("tailor_profile_images").child(userID)
            guard let image = imageView.image else {return}
            
            if let newImage = UIImagePNGRepresentation(image){
                storageItem.putData(newImage, metadata: nil, completion: {(metadata,error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                    
                    storageItem.downloadURL(completion: {(url, error) in
                        if error != nil{
                            print(error!)
                            return
                        }
                        
                        if let profilePhotoURL = url?.absoluteString{
                            guard let name = self.userEdit.text else {return}
                            guard let ad = self.adde.text else{return}
                            
                            let newValuesForProfile =
                                ["photo": profilePhotoURL,
                                 "username": name,
                                 "email": self.email,
                                 "password": self.password,
                                 "City,State":ad]
                            
                            self.ref.child("Tailors").child(userID).updateChildValues(newValuesForProfile as Any as! [AnyHashable : Any], withCompletionBlock: {(error,refer) in
                                if error != nil{
                                    print(error!)
                                    return
                                }
                                print("Profile Successfully Update")
                            })
                        }
                    })
                })
                
                goHome()
                
            }
        }
    }
    
    func goHome(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "TailorHome") as! TailorHome
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func resetPassword (_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: (Auth.auth().currentUser?.email)!) { (error) in
            if error == nil {
                print("Passowrd resent email sent successfully")
                Alert.showAlert(self, title: "Reset Password", message: "Passowrd resent email sent successfully")
            } else {
                print("We have error sending email fo rpassword reset")
                Alert.showAlert(self, title: "Error", message: "We have error sending email fo rpassword reset")
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
