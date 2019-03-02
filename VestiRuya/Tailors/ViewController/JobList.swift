//
//  JobList.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 10/22/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class JobList: UIViewController ,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    var data = [OrderData]()

    var ref:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.topItem?.title = "List of Job"
        
        tableView.delegate = self
        tableView.dataSource = self
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
        getOrdersList()
    }
    
    @IBAction func back(_ sender: Any) {
        if let _ = self.navigationController {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func getOrdersList() {
       
        self.ref.child("Customers").child("Orders").observe(.value) { (snapshot) in
            self.data.removeAll()
            if snapshot.childrenCount > 0{
                for x in snapshot.children.allObjects as! [DataSnapshot]{
                    

                    if let obj = x.value as? [String : Any]{
    
                       
                        let items = OrderItems(bodyType: "", fabric: "", neckline: "", backDetail: "", straps: "", sleeve: "", embell: "")
                        if let orderItems = obj["items"] as? Dictionary<String, AnyObject> {
                            if let fabric = orderItems["fabric"] as? String {
                                items.fabric = fabric
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
                        
                        var orderAmount = "0"
                        if let userName  = obj["username"] as? String, let pics =  obj["photoImage"] as? String, let price  = obj["price"] as? String, let date = obj["date"] as? String {
                            orderAmount = price
                            let orderData = OrderData.init(username: userName, pc: pics, dateDue: date, priceTotal: Double(orderAmount)!, items: items)
                            
                            if let userID = obj["userid"] as? String{
                                orderData.customerId = userID
                            }
                            
                            print(orderData.customerId ?? "")
                            
                            if let isJobConfirmed = obj["isJobConfirmed"] as? Bool {
                                orderData.isJobConfirmed = isJobConfirmed
                            }
                            
                            if let tailorID = obj["tailorID"] as? String {
                                orderData.tailorID = tailorID
                            }
                            
                            
                            
                            orderData.orderID =   x.key
                            
                            //orderID
                            print(orderData.orderID ?? "")
                            
                            if let tailorsInterested = obj["interestsShown"] as? [AnyObject] {
                                orderData.intrestsShown = tailorsInterested
                            }
                            
                            let tailorAccepted =  orderData.intrestsShown.filter({ (tailorIntrested) -> Bool in
                                if let obj = tailorIntrested as? [String: Any], let isJobAccepted = obj["isJobAccepted"] as? Bool {
                                    return isJobAccepted
                                } else {
                                    return false
                                }
                            })
                            
                            if tailorAccepted.count == 0 {
                                self.data.append(orderData)
                            
                                print(orderData.customerId ?? "")
                            }
                        }
                    }
                }
                self.data = self.data.filter({ $0.isJobConfirmed == false })
                //if job is accepted it should not show on the list of job
                self.tableView.reloadData()
            } else {
                self.tableView.reloadData()
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell01", for: indexPath) as! JobCell
        
        let x: OrderData
        
        x = data[indexPath.row]
        
        var imageUrl = ""
        if let image = x.picUrl  {
            imageUrl = image
        }
        
        cell.customerName.text = x.username
        cell.profilePic.kf.setImage(with: URL(string: imageUrl))
        cell.priceLabel.text = String(format: "$%.2f",x.totalPrice)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return data.count
    }
    
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "JobDetails") as! JobDetail
         vc.selects = self.data[indexPath.row]
        if let _ = self.navigationController{
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.present(vc, animated: true, completion: nil)
        }
        
        
    }

}
