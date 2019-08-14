//
//  ChatListViewModel.swift
//  Selfin
//
//  Created by cis on 24/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation


final class ChatListViewModel {
    weak var delegate:ChatListDelegate?
    
    func function_LoadData() {
        HSFireBase.sharedInstance.function_LoadChat(logedInUserID: UserStore.user?.id ?? 0, success: { user in
            self.delegate?.didReceivedChatUser(result: user)
        }) {
            self.delegate?.didReceived(error: "")
        }
    }

    private let task = SearchTask()
    func performSearchUser(strSearch:String, page : Int)  {
        task.SearchDiscoverTask(searchType: SearchRequestURL.searchStyle.user, searchStr: strSearch, page : page)
            .done  {self.delegate?.didReceivedResult(result: $0) }
            .catch { self.delegate?.didReceived(error: String(describing: $0)) }
    }
    
    func createChatUser(user : FollowingFollowersResponse.User) -> HSChatUsers {
        let currentuser : Int = UserStore.user?.id ?? 0
        var chatID = ""
        if currentuser > user.id {
            chatID = "\(currentuser)_\(user.id)"
        } else {
            chatID = "\(user.id)_\(currentuser)"
        }
        let chatUser = HSChatUsers()
        chatUser.name = user.username
        chatUser.chatID = "\(chatID)"
        chatUser.lastMessage = ""
        chatUser.time = 0
        chatUser.id = user.id
        let image = environment.host + user.profileImage
        chatUser.image = image
        return chatUser
    }
}
