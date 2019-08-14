

//  PostDetailsViewModel.swift
//  Selfin
//
//  Created by cis on 18/09/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

final class PostDetailsViewModel {
    
	weak var controller:PostDetailController?
	let postDetailTask = PostTask()
    let userTask = UserTask(username: "")
	
    func fetchPostDetails(id:Int) {
        postDetailTask.details(id: id)
            .done{self.controller?.viewModalActions(action: .post(data: $0))}
            .catch{ self.controller?.viewModalActions(action: .error(msg: String(describing: $0)))}
    }
	
    func callFollowUnfollowUserAPI(username: String) {
        userTask.followUnfollow(with: UserTaskParams.FollowUnfollowRequest(username:username))
            .done { self.controller?.viewModalActions(action: .followUnFollow(data: $0)) }
            .catch { self.controller?.viewModalActions(action: .error(msg: String(describing: $0)))}
    }

    func performLike(action:String, postId: Int) {
        postDetailTask.like(id: postId, params:PostTaskParams.Like(action:action))
            .done{self.controller?.viewModalActions(action: .like(data: $0))}
            .catch{ self.controller?.viewModalActions(action: .error(msg: String(describing: $0)))}
    }
	
	func report(postID:Int) {
        postDetailTask.report(id: postID, type: "")
            .done{self.controller?.viewModalActions(action: .report(data: $0))}
            .catch{ self.controller?.viewModalActions(action: .error(msg: String(describing: $0)))}
	}
    
	func copyLink(postID:Int) {
		postDetailTask.copyLink(id: postID)
            .done{self.controller?.viewModalActions(action: .copyLink(data: $0))}
            .catch{ self.controller?.viewModalActions(action: .error(msg: String(describing: $0)))}

	}
    
    func turnNotifications (id :Int) {
        postDetailTask.handleNotoficationForPost(id: id)
            .done {self.controller?.viewModalActions(action: .notification(data: $0))}
            .catch {self.controller?.viewModalActions(action: .error(msg: String(describing: $0)))}
    }
    
    func createChatUser(user : PostDetailResponse.User) -> HSChatUsers {
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
