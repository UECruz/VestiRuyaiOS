//
//  LoginController.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 1/14/19.
//  Copyright © 2019 Ursula Cruz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD

class LoginController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var LoginBtm: UIImageView!

    

    static var isTailor = true
    var isTailorSelected = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        emailText.delegate = self
        passwordText.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginController.tappedIt))
        LoginBtm.addGestureRecognizer(tap)
        LoginBtm.isUserInteractionEnabled = true

    }
    
    @IBAction func forgotBTM(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: (emailText.text)!) { (error) in
            if error == nil {
                print("Passowrd resent email sent successfully")
                Alert.showAlert(self, title: "Reset Password", message: "Passowrd resent email sent successfully")
            } else {
                print("We have error sending email for password reset")
                Alert.showAlert(self, title: "Error", message: "We have error sending email for password reset. Please enter email")
            }
        }
    }
    
    @objc func tappedIt()
    {
        Login()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailText.resignFirstResponder()
        passwordText.resignFirstResponder()
        return true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CustomerHome"{
            
            _ = segue.destination as? CustomerHome
        }else if segue.identifier == "TailorHome"{
            _ = segue.destination as? TailorHome
        }
    }
    func Login(){
        let ref = Database.database().reference()
        let email = emailText.text
        let password = passwordText.text
        
        if((email?.isEmpty)! && (password?.isEmpty)!){
            Alert.showAlert(self, title: "Error", message: "Please fill in the box")
        }else{
            Auth.auth().signIn(withEmail: email!, password: password!, completion: {(user,error) in
                ref.child("Customers").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if snapshot.childrenCount > 0{
                        for child in snapshot.children{
                            let snap = child as! DataSnapshot
                            let key = snap.key
                            
                            print("key == \(key)")
                            if key == Auth.auth().currentUser?.uid{
                                LoginController.isTailor = false
                                self.performSegue(withIdentifier: "CustomerHome", sender: nil)
                                break
                            }
                            
                        }
                        return
                    }
                    
                    
                })
                
                ref.child("Tailors").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if snapshot.childrenCount > 0{
                        for child in snapshot.children{
                            let snap = child as! DataSnapshot
                            let key = snap.key
                            
                            print("key == \(key)")
                            if key == Auth.auth().currentUser?.uid{
                                LoginController.isTailor = true
                                self.performSegue(withIdentifier: "TailorHome", sender: nil)
                                break
                            }

                        }
                        return
                    }
                    
                    
                   
                })
                
                if let error = error {
                    if let errCode = AuthErrorCode(rawValue: error._code) {
                        switch errCode {
                        case .userNotFound:
                            Alert.showAlert(self, title: "Error", message: "User account not found. Try registering")
                        case .wrongPassword:
                            Alert.showAlert(self, title: "Error", message: "Incorrect username/password combination")
                        default:
                            Alert.showAlert(self, title: "Error", message: error.localizedDescription)
                        }
                    }
                }
              
            })
        }
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
