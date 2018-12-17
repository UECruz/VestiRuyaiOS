//
//  ChatContainerViewController.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 11/8/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class ChatContainerViewController: UIViewController {

    @IBOutlet weak var navi: UINavigationBar!
    @IBOutlet weak var containerView: UIView!
    
       var ref: DatabaseReference!
    
    var chatViewController: ChatViewController!
    override func viewDidLoad() {
        super.viewDidLoad()

        navi.topItem?.title = "Chatroom"
        
       
        chatViewController = ChatViewController()
        self.containerView.addSubview(chatViewController.view)
        self.chatViewController.view.frame = self.containerView.bounds
        chatViewController.view.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        self.addChildViewController(chatViewController)
    }
    
    func setup(myId: String, otherId: String, currentUserImage: UIImage?, otherImage: UIImage?, loggedinUserName:String) -> Void {
        
       
        
    
            self.chatViewController.setup(myId: myId,
                                          otherId: otherId,
                                          currentUserImage: currentUserImage,
                                          otherImage: otherImage,senderName: loggedinUserName)
            
       
    }
    
    @IBAction func backBtm(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
