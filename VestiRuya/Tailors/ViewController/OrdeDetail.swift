//
//  OrdeDetail.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 10/27/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import UIKit
import Kingfisher
import UserNotifications
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD
import CLImageViewPopup

class OrdeDetail: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var customerPic: UIImageView!
    
    @IBOutlet weak var strap: UILabel!
    @IBOutlet weak var sleeve: UILabel!
    @IBOutlet weak var neckline: UILabel!
    @IBOutlet weak var backdeail: UILabel!
    @IBOutlet weak var embell: UILabel!
    @IBOutlet weak var fabric: UILabel!
    @IBOutlet weak var dressType: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    let checkedImage = UIImage(named: "Checked Black")
    let unCheckedImage = UIImage(named: "Checked White")
    
    let value = ["isConfimed": true]
    var orderInfo: Dictionary<String, AnyObject>?
    var custoInfo : Dictionary<String,AnyObject>?
    var selects : JobOrders?
    var transfer: SideJob?
    var customerId: String?
    var ref: DatabaseReference!
    var storageRef: StorageReference!
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    
    var sample1: UIImagePickerController?
    var sample2: UIImagePickerController?
    var sample3: UIImagePickerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertPopup()
        
        ref = Database.database().reference()
        storageRef = Storage.storage().reference()
        self.navigationBar.topItem?.title = "Order Detail"

        // Do any additional setup after loading the view.
        customerName.text = transfer?.name
        customerPic.kf.setImage(with: URL(string: (transfer?.urlPic)!))
        strap.text = transfer?.items.straps
        neckline.text = transfer?.items.neckline
        backdeail.text = transfer?.items.backDetail
        embell.text = transfer?.items.embellishment
        fabric.text = transfer?.items.fabric
        dressType.text = transfer?.items.bodyType
        sleeve.text = transfer?.items.sleeves
        price.text = String(format: "$%.2f",(transfer?.price)!)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        customerPic.isUserInteractionEnabled = true
        customerPic.addGestureRecognizer(tapGestureRecognizer)
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: {didAllow,error in
            
        })
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        _ = tapGestureRecognizer.view as! UIImageView
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomerInfo") as! CustomerInfo
        vc.select = self.transfer
        vc.selects = self.selects
        
        if self.navigationController != nil{
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.present(vc, animated: true, completion: nil)
        }
    }
    

    @IBAction func imageUpload1(_ sender: Any) {
        sample1 = UIImagePickerController()
        sample1! .delegate = self
        sample1! .allowsEditing = false
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
    
    func openGallery1(){
        if(UIImagePickerController .isSourceTypeAvailable(.photoLibrary)){
            sample1!.sourceType = .photoLibrary
            sample1! .mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            present(sample1!, animated: true, completion: nil)
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
    
    func openGallery2(){
        if(UIImagePickerController .isSourceTypeAvailable(.photoLibrary)){
            sample2!.sourceType = .photoLibrary
            sample2! .mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            present(sample2!, animated: true, completion: nil)
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
    
    func openGallery3(){
        if(UIImagePickerController .isSourceTypeAvailable(.photoLibrary)){
            sample3!.sourceType = .photoLibrary
            sample3! .mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            present(sample3!, animated: true, completion: nil)
        }
    }
    
    @IBAction func saveSampleWork(_ sender: Any){
        savingSamples()
    }
    
    //Save photos to order
    func savingSamples(){
        let tailorUser = Auth.auth().currentUser?.uid
        
        guard let image1 = self.image1.image else {return}
        guard let image2 = self.image2.image else {return}
        guard let image3 = self.image3.image else {return}
        
        let imageArray = [image1,image2,image3]
        
        var index = 1
        SVProgressHUD.show()
        for im in imageArray{
            let storageRef = self.storageRef.child("orders_images").child("\(tailorUser!)_File_\(index)")
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
    
    
    @IBAction func BackBtm(_ sender: Any) {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func alertPopup(){
        Alert.showAlert(self, title: "Advice", message: "Click on image to get detail on the current customer")
    }
    

    @IBAction func finishBTM(_ sender: Any) {
        savingSamples()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TailorHome") as! TailorHome
        
        ref.child("Tailors").child("Job").observe(.value){(snapshot) in
            if snapshot.childrenCount > 0 {
                for y in snapshot.children.allObjects as! [DataSnapshot]{
                    if let obj = y.value as? [String:Any] {
                        
                        guard let userID = obj["userId"] as? String else{return}
                        
                        if userID != Auth.auth().currentUser?.uid {
                            continue
                        }
                        print(snapshot.value ?? "")
                        print(userID)
                    
                        let x = obj["isConfimed"] as? String
                        let updatedJob = ["isConfimed" : true] as [String : Any]
                        
                        self.ref.child("Tailors").child("Job").child(y.key).updateChildValues(updatedJob, withCompletionBlock: { (error, reference) in
                            if error == nil {
                                print("Object: \(String(describing: x?.description))")
                            }
                        })
                    }
                }
            }
            
        }
        print(value.description)
        
        if self.navigationController != nil{
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.present(vc, animated: true, completion: nil)
        }
         
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
