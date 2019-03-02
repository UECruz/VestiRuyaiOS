//
//  PayView.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 11/2/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import Cosmos

class PayView: UIViewController, PayPalPaymentDelegate {

    @IBOutlet weak var nav: UINavigationBar!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var reviewView: CosmosView!
    @IBOutlet weak var txtView: UITextView!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    var summary: [TailorJob] = [TailorJob]()
    var desiredSummary: TailorJob!
    var payPalConfig = PayPalConfiguration()
    var payment = PayPalPayment()
    var environment:String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    var dataRef = Database.database().reference()
    var loggedUser : AnyObject?
    var name: String?
    var irlPhoto: String?
    var customerOrders = [OrderForCustomer]()
    var desiredOrder: OrderForCustomer?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        PayPalMobile.preconnect(withEnvironment: environment)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nav.topItem?.title = "Payment"
        
        orderUpdate()
        
        priceLabel.text = desiredSummary.price

        // Do any additional setup after loading the view.
        payPalConfig.acceptCreditCards = false
        payPalConfig.merchantName = "VestiRuya"
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        
        payPalConfig.payPalShippingAddressOption = .both
        
        self.loggedUser = Auth.auth().currentUser
        txtView.textContainerInset = UIEdgeInsetsMake(30, 20, 20, 20)
        txtView.text = "How was this tailor?"
        txtView.textColor = UIColor.lightGray
    }
    
    @IBAction func payPal(_ sender: Any) {
        let maxLength = desiredSummary.price?.count ?? 1
        let price = String(desiredSummary.price?.suffix(maxLength - 1) ?? "0")
        let paypalItem = PayPalItem(name: "Total Price", withQuantity: 1, withPrice: NSDecimalNumber(string: price), withCurrency: "USD", withSku: "despot-1")
        
        let items = [paypalItem]
        let subtotal = PayPalItem.totalPrice(forItems: items)
        
        let shipping = NSDecimalNumber(string: "5.99")
        let tax = NSDecimalNumber(string: "2.50")
        let shipping2 = NSDecimalNumber(decimal: 5.99)
        let tax2 = NSDecimalNumber(decimal: 2.50)
        let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping2, withTax: tax2)
        
        
        
        let total = subtotal.adding(shipping).adding(tax)
        
        payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: "Custom Wedding Dress", intent: .sale)
        
        payment.items = items
        payment.paymentDetails = paymentDetails
        print(payment.description)
        
        if (payment.processable) {
            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            present(paymentViewController!, animated: true, completion: nil)
        }
        else {
            print("Payment not processalbe: \(payment)")
        }
    }
    
    @IBAction func done(_ sender: Any) {
        reviewSummary()
    }
    
    func orderUpdate() {
        dataRef.child("Customers").child("Orders").observe(.value, with: {(snapshot) in
            if snapshot.childrenCount > 0 {
                self.customerOrders.removeAll()
                for order in snapshot.children.allObjects as! [DataSnapshot] {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: order.value as Any, options: .prettyPrinted)
                        let decoder = JSONDecoder()
                        var customerOrder = try decoder.decode(OrderForCustomer.self, from: data)
                        customerOrder.id = order.key
                        print(self.customerOrders.description)
                        self.customerOrders.append(customerOrder)
                    } catch let error {
                        print(error)
                    }
                }
                
                let filteredOrders = self.customerOrders.filter({ (order) -> Bool in
                    order.userid == Auth.auth().currentUser?.uid
                })
                
                if filteredOrders.count > 0 {
                    self.desiredOrder = filteredOrders.first
                }
                
                print(filteredOrders.description)
            }
            
        })
    }
    
    func reviewSummary(){
        
        if (txtView.text.count>0){
            
            guard let userId = loggedUser?.uid else{
                self.navigationController?.popViewController(animated: true)
                return
            }
            
            print(userId)
            dataRef.child("Customers").child(userId).observe(.value, with: {(snapshot) in
                let values = snapshot.value as? NSDictionary
                
                if let profileImage = values!["profilePic"] as? String{
                    self.irlPhoto = profileImage
                }
                
                if let userName = values!["username"] as? String{
                    self.name = userName
                }
                
                
                let dateFormattor = DateFormatter()
                dateFormattor.dateStyle = .medium
                let date = dateFormattor.string(from: Date())
                
                let ratingupdate = ["message" : self.txtView.text,"username": self.name ?? "","timestamp":date,"customerId":userId,"rating":Int(self.reviewView.rating.rounded()),"tailorId":self.desiredSummary.userId ?? "","photoImage": self.irlPhoto ?? ""] as [String :Any]
                
         self.dataRef.child("Customers").child("Reviews").childByAutoId().updateChildValues(ratingupdate, withCompletionBlock: { (error, reference) in
                    if error == nil && self.desiredOrder != nil{
                        let updatedOrder = ["isJobConfirmed" : true] as [String : Any]
                        
                        self.dataRef.child("Customers").child("Orders").child(self.desiredOrder?.id ?? "").updateChildValues(updatedOrder, withCompletionBlock: { (error, reference) in
                            if error == nil {
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmCustomer") as! ConfirmCustomer
                                vc.desiredConfirm = self.desiredSummary
                                
                                if self.navigationController != nil{
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }else{
                                    self.present(vc, animated: true, completion: nil)
                                }
                            } else {
                                Alert.showAlert(self, title: "Error", message: "Please enter payment, review, and rating before processing")
                            }
                        })
                    }
                })
            })
            
        }
    }
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        print("PayPal Payment Cancelled")
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        print("PayPal Payment Success !")
        paymentViewController.dismiss(animated: true, completion: { () -> Void in
            
            print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
            
        })
    }

}
