//
//  CustomDressType.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 10/17/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Alamofire
import Kingfisher

class CustomScreen01: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var collectionview01: UICollectionView!
    
    var data = [Material]()
    var customDress = [Dictionary<String, AnyObject>]()
    var dress = [Dictionary<String, AnyObject>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.topItem?.title = "Select Your Dress Type"
        
        self.collectionview01.delegate = self
        self.collectionview01.dataSource = self

        // Do any additional setup after loading the view.
        
        let ref = Database.database().reference()
        ref.child("Materials").child("Silhouette").observe(DataEventType.value, with: {(snap) in
            if snap.childrenCount > 0{
                for x in snap.children.allObjects as! [DataSnapshot]{
                    if let obj = x.value as? [String:Any]{
                        let object = Material.init(title: obj["name"] as! String, picURL: obj["image"] as! String)
                        
                        self.data.append(object)
                        print(object.description)
                    }
                }
                
                self.collectionview01.reloadData()
            }
        })
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell01", for: indexPath) as! ItemDetail01
        
        let x : Material
        
        x = data[indexPath.row]
        cell.label.text = x.title?.capitalized.uppercased()
        
        var imageUrl = ""
        if let image = x.pic   {
            imageUrl = image
        }
      
        cell.imageview.kf.setImage(with: URL(string: imageUrl))
        
        cell.imageview.layer.borderColor = UIColor.clear.cgColor
        cell.imageview.layer.borderWidth = 0.0
        if x.isItemSelected == true {
            cell.imageview.layer.borderColor = UIColor.red.cgColor
            cell.imageview.layer.borderWidth = 4.0
        }
     
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        for  mtr in data {
            mtr.isItemSelected = false
        }
      
        let material = data[indexPath.row]
        material.isItemSelected = !material.isItemSelected
        data[indexPath.row] = material
        collectionView.reloadData()
        
        if customDress.count == 1 {
            customDress.removeAll()
        }
        var dict = Dictionary<String, AnyObject>()
        dict.updateValue(material.title as AnyObject, forKey: "bodytype")
        dict.updateValue(material.pic as AnyObject, forKey: "bodytypeImage")
        customDress.append(dict)
        
        var dressType = Dictionary<String, AnyObject>()
        dressType.updateValue(material.title as AnyObject, forKey: "type")
        dressType.updateValue(material.pic as AnyObject, forKey: "image")
        dress.append(dressType)
        
    }
    
    
    @IBAction func backBTm(_ sender: Any) {
      self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func navigateToNextScreen(_ sender : Any) {
        if customDress.count == 0 {
            Alert.showAlert(self, title: "Error", message: "Please select one card to process")
        } else {
            let customScreen = self.storyboard?.instantiateViewController(withIdentifier: "CustomScreen02") as! CustomScreen02
            customScreen.customDress = customDress
            customScreen.dress = dress
            
            if let navController = self.navigationController {
                self.navigationController?.pushViewController(customScreen, animated: true)
            } else {
                self.present(customScreen, animated: true, completion: nil)
            }
        }
    }
    
}
