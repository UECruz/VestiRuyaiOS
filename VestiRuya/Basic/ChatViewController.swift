//
//  ChatViewController.swift
//  VestiRuya
//
//  Created by Ursula Cruz on 11/8/18.
//  Copyright © 2018 Ursula Cruz. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase
import Kingfisher

class ChatViewController: JSQMessagesViewController {

    var otherId: String!
    var roomRef: DatabaseReference!
    var otherImage: UIImage?
    var currentUserImage: UIImage?
    
    let dateFormatter = DateFormatter()
    
    
    var outgoingBubbleImageData: JSQMessagesBubbleImage!
    var incomingBubbleImageData: JSQMessagesBubbleImage!
    
    
    var messages: [JSQMessageData] = []
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        self.outgoingBubbleImageData = bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.blue)
        
        self.incomingBubbleImageData = bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.lightGray)
        self.senderDisplayName = "Me"
        
        dateFormatter.dateFormat = "yyyyMMdd-HH:mm:ss.SSS"
    }

    func setup(myId: String, otherId: String, currentUserImage: UIImage?, otherImage: UIImage?, senderName:String) -> Void {
        let ref = Database.database().reference()
        var roomId: String!

        if LoginController.isTailor{
            roomId = "\(myId)\(otherId)"
        }else{
            roomId = "\(otherId)\(myId)"
        }
        self.senderDisplayName = senderName
        self.senderId = myId
        self.otherId = otherId
        self.otherImage = otherImage
        self.currentUserImage = currentUserImage
        
        roomRef = ref.child("Chats").child(roomId)

        func add(rawMessage: [String:  AnyObject]) {
            let date = dateFormatter.date(from: rawMessage["timestamp"]! as! String)
            let isContainsMessage = self.messages.reduce(false) { (prevResult, message) -> Bool in
                if prevResult == true {
                    return true
                }
                return message.date().timeIntervalSince1970 == date?.timeIntervalSince1970
            }
            guard isContainsMessage == false else { return }
            
            print("senderName:\(senderName)")
            let jsqMsg = JSQMessage(senderId: rawMessage["sender"]! as? String, senderDisplayName: rawMessage["senderName"]! as? String, date: date, text: rawMessage["message"]! as? String)!
            self.messages.append(jsqMsg)
        }
        roomRef.observe(DataEventType.childAdded, with: { (snapshot) in
            let msg = snapshot.value as! [String:  AnyObject]
            add(rawMessage: msg)
            self.collectionView.reloadData()
        })
        roomRef.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            let messageObjects = snapshot.value as? [String : AnyObject] ?? [:]
            var messageArray = [[String:Any]]()
            for (_, value) in messageObjects {
                guard let obj = value as? [String:Any] else { continue }
                messageArray.append(obj)
            }
            messageArray.sort(by: { (first, second) -> Bool in
                let firstDate = first["timestamp"]! as! String
                let secondDate = second["timestamp"]! as! String

                return firstDate < secondDate
            })
            messageArray.forEach({ (msg) in
                add(rawMessage: msg as [String : AnyObject])
            })
            self.collectionView.reloadData()
        })
    }
    
 
   
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 40.0
    }
    func isMyMessage(_ indexPath: IndexPath) -> Bool {
        let msg = messages[indexPath.row]
        print(senderId)
        
        return msg.senderId() == senderId
    }
    
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        let date = dateFormatter.string(from: date)
        roomRef.childByAutoId().setValue(["timestamp": date,
                                          "message": text,
                                          "sender": senderId,
                                          "senderName":self.senderDisplayName as NSString], withCompletionBlock: { (error, reference) in
                                            
                                            
                                            self.finishSendingMessage(animated: true)
        })
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        
        
        return incomingBubbleImageData
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.row]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        if isMyMessage(indexPath) {
            return JSQMessagesAvatarImage(placeholder: currentUserImage)
            
        } else {
            return JSQMessagesAvatarImage(placeholder: otherImage)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        if self.isMyMessage(indexPath) {
            cell.textView.textColor = UIColor.black
        } else {
            cell.textView.textColor = UIColor.white
        }
        
             cell.messageBubbleTopLabel.text = messages[indexPath.row].senderDisplayName()
       
       
        cell.messageBubbleTopLabel.textColor = UIColor.black
        return cell;
    }
}
