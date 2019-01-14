//
//  CustomScreen04.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 10/19/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Alamofire
import AlamofireImage
import Kingfisher


class CustomScreen04: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var collectionview04: UICollectionView!
    var customDress:[Dictionary<String, AnyObject>]!
    
    var data = [Material]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.topItem?.title = "Select Your Sleeves"
        
        self.collectionview04.delegate = self
        self.collectionview04.dataSource = self
        
        // Do any additional setup after loading the view.
        
        let ref = Database.database().reference()
        ref.child("Materials").child("Sleeves").observe(DataEventType.value, with: {(snap) in
            if snap.childrenCount > 0{
                for x in snap.children.allObjects as! [DataSnapshot]{
                    if let obj = x.value as? [String:Any]{
                        let object = Material.init(title: obj["name"] as! String, picURL: obj["image"] as! String)
                        
                        self.data.append(object)
                        print(object.description)
                    }
                }
                self.collectionview04.reloadData()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell04", for: indexPath) as! ItemDetail04
        
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
        
        if customDress.count == 4 {
            customDress.remove(at: 3)
        }
        var dict = Dictionary<String, AnyObject>()
        dict.updateValue(material.title as AnyObject, forKey: "sleeves")
        customDress.append(dict)
        
    }
    
    @IBAction func navigateToNextScreen(_ sender : Any) {
        if customDress.count == 3 {
            //user did not select bidy type show errro message
        } else {
            let customScreen = self.storyboard?.instantiateViewController(withIdentifier: "CustomScreen05") as! CustomScreen05
//            if let bodyType = customDress[4] as? Dictionary<String,AnyObject> {
//                print("User selected bodytype == \(bodyType["sleeves"])")
//            }
            customScreen.customDress = customDress
            self.navigationController?.pushViewController(customScreen, animated: true)
        }
    }

}
