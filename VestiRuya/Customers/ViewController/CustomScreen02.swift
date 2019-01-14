//
//  CustomScreen02.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 10/19/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Alamofire
import Kingfisher

class CustomScreen02: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var collectionview02: UICollectionView!
    
    var data = [Material]()
    var customDress:[Dictionary<String, AnyObject>]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.topItem?.title = "Select Your Fabric"
        
        self.collectionview02.delegate = self
        self.collectionview02.dataSource = self
        
        // Do any additional setup after loading the view.
        
        let ref = Database.database().reference()
        ref.child("Materials").child("Fabrics").observe(DataEventType.value, with: {(snap) in
            if snap.childrenCount > 0{
                for x in snap.children.allObjects as! [DataSnapshot]{
                    
                    if let arrayObj = x.value as? [Dictionary<String, AnyObject>] {
                        for obj in arrayObj {
                            let object = Material.init(title: obj["name"] as! String, picURL: obj["image"] as! String)
                            self.data.append(object)
                        }
                    }
                    if let object = x.value as? [String:Any]{
                        if let applique = object["Applique"] as? [Dictionary<String, AnyObject>]{
                            for obj in applique {
                                let object = Material.init(title: obj["name"] as! String, picURL: obj["image"] as! String)
                                self.data.append(object)
                            }
                        }
                        
                        if let plain = object["Plain"] as? [Dictionary<String, AnyObject>]{
                            for obj in plain {
                                let object = Material.init(title: obj["name"] as! String, picURL: obj["image"] as! String)
                                self.data.append(object)
                            }
                        }
                        
                        
                        if let trim = object["Trim"] as? [Dictionary<String, AnyObject>]{
                            for obj in trim {
                                let object = Material.init(title: obj["name"] as! String, picURL: obj["image"] as! String)
                                self.data.append(object)
                            }
                        }
                    }
                }
            }
            
             self.collectionview02.reloadData()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell02", for: indexPath) as! ItemDetail02
        
        let x : Material
        
        x = data[indexPath.row]
        cell.label.text = x.title?.capitalized
        
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
        
        if customDress.count == 2 {
            customDress.remove(at: 1)
        }
        var dict = Dictionary<String, AnyObject>()
        dict.updateValue(material.title as AnyObject, forKey: "fabrics")
        customDress.append(dict)
        
    }
    
    
    @IBAction func navigateToNextScreen(_ sender : Any) {
        if customDress.count == 1 {
            //user did not select bidy type show errro message
        } else {
            let customScreen = self.storyboard?.instantiateViewController(withIdentifier: "CustomScreen03") as! CustomScreen03
            customScreen.customDress = customDress
            print("Custom dress = \(customDress)")
            
            //Use for last screen for summary
//            if let bodyType = customDress[0] as? Dictionary<String,AnyObject> {
//                print("User selected bodytype == \(bodyType["bodytype"])")
//            }
            //result:
//            Custom dress = Optional([["bodytype": Short], ["fabrics": WHEAT PATTERNED CORDING/ CHEMICAL LACE]])
//            User selected bodytype == Optional(Short)
            
            self.navigationController?.pushViewController(customScreen, animated: true)
        }
    }
    
    
}
