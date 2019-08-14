//
//  HSFireBase.swift
//  Blast
//
//  Created by cis on 02/08/18.
//  Copyright © 2018 cis. All rights reserved.
//

import AVKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import Foundation

// MARK: Database
class HSFireBase: NSObject {
    // Singleton Instance
    static let sharedInstance: HSFireBase = {
        let instance = HSFireBase()
        // setup code
        return instance
    }()

    func function_CreatAndUpdateUser(id: String, name: String, email: String, picture: String) {
        let user: [String: String] = [
            "email": "\(email)",
            "name": "\(name)",
            "picture": "\(picture)",
        ]
        Database.database().reference().child("users").child("\(id)").child("credentials").setValue(user) { error, _ in
            if let _ = error {
                self.function_CreatAndUpdateUser(id: id, name: name, email: email, picture: picture)
            }
        }
    }

    func function_DeleteUser(id: String) {
        Database.database().reference().child("users").child("\(id)").child("credentials").removeValue { error, _ in
            if let _ = error {
                self.function_DeleteUser(id: id)
            }
        }
    }

    func function_CreteChatID(userID_First: Int, userID_Second: Int) {
        var chatID = ""
        if userID_First > userID_Second {
            chatID = "\(userID_First)_\(userID_Second)"
        } else {
            chatID = "\(userID_Second)_\(userID_First)"
        }
        Database.database().reference().child("conversations").child("\(chatID)")
    }

    func function_SendTextMessage(msg: String, senderName: String, reciverName: String, senderID: Int, reciverID: Int, currentChatID: String, reciverImage: String, Success: @escaping () -> Void, Error: @escaping (String) -> Void) {
        var chatID : String = ""
        if currentChatID == "" {
            if senderID > reciverID {
                chatID = "\(senderID)_\(reciverID)"
            } else {
                chatID = "\(reciverID)_\(senderID)"
            }
        } else {
            chatID = currentChatID
        }
        
        let time = Date().timeIntervalSince1970
        let tempKey = "\(Database.database().reference().childByAutoId().key ?? "")"
        let message: [String: Any] = [
            "message": "\(msg)",
            "type": "text",
            "time": time,
            "name": "\(senderName)",
            "id": senderID,
            "chatID": "\(chatID)",
            "msgID": "\(tempKey)",
        ]
        Database.database().reference().child("chat").child("\(chatID)").child("\(tempKey)").setValue(message) { error, _ in
            if let isError = error {
                Error(isError.localizedDescription)
            } else {
                if currentChatID == "" {
                    for i in 0 ... 1 {
                        if i == 0 {
                            let user: [String: [String: Any]] = [
                                "detail": ["name": "\(reciverName)",
                                           "id": reciverID,
                                           "chatID": chatID, "reciverImage": "\(reciverImage)"],
                                "message": ["lastMessage": "\(msg):\(time)", "time": time],
                            ]
                            Database.database().reference().child("users").child("\(senderID)").child("chat").child("\(reciverID)").setValue(user)
                        } else {
                            let user: [String: [String: Any]] = [
                                "detail": ["name": "\(senderName)",
                                    "id": senderID,
                                    "chatID": chatID, "image": UserStore.user?.profileImage ?? ""],
                                "message": ["lastMessage": "\(msg):\(time)", "time": time],
                            ]
                            Database.database().reference().child("users").child("\(reciverID)").child("chat").child("\(senderID)").setValue(user)
                        }
                    }
                    Success()
                } else {
                    for i in 0 ... 1 {
                        if i == 0 {
                            let user: [String: Any] = ["lastMessage": "\(msg):\(time)", "time": time]
                            Database.database().reference().child("users").child("\(senderID)").child("chat").child("\(reciverID)").child("message").updateChildValues(user)
                        } else {
                            let user: [String: Any] = ["lastMessage": "\(msg):\(time)", "time": time]
                            Database.database().reference().child("users").child("\(reciverID)").child("chat").child("\(senderID)").child("message").updateChildValues(user)
                        }
                    }
                    Success()
                }
            }
        }
    }

