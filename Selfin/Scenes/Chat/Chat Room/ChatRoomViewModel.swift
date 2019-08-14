//
//  ChatRoomViewModel.swift
//  Selfin
//
//  Created by cis on 26/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation
import UIKit


final class ChatRoomViewModel {
    let task = SelfinTask()
    func sendNotification(message:String, receiverUsername : String) {
        task.sendChatNotification(param: SelfinTaskParam.cahtNotification(message:message , receiver_username:receiverUsername))
            .done  {
                print($0)
            }
            .catch {
                print(String(describing: $0))
        }
    }
    
    weak var delegate : ChatRoomViewDelegate?
    func function_LoadData(pageingID: String, ChatId: String) {
        HSFireBase.sharedInstance.function_LoadConversetion(pageingID: pageingID, chatID: ChatId) { bubble, _ in
         self.delegate?.didRecieveMessage(user: bubble)
        }
    }
    
    func sendTextMessage(messageDetail : messageStructure, textMessage : String) {
        HSFireBase.sharedInstance.function_SendTextMessage(msg: textMessage, senderName: messageDetail.senderName, reciverName: messageDetail.receiverName, senderID: messageDetail.senderId, reciverID: messageDetail.receiverId, currentChatID: messageDetail.chatId, reciverImage:messageDetail.receiverImage, Success: {
            self.delegate?.mediaMessageSentSuccess()
            self.sendNotification(message: textMessage, receiverUsername: messageDetail.receiverName)
        }) { (err) in
            self.delegate?.didReceived(error: err)
        }
    }

    func sendMediaMessage(messageDetail : messageStructure, image : UIImage ) {
        HSFireBase.sharedInstance.function_SendImage(image: image, senderName: messageDetail.senderName, reciverName: messageDetail.receiverName, senderID: messageDetail.senderId, reciverID: messageDetail.receiverId, currentChatID: messageDetail.chatId, reciverImage: messageDetail.receiverImage, Success: {
            self.delegate?.mediaMessageSentSuccess()
            self.sendNotification(message: "image", receiverUsername: messageDetail.receiverName)
        }) { (err) in
            self.delegate?.didReceived(error: err)
        }
    }
    
    func sendVideoMessage(videoURL : URL , messageDetail : messageStructure)  {
        
        HSFireBase.sharedInstance.function_SendVideo(video: videoURL, senderName: messageDetail.senderName, reciverName: messageDetail.receiverName, senderID: messageDetail.senderId, reciverID: messageDetail.receiverId, currentChatID: messageDetail.chatId, reciverImage: messageDetail.receiverImage, Success: {
            self.delegate?.mediaMessageSentSuccess()
            self.sendNotification(message: "video", receiverUsername: messageDetail.receiverName)
        }) { (err) in
            self.delegate?.didReceived(error: err)
        }
    }
    
    
    //MARK:- Custome methods
    func sendMessage(type : MessageType, senderDetail: HSChatUsers, textMessage: String?, image : UIImage?, video : URL?, lastMessage : String){
        
        let currentusername: String = UserStore.user?.userName ?? ""
        let currentuserid: Int = UserStore.user?.id ?? 0
        
        var chatID : String = ""
        if lastMessage != "" {
            chatID = lastMessage
        } else {
            chatID = ""
        }
        
        let details = messageStructure.init(senderName: currentusername, receiverName: senderDetail.name, senderId: currentuserid, receiverId: senderDetail.id, chatId: chatID, receiverImage: senderDetail.image)
        
        switch type {
        case .image :
            sendMediaMessage(messageDetail: details, image: image ?? UIImage())
        case .video:
            sendVideoMessage(videoURL: video!, messageDetail: details)
        case .text:
            sendTextMessage(messageDetail: details, textMessage: textMessage ?? "")
        default:break
        }
    }
    
    func showUserImageAtTop(_ imageView : UIImageView) -> UIBarButtonItem {
        imageView.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.layer.cornerRadius = imageView.frame.size.height/2
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        let imageItem = UIBarButtonItem.init(customView: imageView)
        return imageItem
    }
}
