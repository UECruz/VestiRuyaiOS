//
//  CustomerLogin.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 10/2/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class CustomerLogin: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var SignUp: UIButton!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailText.delegate = self
        passwordText.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailText.resignFirstResponder()
        passwordText.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if Auth.auth().currentUser != nil{
//            Login()
//        }
    }
    
    @IBAction func login (sender: Any){
         TailorLogin.isTailor = false
        let email = emailText.text
        let password = passwordText.text
        
        if((email?.isEmpty)! && (password?.isEmpty)!){
            Alert.showAlert(self, title: "Error", message: "Please fill in the box")
        }else{
            Auth.auth().signIn(withEmail: email!, password: password!, completion: {(user,error) in
                guard let _ = user else {
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
                    return
                }
                self.Login()
            })
        }
    }
    
    func Login() {
        performSegue(withIdentifier: "loginSegue", sender: nil)
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