    func function_SendImage(image: UIImage, senderName: String, reciverName: String, senderID: Int, reciverID: Int, currentChatID: String, reciverImage: String, Success: @escaping () -> Void, Error: @escaping (String) -> Void) {
        if let isData = image.jpegData(compressionQuality: 1.0) {
            let imgName = "\(Date().timeIntervalSince1970 * 1000).jpeg"
            let SDreference = Storage.storage().reference().child("images").child("\(imgName)")
            SDreference.putData(isData, metadata: nil) { _, uploadError in
                if let isUploadError = uploadError {
                    Error(isUploadError.localizedDescription)
                } else {
                    SDreference.downloadURL { url, linkError in
                        if let isLinkError = linkError {
                            Error(isLinkError.localizedDescription)
                        } else {
                            var chatID = ""
                            if currentChatID == "" {
                                if senderID > reciverID {
                                    chatID = "\(senderID)_\(reciverID)"
                                } else {
                                    chatID = "\(reciverID)_\(senderID)"
                                }
                            } else {
                                chatID = currentChatID
                            }
                            let time = Date().timeIntervalSince1970
                            let tempKey = "\(Database.database().reference().childByAutoId().key ?? "")"
                            let message: [String: Any] = [
                                "message": "\(url?.absoluteString ?? "")",
                                "type": "image",
                                "time": time,
                                "name": "\(senderName)",
                                "id": senderID,
                                "chatID": "\(chatID)",
                                "msgID": "\(tempKey)",
                            ]
                            Database.database().reference().child("chat").child("\(chatID)").child("\(tempKey)").setValue(message) { error, _ in
                                if let isError = error {
                                    Error(isError.localizedDescription)
                                } else {
                                    if currentChatID == "" {
                                        for i in 0 ... 1 {
                                            if i == 0 {
                                                let user: [String: [String: Any]] = [
                                                    "detail": ["name": "\(reciverName)",
                                                               "id": reciverID,
                                                               "chatID": chatID, "reciverImage": "\(reciverImage)"],
                                                    "message": ["lastMessage": "Image\(time)", "time": time],
                                                ]
                                                Database.database().reference().child("users").child("\(senderID)").child("chat").child("\(reciverID)").setValue(user)
                                            } else {
                                                let user: [String: [String: Any]] = [
                                                    "detail": ["name": "\(senderName)",
                                                               "id": senderID,
                                                               "chatID": chatID, "image": UserStore.user?.profileImage ?? ""],
                                                    "message": ["lastMessage": "Image:\(time)", "time": time],
                                                ]
                                                Database.database().reference().child("users").child("\(reciverID)").child("chat").child("\(senderID)").setValue(user)
                                            }
                                        }
                                        Success()
                                    } else {
                                        for i in 0 ... 1 {
                                            if i == 0 {
                                                let user: [String: Any] = ["lastMessage": "Image:\(time)", "time": time]
                                                Database.database().reference().child("users").child("\(senderID)").child("chat").child("\(reciverID)").child("message").updateChildValues(user)
                                            } else {
                                                let user: [String: Any] = ["lastMessage": "Image:\(time)", "time": time]
                                                Database.database().reference().child("users").child("\(reciverID)").child("chat").child("\(senderID)").child("message").updateChildValues(user)
                                            }
                                        }
                                        Success()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func function_SendVideo(video: URL, senderName: String, reciverName: String, senderID: Int, reciverID: Int, currentChatID: String, reciverImage: String, Success: @escaping () -> Void, Error: @escaping (String) -> Void) {
        let imgName = "\(Date().timeIntervalSince1970 * 1000).mov"
        let SDreference = Storage.storage().reference().child("videos").child("\(imgName)")
        SDreference.putFile(from: video, metadata: nil) { _, uploadError in
            if let isUploadError = uploadError {
                Error(isUploadError.localizedDescription)
            } else {
                SDreference.downloadURL { url, linkError in
                    if let isLinkError = linkError {
                        Error(isLinkError.localizedDescription)
                    } else {
                        var chatID = ""
                        if currentChatID == "" {
                            if senderID > reciverID {
                                chatID = "\(senderID)_\(reciverID)"
                            } else {
                                chatID = "\(reciverID)_\(senderID)"
                            }
                        } else {
                            chatID = currentChatID
                        }
                        let time = Date().timeIntervalSince1970
							let tempKey = "\(Database.database().reference().childByAutoId().key ?? "")"
                        let message: [String: Any] = [
                            "message": "\(url?.absoluteString ?? "")",
                            "type": "video",
                            "time": time,
                            "name": "\(senderName)",
                            "id": senderID,
                            "chatID": "\(chatID)",
                            "msgID": "\(tempKey)",
                        ]
                        Database.database().reference().child("chat").child("\(chatID)").child("\(tempKey)").setValue(message) { error, _ in
                            if let isError = error {
                                Error(isError.localizedDescription)
                            } else {
                                if currentChatID == "" {
                                    for i in 0 ... 1 {
                                        if i == 0 {
                                            let user: [String: [String: Any]] = [
                                                "detail": ["name": "\(reciverName)",
                                                           "id": reciverID,
                                                           "chatID": chatID, "reciverImage": "\(reciverImage)"],
                                                "message": ["lastMessage": "Video:\(time)", "time": time],
                                            ]
                                            Database.database().reference().child("users").child("\(senderID)").child("chat").child("\(reciverID)").setValue(user)
                                        } else {
                                            let user: [String: [String: Any]] = [
                                                "detail": ["name": "\(senderName)",
                                                           "id": senderID, "chatID": chatID, "image": UserStore.user?.profileImage ?? ""],
                                                "message": ["lastMessage": "Video:\(time)", "time": time],
                                            ]
                                            Database.database().reference().child("users").child("\(reciverID)").child("chat").child("\(senderID)").setValue(user)
                                        }
                                    }
                                    Success()
                                } else {
                                    for i in 0 ... 1 {
                                        if i == 0 {
                                            let user: [String: Any] = ["lastMessage": "Video:\(time)", "time": time]
                                            Database.database().reference().child("users").child("\(senderID)").child("chat").child("\(reciverID)").child("message").updateChildValues(user)
                                        } else {
                                            let user: [String: Any] = ["lastMessage": "Video:\(time)", "time": time]
                                            Database.database().reference().child("users").child("\(reciverID)").child("chat").child("\(senderID)").child("message").updateChildValues(user)
                                        }
                                    }
                                    Success()
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func function_LoadChat(logedInUserID: Int, success: @escaping (HSChatUsers) -> Void, error: @escaping () -> Void) {
        
        Database.database().reference().child("users").child("\(logedInUserID)").child("chat").observe(.childAdded) { dataSnap in

            if let isUser = dataSnap.value as? [String: [String: Any]] {
                let chatUser = HSChatUsers()
                
                if let isDetail = isUser["detail"] {
                    print(isDetail["reciverImage"] as? String ?? "")
                    
                    chatUser.name = isDetail["name"] as? String ?? ""
                    chatUser.chatID = isDetail["chatID"] as? String ?? ""
                    chatUser.id = isDetail["id"] as? Int ?? 0
                    chatUser.time = Int64(isUser["message"]?["time"] as? Double ?? 0.0)
                    chatUser.image = isDetail["reciverImage"] as? String ?? ""
                    let msg : String = isUser["message"]?["lastMessage"] as! String
                    chatUser.lastMessage = msg.components(separatedBy: ":")[0]
                    success(chatUser)
                }
            } else {
                error()
            }
        }
    }

    func function_GetLastMessage(logedInUserID: Int, Id: Int, message: @escaping (String, Double) -> Void) {
        Database.database().reference().child("users").child("\(logedInUserID)").child("chat").child("\(Id)").child("message").child("lastMessage").observe(.value) { data in
            if let isMessage = data.value as? String {
                let isData = isMessage.components(separatedBy: ":")
                message(isData.first ?? "", Double(isData.last ?? "0.0") ?? 0.0)
            }
        }
    }

    func function_LoadConversetion(pageingID _: String, chatID: String, success: @escaping (HSBubble, String) -> Void) {
        Database.database().reference().child("chat").child("\(chatID)").observe(.childAdded) { dataSnap in
            if let isUser = dataSnap.value as? [String: Any] {
                let msg = HSBubble()
                msg.message = isUser["message"] as? String ?? ""
                msg.type = isUser["type"] as? String ?? ""
                msg.time = Int64(isUser["time"] as? Double ?? 0.0)
                msg.name = isUser["name"] as? String ?? ""
                msg.chatID = isUser["chatID"] as? String ?? ""
                msg.msgID = isUser["msgID"] as? String ?? ""
                msg.id = isUser["id"] as? Int ?? 0
                success(msg, dataSnap.key)
            }
        }
    }
}

// MARK: Classes
class HSChatUsers {
    var name = ""
    var chatID = ""
    var lastMessage = ""
    var time: Int64 = 0
    var id = 0
    var image = ""
}

class HSChatInitiator {
    var reciverName = ""
    var reciverID = 0
    var currentChatID = ""
}

class HSBubble {
    var message = ""
    var type = ""
    var time: Int64 = 0
    var name = ""
    var chatID = ""
    var msgID = ""
    var id = 0
    var image = ""
}
