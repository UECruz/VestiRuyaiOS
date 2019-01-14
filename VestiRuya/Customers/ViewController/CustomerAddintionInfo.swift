//
//  CustomerHome.swift
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

class CustomerAddintionInfo: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    
    @IBOutlet weak var heightText: UITextField!
    @IBOutlet weak var neckText: UITextField!
    @IBOutlet weak var chestText: UITextField!
    @IBOutlet weak var waistText: UITextField!
    @IBOutlet weak var bustText: UITextField!
    @IBOutlet weak var armLenText: UITextField!
    @IBOutlet weak var legLenText: UITextField!
    
    var ref: DatabaseReference!
    var storageRef: StorageReference!
    
    var sample1: UIImagePickerController?
    var sample2: UIImagePickerController?
    var sample3: UIImagePickerController?
    
    var loggedUser : AnyObject?
    var userName: String?
    var locationMat: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        heightText.delegate = self
        neckText.delegate  = self
        chestText.delegate = self
        waistText.delegate = self
        bustText.delegate = self
        armLenText.delegate = self
        legLenText.delegate = self
        
        ref = Database.database().reference()
        storageRef = Storage.storage().reference()
        
        alertPopup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        heightText.resignFirstResponder()
        neckText.resignFirstResponder()
        chestText.resignFirstResponder()
        waistText.resignFirstResponder()
        bustText.resignFirstResponder()
        armLenText.resignFirstResponder()
        legLenText.resignFirstResponder()
        return true
    }
   
    
    @IBAction func uploadImage1(_ sender: Any) {
        sample1 = UIImagePickerController()
        sample1! .delegate = self
        sample1! .allowsEditing = false
        sample1! .sourceType = .photoLibrary
        sample1! .mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(sample1! , animated: true, completion: nil)
    }
    
    @IBAction func uploadImage2(_ sender: Any) {
        sample2 = UIImagePickerController()
        sample2! .delegate = self
        sample2! .allowsEditing = false
        sample2! .sourceType = .photoLibrary
        sample2! .mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(sample2! , animated: true, completion: nil)
    }
    
    @IBAction func uploadIMage3(_ sender: Any) {
        sample3 = UIImagePickerController()
        sample3! .delegate = self
        sample3! .allowsEditing = false
        sample3! .sourceType = .photoLibrary
        sample3! .mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(sample3! , animated: true, completion: nil)
    }
    
    func savingSampleImage(){
        let customerUser = Auth.auth().currentUser?.uid
        
        guard let image1 = self.image1.image else {return}
        guard let image2 = self.image2.image else {return}
        guard let image3 = self.image3.image else {return}
        
        let imageArray = [image1,image2,image3]
        
        var index = 1
        SVProgressHUD.show()
        for im in imageArray{
            let storageRef = self.storageRef.child("customers_sample_images").child("\(customerUser!)_File_\(index)")
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
        measureInfo()
        self.naviagteToHomeScreen()
    }
    
    func alertPopup(){
        Alert.showAlert(self, title: "Advice", message: "Please select all the images to continue")
    }
    
    func naviagteToHomeScreen() {
        let tailorHomeVC = self.storyboard?.instantiateViewController(withIdentifier: "CustomerHome") as! CustomerHome
        self.navigationController?.pushViewController(tailorHomeVC, animated: true)
    }
    
    func measureInfo(){
        
        let customerId = Auth.auth().currentUser?.uid
        
        self.ref.child("Customers").child("\(customerId!)").observe(.value, with: {(snapshot) in
            let values = snapshot.value as? NSDictionary
            
            if let userName =  values!["username"] as? String {
                self.userName = userName
            }
            
            var measureItem: Dictionary<String,AnyObject> = Dictionary()
            
            guard let height = self.heightText.text else {return}
            guard let neck = self.neckText.text else {return}
            guard let chest = self.chestText.text else{return}
            guard let bust = self.bustText.text else{return}
            guard let arm = self.armLenText.text else{return}
            guard let leg = self.legLenText.text else{return}
            guard let waist = self.waistText.text else{return}
            
            measureItem.updateValue(height as AnyObject, forKey: "height")
            measureItem.updateValue(neck as AnyObject, forKey: "neck")
            measureItem.updateValue(chest as AnyObject, forKey: "chest")
            measureItem.updateValue(bust as AnyObject, forKey: "bust")
            measureItem.updateValue(arm as AnyObject, forKey: "arm")
            measureItem.updateValue(leg as AnyObject, forKey: "leg")
            measureItem.updateValue(waist as AnyObject, forKey: "waist")
            
           
            
            let userInfo2 = ["userId" : customerId!,"username": self.userName ?? "", "measureItem": measureItem ] as [String : Any]
        self.ref.child("Customers").child("Measurement").childByAutoId().updateChildValues(userInfo2)
            
        })
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
    
    @objc func naviagteToHome () {
        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "CustomerHome") as! CustomerHome
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
    @IBAction func submit(_ sender: Any) {
        
        let height = heightText.text
        let neck = neckText.text
        let chest = chestText.text
        let bust = bustText.text
        let arm = armLenText.text
        let leg = legLenText.text
        let waist = waistText.text
        
        if ((height!.isEmpty) && (neck?.isEmpty)! && (chest?.isEmpty)! && (bust?.isEmpty)! && (arm?.isEmpty)! && (leg?.isEmpty)! && (waist?.isEmpty)!){
            Alert.showAlert(self, title: "Error", message: "Please fill the boxes")
        }
        savingSampleImage()
    }
    
}
