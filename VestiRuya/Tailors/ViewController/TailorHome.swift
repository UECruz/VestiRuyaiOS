//
//  TailorHome.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 10/14/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import Kingfisher

class TailorHome: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var tableview2: UITableView!
    
    var ref: DatabaseReference!
    
    var jobs : [JobOrders] = []
    var sides: [SideJob] = []
    var orderAccepted : [Dictionary<String, AnyObject>] = []
    var tailorJobs: [TailorJob] = []
    var finishedJobs: [TailorJob] = []
    
    var pricey:Double = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if jobs.count != 0{
//            calltoAction()
//        }
        
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(jobAccepted(_:)), name: Notification.Name("JobAccepted"), object: nil)

        // Do any additional setup after loading the view.
        let tailorUser = Auth.auth().currentUser?.uid
        ref = Database.database().reference()
        
        getFinishedOrders()
        getDetails()
        
        ref.child("Tailors").child("\(tailorUser!)").observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            
            print(snapshot.value ?? "")
            
            let username = value?["username"] as? String ?? "cs"
            self.navBar.topItem?.title = username
            
           
            self.jobAccept()
            self.calltoAction()
           
            
        }){(error) in
            print(error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func jobAccepted(_ notification: Notification){
        guard let jobInfo = notification.userInfo else{
            return
        }
        
        if let accepted = jobInfo["OrderAccept"] as? [Dictionary<String,AnyObject>] {
            print("Job accept === \(accepted)")
            
             let orderItem = OrderItems(bodyType: "", fabric: "", neckline: "", backDetail: "", straps: "", sleeve: "", embell: "")
            
            guard let infoDict = accepted[0] as? Dictionary<String, AnyObject> else {
                return
            }
            
            let customerProfile = infoDict["profileImageURL"] as! String
            
            if let embell = infoDict["embellish"] as? String{
                orderItem.embellishment = embell
            }
            
            if let stra = infoDict["straps"] as? String{
                 orderItem.straps = stra
            }
            
            
            if let sleve = infoDict["sleeves"] as? String{
                orderItem.sleeves = sleve
            }
            
            let customerName = infoDict["userName"] as! String
            
            let acc = infoDict["jobAccept"] as! Bool
            
            guard let isConfirmed = infoDict["isConfimed"] as? Bool else {
                return
            }
            
            if let bt = infoDict["bodytype"] as? String{
                orderItem.bodyType = bt
            }
            
            if let fab = infoDict["fabrics"] as? String{
                orderItem.fabric = fab
            }
            
            let price = infoDict["price"] as! String
            
            if let bD = infoDict["backDetails"] as? String{
                orderItem.backDetail = bD
            }
            
            if let neckLines = infoDict["neckline"] as? String{
                orderItem.neckline = neckLines
            }
            
            let tailorJob = JobOrders(username: customerName, pic: customerProfile, priceTotal: Double(price)!, items: orderItem, opion: acc, userId: "FakeId11Fake",isConfirmed: isConfirmed)
            
            print(tailorJob.description)
            
            jobs.append(tailorJob)
            tableview.reloadData()
        }
        
    }
    
    private func getFinishedOrders() {
        ref.child("Tailors").child("Job").observe(.value) { snapshot in
            if snapshot.childrenCount > 0 {
                self.tailorJobs.removeAll()
                for tailorJob in snapshot.children.allObjects as! [DataSnapshot] {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: tailorJob.value as Any, options: .prettyPrinted)
                        let decoder = JSONDecoder()
                        let job = try decoder.decode(TailorJob.self, from: data)
                        self.tailorJobs.append(job)
                    } catch let error {
                        print(error)
                    }
                }
                
                self.finishedJobs = self.tailorJobs.filter({ (job) -> Bool in
                    job.isConfimed == true
                })
                
                self.tableview2.reloadData()
            }
        }
    }
    
    @IBAction func profileBtm(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TailorProfile") as! TailorProfile
         self.present(vc, animated: false, completion: nil)
    }
    func jobAccept(){
        self.jobs.removeAll()
        self.ref.child("Tailors").child("Job").observe(.value){(snapshot) in
            if snapshot.childrenCount > 0{
                for x in snapshot.children.allObjects as! [DataSnapshot]{
                    if let obj = x.value as? [String:Any]{
                        
                        guard let userID = obj["userId"] as? String else{
                            return
                        }
                        
                        if userID != Auth.auth().currentUser?.uid{
                            continue
                        }
                        
                        let items = OrderItems(bodyType: "", fabric: "", neckline: "", backDetail: "", straps: "", sleeve: "", embell: "")
                        
                        if let orderItem = obj["items"] as? Dictionary<String,AnyObject>{
                            
                            if let fabric = orderItem["fabric"] as? String {
                                items.fabric = fabric
                                print(fabric)
                            }
                            
                            if let embellishment = orderItem["embellish"] as? String{
                                items.embellishment = embellishment
                                print(embellishment)
                            }
                            
                            if let neckline = orderItem["neckline"] as? String{
                                items.neckline = neckline
                            }
                            
                            if let strap = orderItem["strap"] as? String{
                                items.straps = strap
                            }
                            
                            if let backDetail = orderItem["backDetail"] as? String{
                                items.backDetail = backDetail
                            }
                            
                            if let bodytype = orderItem["dressType"] as? String{
                                items.bodyType = bodytype
                            }
                            
                            if let sleeve = orderItem["slevee"] as? String{
                                items.sleeves = sleeve
                            }
                            
                            guard let image = obj["pics"] as? String else {
                                return
                            }
                            
                            guard let price  = obj["price"] as? String else {
                                return
                            }
                            
                            guard let userName  = obj["name"] as? String else {
                                return
                            }
                            
                            guard let isAccepted  = obj["isAccepted"] as? Bool else {
                                return
                            }
                            
                            guard let isConfirmed = obj["isConfimed"] as? Bool else {
                                return
                            }
                            
                            let userId = userID
                            
                            let str = price
                            
                            let formatter = NumberFormatter()
                            formatter.numberStyle = .currency
                            
                            if let number = formatter.number(from: str) {
                                let amount = number.doubleValue
                                print(amount)
                                self.pricey = amount
                            }
                            
                            let pack = JobOrders(username: userName, pic: image, priceTotal: self.pricey, items: items, opion: isAccepted, userId: userId, isConfirmed: isConfirmed)
                            
                            print(pack.description)
                            self.jobs.append(pack)
                        }
                        
                        self.tableview.reloadData()
                    }
                    
                }
            }
        }
    }
    
    func getDetails(){
        self.ref.child("Tailors").child("Job").observe(.value){(snapshot) in
            if snapshot.childrenCount > 0{
                for x in snapshot.children.allObjects as! [DataSnapshot]{
                    if let obj = x.value as? [String:Any]{
                        
                        guard let userID = obj["userId"] as? String else{
                            return
                        }
                        
                        if userID != Auth.auth().currentUser?.uid{
                            continue
                        }
                        
                        guard let id = obj["customerId"] as? String else{
                            return
                        }
                        print(id)
                        let items = OrderItems(bodyType: "", fabric: "", neckline: "", backDetail: "", straps: "", sleeve: "", embell: "")
                        
                        if let orderItem = obj["items"] as? Dictionary<String,AnyObject>{
                            
                            if let fabric = orderItem["fabric"] as? String {
                                items.fabric = fabric
                                print(fabric)
                            }
                            
                            if let embellishment = orderItem["embellish"] as? String{
                                items.embellishment = embellishment
                                print(embellishment)
                            }
                            
                            if let neckline = orderItem["neckline"] as? String{
                                items.neckline = neckline
                            }
                            
                            if let strap = orderItem["strap"] as? String{
                                items.straps = strap
                            }
                            
                            if let backDetail = orderItem["backDetail"] as? String{
                                items.backDetail = backDetail
                            }
                            
                            if let bodytype = orderItem["dressType"] as? String{
                                items.bodyType = bodytype
                            }
                            
                            if let sleeve = orderItem["slevee"] as? String{
                                items.sleeves = sleeve
                            }
                            
                            guard let image = obj["pics"] as? String else {
                                return
                            }
                            
                            guard let price  = obj["price"] as? String else {
                                return
                            }
                            
                            guard let userName  = obj["name"] as? String else {
                                return
                            }
                            
                            guard let isAccepted  = obj["isAccepted"] as? Bool else {
                                return
                            }
                            
                            guard let isConfirmed = obj["isConfimed"] as? Bool else {
                                return
                            }
                            
                            let userId = x.key
                            
                            
                            let str = price
                            
                            let formatter = NumberFormatter()
                            formatter.numberStyle = .currency
                            
                            if let number = formatter.number(from: str) {
                                let amount = number.doubleValue
                                print(amount)
                                self.pricey = amount
                            }
                            
                            let pack2 = SideJob(username: userName, pic: image, priceTotal: self.pricey, items: items, opion: isAccepted, userId: userId, custId: id, isConfirmed: isConfirmed)
                            print(pack2.description)
                            
                            self.sides.append(pack2)
                        }
                    }
                    
                }
            }
        }
    }
    
    func Next(){
        let goToCustomScreen = self.storyboard?.instantiateViewController(withIdentifier: "JobList") as! JobList
        self.present(goToCustomScreen, animated: false, completion: nil)
        self.navigationController?.pushViewController(goToCustomScreen, animated: true)
    }
    
    @IBAction func FindJobBTM(_ sender: Any) {
        startAction()
    }
    
    func startAction() {
        Next()
    }
    
    func calltoAction() {
        if jobs.count == 0 && sides.count == 0{
            startAction()
        }
    }

}

