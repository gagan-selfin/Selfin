//
//  chatAction.swift
//  Selfin
//
//  Created by cis on 23/11/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

protocol ChatListDelegate :class {
    func didReceivedResult(result:FollowingFollowersResponse)
    func didReceivedChatUser(result:HSChatUsers)
    func didReceived(error msg : String)
}

protocol MoveToChatDelegate :class {
    func didMoveUsersChat(user : HSChatUsers)
    func didMoveToUserProfile(username: String)
}

protocol ChatRoomViewDelegate: class {
    func didRecieveMessage(user : HSBubble)
    func didReceived(error msg : String)
    func mediaMessageSentSuccess()
}

struct messageStructure : Codable {
    let senderName : String
    let receiverName : String
    let senderId : Int
    let receiverId : Int
    let chatId : String
    let receiverImage : String
}

enum MessageType : String {
    case video = "VIDEO"
    case image = "Gallery"
    case camera = "Camera"
    case text
}

protocol ChatRoomTableViewCellDelegate : class {
    func didPerformOperationOnMediaMessage(type : MessageType , mediaPath : String)
}

protocol ChatRoomOpenMediaDelegate : class {
    func openMediaFiles(type : MessageType , mediaPath : String)
}

enum chatRoomIdentifiers : String {
    case sentMessages
    case receivedMessages
    case receivedMedia
    case sentMedia
}

protocol openSelfInCamera : class {
    func openCamera()
    func didMoveToProfile(username : String)
}

protocol chatListTableViewDelegate : class {
    func didSelectfromSearch(user: FollowingFollowersResponse.User)
    func didSelect(user: HSChatUsers)
    func didMoveToProfile(username : String)
}
