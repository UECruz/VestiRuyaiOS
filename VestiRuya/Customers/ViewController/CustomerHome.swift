//
//  CustomerHome.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 10/17/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import Kingfisher

class CustomerHome: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var orderTable: UITableView!
    @IBOutlet weak var tailorJobTable: UITableView!
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var orderButton: UIButton!
    
    let orderIdentifer = "orderAdded"
    
    var ref: DatabaseReference!
    
    var orders : [CustomerOrder] = []
    var tailorIntersted : [Dictionary<String, AnyObject>] = []
    let userDefaults = UserDefaults.standard
    

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(orderRecieved(_ :)), name: Notification.Name("ORDEROPLACED"), object: nil)
        
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        let customerUser = Auth.auth().currentUser?.uid
        ref.child("Customers").child("\(customerUser!)").observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            
            //  print(value?.description)
            print(snapshot.value ?? "")
            
            let username = value?["username"] as? String ?? "cs"
            self.navBar.topItem?.title = username
            
            self.checkOrder()
            self.getOrders()
        }){(error) in
            print(error.localizedDescription)
        }
       
        
        orderTable.delegate = self
        orderTable.dataSource = self
        
        tailorJobTable.estimatedRowHeight = 75
        tailorJobTable.rowHeight = UITableViewAutomaticDimension
        
    }
    
    func checkOrder(){
        ref.child("Customers").child("Orders").observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.childrenCount > 0{
                for x in snapshot.children.allObjects as! [DataSnapshot]{
                    if let obj = x.value as? [String : Any]{
                        
                        guard let userID = obj["userid"] as? String else  {
                            return
                        }
                        
                        if userID  != Auth.auth().currentUser?.uid {
                            continue
                        }
                        
                        print(userID)
                        
                        guard let confirm = obj["isJobConfirmed"] as? Bool else{
                            return
                        }
                        
                        if confirm == true{
                            self.ref.child("Customers").child("Orders").childByAutoId().removeValue()
                        }
                        
                        self.orders.removeAll()
                        self.orderTable.reloadData()
                        self.tailorJobTable.reloadData()
                    }
                }
            }
        })
    }

    @IBAction func profile(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomerProfile") as! CustomerProfile
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func goBack(_ sender: Any){
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "CustomerHome") as! CustomerHome
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    
    @objc func orderRecieved(_ notification : Notification) {
        guard let orderInfo = notification.userInfo else {
            return
        }
        
        if let order = orderInfo["order"] as? [Dictionary<String, AnyObject>] {
            //Order is added that will update table
            print("Order recieved ==== \(order)")
            let orderItem = OrderItems(bodyType: "", fabric: "", neckline: "", backDetail: "", straps: "", sleeve: "", embell: "")
            
            
            // Note: Can't find any alternative to the warming
            if let bodytype = order[0]["bodytype"] as? String {
                orderItem.bodyType = bodytype
            }
            
            if let fabric = order[1]["fabrics"] as? String {
                orderItem.fabric = fabric
            }
            
            if let neckLines = order[2]["neckline"] as? String {
                orderItem.neckline = neckLines
            }
            
            if let sleve = order[3]["sleeves"] as? String {
                orderItem.sleeves = sleve
            }
            
            if let strap = order[4]["straps"] as? String{
                orderItem.straps = strap
            }
            
            if let backDetails = order[5]["backDetails"] as? String{
                orderItem.backDetail = backDetails
            }
            
            if let embellishment = order[6]["embellishment"] as? String {
                orderItem.embellishment = embellishment
            }
            
            let price = order[7]["price"] as! String
            let date = order[7]["date"] as! String //index out of range
            let cOrder = CustomerOrder(username: self.navBar.topItem?.title ?? "", dateDue: date, priceTotal: Double(price)!, items: orderItem, isJobConfirmed: false)
            
            //orders.append(cOrder)
            //orderTable.reloadData()
            
            let customerUser = Auth.auth().currentUser?.uid
            ref = Database.database().reference()
            ref.child("Customers").child("\(customerUser!)").observe(.value, with: {(snapshot) in
                
                let val = snapshot.value as? NSDictionary
                let name = val?["username"] as? String
                let profileImageURL = val?["profilePic"] as? String
                
                var orderItemDict:Dictionary<String, AnyObject> = Dictionary()
                orderItemDict.updateValue(cOrder.orderItems.backDetail as AnyObject, forKey: "backdetail")
                 orderItemDict.updateValue(cOrder.orderItems.bodyType as AnyObject, forKey: "bodytype")
                 orderItemDict.updateValue(cOrder.orderItems.embellishment as AnyObject, forKey: "embellishment")
                orderItemDict.updateValue(cOrder.orderItems.fabric as AnyObject, forKey: "fabric")
                orderItemDict.updateValue(cOrder.orderItems.neckline as AnyObject, forKey: "neckline")
                orderItemDict.updateValue(cOrder.orderItems.sleeves as AnyObject, forKey: "sleeves")
                orderItemDict.updateValue(cOrder.orderItems.straps as AnyObject, forKey: "straps")
                
                
                let ordesFir = ["userid": customerUser!, "username": name ?? "","photoImage": profileImageURL ?? "", "price": price, "items": orderItemDict, "interestsShown":[], "date": date,"tailorID":"", "isJobConfirmed":false,"canEdit":false] as [String : Any]
                
                
                if self.isEditing{
                    self.ref.child("Customers").child("Orders").observeSingleEvent(of: .value, with: {(snapshot) in
                        if snapshot.childrenCount > 0{
                            for x in snapshot.children.allObjects as! [DataSnapshot]{
                                print("Object a: \(String(describing: snapshot.description))")
                                if let obj = x.value as? [String: Any]{
                                    guard let userId = obj["userid"] as? String else{
                                        return
                                    }
                                    
                                    if userId  != Auth.auth().currentUser?.uid {
                                        continue
                                    }
                                    print(x.key)
                                    
                                    self.ref.child("Customers").child("Orders").child(x.key).updateChildValues(ordesFir, withCompletionBlock: { (error, dbref) in
                                        self.getOrders()
                                    })
                                    
                                }
                            }
                        }
                    })
                    
                }else{
                    self.ref.child("Customers").child("Orders").childByAutoId().updateChildValues(ordesFir, withCompletionBlock: { (error, dbref) in
                        self.getOrders()
                    })
                }
               
            })
        }
    }
    
    
    func getOrders() {
        self.orders.removeAll()
        self.tailorIntersted.removeAll()
        self.ref.child("Customers").child("Orders").observe(.value) { (snapshot) in
            self.orders.removeAll()
            self.tailorIntersted.removeAll()
            if snapshot.childrenCount > 0 {
                for x in snapshot.children.allObjects as! [DataSnapshot] {
                    if let obj = x.value as? [String : Any] {
                        
                        guard let userID = obj["userid"] as? String else  {
                            return
                        }
                        
                        if userID  != Auth.auth().currentUser?.uid {
                            continue
                        }
                        let items = OrderItems(bodyType: "", fabric: "", neckline: "", backDetail: "", straps: "", sleeve: "", embell: "")
                        
                        if let orderItems = obj["items"] as? Dictionary<String, AnyObject> {
                            if let fabric = orderItems["fabric"] as? String {
                                items.fabric = fabric
                                print(fabric)
                            }
                            if let embellishment = orderItems["embellishment"] as? String {
                                items.embellishment = embellishment
                            }
                            if let neckline = orderItems["neckline"] as? String {
                                items.neckline = neckline
                            }
                            if let straps = orderItems["straps"] as? String {
                                items.straps = straps
                            }
                            if let backdetail = orderItems["backdetail"] as? String {
                                items.backDetail = backdetail
                            }
                            if let bodytype = orderItems["bodytype"] as? String {
                                items.bodyType = bodytype
                            }
                            if let sleeves = orderItems["sleeves"] as? String {
                                items.sleeves = sleeves
                            }
                        }
                        
                        if let userName  = obj["username"] as? String, let price  = obj["price"] as? String, let date = obj["date"] as? String, let isJobConfirmed = obj["isJobConfirmed"] as? Bool  {
                            let cOrder = CustomerOrder(username:userName, dateDue: date, priceTotal: Double(price)!, items: items, isJobConfirmed: isJobConfirmed)
                            
                            print(cOrder.description)
                            self.orders.append(cOrder)
                            
                            if let tailorsInterested = obj["interestsShown"] as? [AnyObject] {
                                for dct in tailorsInterested {
                                    if let tailorInfo = dct as? Dictionary<String, AnyObject
                                        > {
                                        if !isJobConfirmed  {
                                            self.tailorIntersted.append(tailorInfo)
                                        }
                                    }
                                }
                            }
                        }
                        
                        
                    }
                }
                
                self.orders = self.orders.filter({ $0.isJobConfirmed == false })
                self.tailorIntersted = self.tailorIntersted.filter({ (dict) -> Bool in
                    (dict["isJobAccepted"] as? Bool) == true
                })
                self.orderTable.reloadData()
                self.tailorJobTable.reloadData()
            }
        }
    }
    
    
    func Next(){
        let goToCustomScreen = self.storyboard?.instantiateViewController(withIdentifier: "CustomScreen01") as! CustomScreen01
        if navigationController != nil {
            self.navigationController?.pushViewController(goToCustomScreen, animated: true)
        } else {
            present(goToCustomScreen, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addOrder(_ sender: UIButton) {
        Next()
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
        let goToCustomScreen = self.storyboard?.instantiateViewController(withIdentifier: "CustomScreen01") as! CustomScreen01
        self.navigationController?.pushViewController(goToCustomScreen, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count : Int?
        if tableView == self.orderTable{
           count = orders.count
            self.orderTable.backgroundView = nil
            if count == 0 {
                let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
                emptyLabel.text = "No order Added"
                emptyLabel.textAlignment = NSTextAlignment.center
                
                self.orderButton.isHidden = false
                
                self.orderTable.backgroundView = emptyLabel
                self.orderTable.separatorStyle = UITableViewCellSeparatorStyle.none
                return 0
            }else if count != 0{
                self.orderButton.isHidden = true
            }
            else{
                self.orderButton.isHidden = false
                return orders.count
            }
        }
        
        if tableView == self.tailorJobTable{
            count = tailorIntersted.count
            self.tailorJobTable.backgroundView = nil
            
            if count == 0{
                let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
                emptyLabel.text = "No Tailor Are Intertest Yet."
                emptyLabel.textAlignment = NSTextAlignment.center
                self.tailorJobTable.backgroundView = emptyLabel
                self.tailorJobTable.separatorStyle = UITableViewCellSeparatorStyle.none
                return 0
            }else{
                 return tailorIntersted.count
            }
            
        }
        
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == orderTable{
            
           let cell = tableView.dequeueReusableCell(withIdentifier: "orderAdded") as! SummaryItem
            let orderSummary = orders[indexPath.row]
            print(orderSummary.description)
            cell.name.text = orderSummary.username?.capitalized
            cell.price.text = String(format: "$%.2f", orderSummary.totalPrice)
            cell.backDetail.text = orderSummary.orderItems.backDetail?.capitalized
            cell.fabric.text = orderSummary.orderItems.fabric?.capitalized
            cell.bodyType.text = orderSummary.orderItems.bodyType?.capitalized
            cell.neckline.text = orderSummary.orderItems.neckline?.capitalized
            cell.sleeves.text = orderSummary.orderItems.sleeves?.capitalized
            cell.straps.text = orderSummary.orderItems.straps?.capitalized
            cell.embell.text = orderSummary.orderItems.embellishment?.capitalized
            
           return cell
        }

        let cell02 = tableView.dequeueReusableCell(withIdentifier: "tailorAdded") as! TailorOffer
        
        let dict = tailorIntersted[indexPath.row]
        if let tailorname = dict["tailorname"] as? String {
            cell02.tailorName.text = tailorname
        }
        
        
        if let tailorPic = dict["tailorPic"] as? String{
            cell02.tailorPic.kf.setImage(with: URL(string: tailorPic))
            cell02.tailorPic.contentMode = .scaleAspectFit
        }
        
        return cell02
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        if tableView == orderTable{
            let deleteBtm  = UITableViewRowAction(style: .default, title: "Delete") { (rowAction, indexPath) in
              
                self.deleteOrder()
                self.orders.remove(at: indexPath.row)
                self.orderTable.reloadData()
            }
            
            let editBtm = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
                self.isEditing = true
                let goToCustomScreen = self.storyboard?.instantiateViewController(withIdentifier: "CustomScreen01") as! CustomScreen01
                self.navigationController?.pushViewController(goToCustomScreen, animated: true)
            }
            
            editBtm.backgroundColor = UIColor.blue
            
            
            return [editBtm,deleteBtm]
        }
        
        return []
        
    }
    
    
    func deleteOrder(){
        ref.child("Customers").child("Orders").observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.childrenCount > 0 {
                for x in snapshot.children.allObjects as! [DataSnapshot]{
                    print("Object a: \(String(describing: snapshot.description))")
                    if let obj = x.value as? [String: Any]{
                        guard let userId = obj["userid"] as? String else{
                            return
                        }
                        
                        if userId != Auth.auth().currentUser?.uid {
                            continue
                        }
                        print(x.key)
                        
                        self.ref.child("Customers").child("Orders").child(x.key).removeValue(completionBlock: { (error, ref) in
                            self.ref.child("Tailors").child("Job").child(x.key).removeValue(completionBlock: { (jerror
                                , jref) in
                                self.getOrders()
                                self.tailorJobTable.reloadData()
                            })
                        })
                
                        

                    
                    }
                }
                
            }
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tailorJobTable {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TailorInfo") as! TailorInfo
            vc.tailorInfo =  tailorIntersted[indexPath.row]
            if let _ = self.navigationController {
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}