extension TailorHome{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableview {
            self.tableview.backgroundView = nil
            if jobs.count == 0 {
                let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
                emptyLabel.text = "No job accepted yet"
                emptyLabel.textAlignment = NSTextAlignment.center
                
                self.tableview.backgroundView = emptyLabel
                self.tableview.separatorStyle = UITableViewCellSeparatorStyle.none
        
                return jobs.count
            } else {
                let acceptedJobs = self.jobs.filter({ (job) -> Bool in
                    job.accepted == true && job.isConfirmed == false
                })
                
                return acceptedJobs.count
            }
            
        } else if tableView == self.tableview2 {
            self.tableview2.backgroundView = nil
            if finishedJobs.count == 0{
                let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
                emptyLabel.text = "History are't made yet"
                emptyLabel.textAlignment = NSTextAlignment.center
                
                self.tableview2.backgroundView = emptyLabel
                self.tableview2.separatorStyle = UITableViewCellSeparatorStyle.none
                return finishedJobs.count
            }
            return finishedJobs.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tableview {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell01") as! JobAcceptCell
            let orderDesc = jobs[indexPath.row]
            
            var imageUrl = ""
            if let image = orderDesc.urlPic   {
                imageUrl = image
            }
            
            cell.name.text = orderDesc.name
            cell.imageView2.kf.setImage(with: URL(string: imageUrl))
            cell.price.text = String(format: "$%.2f",Double(orderDesc.price))
            
            return cell
        } else if tableView == tableview2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell02") as! HistoryCell
            
            let job = finishedJobs[indexPath.row]
            cell.orderLabel.text = job.name
            if let urlString = job.pics, let imageURL = URL(string: urlString) {
                cell.orderImageView.af_setImage(withURL: imageURL)
            }
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrdeDetail") as! OrdeDetail
        vc.selects = jobs[indexPath.row]
         vc.transfer = sides[indexPath.row]
        vc.customerId = sides[indexPath.row].originalId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
