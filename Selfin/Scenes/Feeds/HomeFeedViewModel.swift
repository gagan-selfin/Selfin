//
//  HomeFeedViewModel.swift
//  Selfin
//
//  Created by Marlon Monroy on 11/6/18.
//  Copyright © 2018 Selfin. All rights reserved.
//
import Foundation

final class HomeFeedViewModel {
    let task = FeedsTask()
    let postDetailTask = PostTask()
    var feeds: [HomeFeed.Post] = []
    weak var controller: HomeFeedController?
    func fetchFeeds(page: Int) {
        task.feed(page: page)
            .done {self.controller?.didReceived(responseType: FeedAPIResponse.feed(feed: $0.post, page: page))}
        .catch { self.controller?.didReceived(responseType: FeedAPIResponse.error(error: String(describing: $0))) }
    }
    
    func report(postID:Int, type : ReportType) {
        postDetailTask.report(id: postID, type: type.rawValue.lowercased())
            .done{self.controller?.didReceived(responseType: FeedAPIResponse.report(data: $0))}
            .catch{ self.controller?.didReceived(responseType: FeedAPIResponse.error(error: String(describing: $0)))}
    }
    
    func copyLink(postID:Int) {
        postDetailTask.copyLink(id: postID)
            .done{self.controller?.didReceived(responseType: FeedAPIResponse.copyLink(data: $0))}
            .catch{ self.controller?.didReceived(responseType: FeedAPIResponse.error(error: String(describing: $0))) }
    }
    
    func createChatUser(user : HomeFeed.Post.User) -> HSChatUsers {
        let currentuser : Int = UserStore.user?.id ?? 0
        var chatID = ""
        if currentuser > user.user_id {
            chatID = "\(currentuser)_\(user.user_id)"
        } else {
            chatID = "\(user.user_id)_\(currentuser)"
        }
        let chatUser = HSChatUsers()
        chatUser.name = user.username
        chatUser.chatID = "\(chatID)"
        chatUser.lastMessage = ""
        chatUser.time = 0
        chatUser.id = user.user_id
        let image = environment.host + user.profile_image
        chatUser.image = image
        return chatUser
    }
    
    func deleteUPost(id : Int) {
        postDetailTask.delete(id: id)
            .done {_ in self.controller?.didReceived(responseType: .delete(id: id))}
            .catch { self.controller?.didReceived(responseType: FeedAPIResponse.error(error: String(describing: $0))) }
    }
    
    func turnOnOffNotification(id : Int) {
        postDetailTask.handleNotoficationForPost(id: id)
            .done {self.controller?.didReceived(responseType: .notification(data: $0))}
            .catch {self.controller?.didReceived(responseType: FeedAPIResponse.error(error: String(describing: $0)))}
    }
}
