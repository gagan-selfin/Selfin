//
//  ProfileViewModel.swift
//  Selfin
//
//  Created by Marlon Monroy on 7/3/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

final class ProfileViewModel {
    var username = String()
    lazy var task = {
        return UserTask(username: self.username)
    }()
    private let postTask = PostTask()
    var post: [HomeFeed.Post] = []
    var postSelf: [SelfFeed.Post] = []
    var profile: Profile?
    var othersProfile : OthersProfile?
    var isOthersProfile = false
    weak var controller: UserProfileController?
    
    func getUsername(name : String)  {
        username = name
    }
    
    func OtherUserProfile(username: String) {
        isOthersProfile = true
        task.otherProfile(username: username)
            .done {
                self.othersProfile = $0.profile
                self.fetchPosts(page: 1)
            }
            .catch {
                self.controller?.didReceived(error: String(describing: $0.localizedDescription)) }
    }
    
    func fetchUser() {
        isOthersProfile = false
        task.profile()
            .done {
                self.profile = $0.profile
                self.fetchPosts(page: 1)
            }
            .catch { self.controller?.didReceived(error: String(describing: $0.localizedDescription)) }
    }
    
    func fetchPosts(page : Int) {
        task.posts(page: page, userName : username)
            .done {
                self.postSelf = $0.post
                self.appendProfile()
            }
            .catch {
                self.controller?.didReceived(error: String(describing: $0.localizedDescription))
        }
    }
    
    private func appendProfile() {
        var user:HomeFeed.Post.User!
        if isOthersProfile {
            user = getHomeFeedUser(profile: othersProfile)
            controller?.didReceived(profile: othersProfile!)
        }else {
            user = getHomeFeedUser(profile: self.profile)
            controller?.didReceived(profile: profile!)
        }
        post = postSelf.map {
            return getHomeFeed(for: $0, with: user)
        }
        controller?.didReceived(posts: post)
    }
    
    func fetchMentions(username : String, page : Int) {
        task.taggedPosts(page: page)
            .done { self.controller?.didReceived(data: $0.post , style: .mention)}
            .catch { self.controller?.didReceived(error: String(describing: $0)) }
    }
    
    func fetchLikes(username : String, page : Int) {
        task.likedPosts(page: page)
            .done { self.controller?.didReceived(data: $0.post, style: .heart)}
            .catch { self.controller?.didReceived(error: String(describing: $0)) }
    }
    
    func deleteUPost(id : Int, index : IndexPath) {
        postTask.delete(id: id)
            .done {_ in self.controller?.didReceiveSuccess(id: id, index: index)}
            .catch { self.controller?.didReceived(error: String(describing: $0)) }
    }
    
    func copyLink(postID:Int) {
        postTask.copyLink(id: postID)
            .done{self.controller?.didReceived(link: $0)}
            .catch{ self.controller?.didReceived(error: String(describing: $0.localizedDescription)) }
    }
    
    func turnOnOffNotification(id : Int) {
        postTask.handleNotoficationForPost(id: id)
            .done {self.controller?.didReceived(notificationstatus: $0) }
            .catch {self.controller?.didReceived(error: String(describing: $0.localizedDescription))}
    }
    
    func blockUnblock()  {
        task.blockUnblockUser(param: UserTaskParams.FollowUnfollowRequest(username : username))
        .done {self.controller?.didReceived(profile: $0)}
        .catch { self.controller?.didReceived(error: String(describing: $0)) }
    }
    
    private let profileTask = ProfileTask()
    func userProfileLink(username : String) {
        profileTask.userProfileLink(username: username)
            .done{self.controller?.didReceived(link: $0)}
            .catch{self.controller?.didReceived(error: String(describing: $0.localizedDescription))}
    }
    
    func getHomeFeed(for feed:SelfFeed.Post, with user:HomeFeed.Post.User) -> HomeFeed.Post {
        let fee : HomeFeed.Post = HomeFeed.Post(user:user,is_super_liked:feed.is_super_liked,scheduled_time:feed.scheduled_time,post_images:feed.post_images,id:feed.id,location_details:feed.location_details,is_liked:feed.is_liked,created_at:feed.created_at, is_notifying : false)
        return fee
    }
    
    func getHomeFeedUser(profile:Profile?) ->HomeFeed.Post.User {
        return HomeFeed.Post.User(profile_image: self.profile?.user.profileImage ?? "", following:self.profile?.user.following ?? false, username:self.profile?.user.userName ?? "",user_id:self.profile?.user.id ?? 0)
    }
    
    func getHomeFeedUser(profile:OthersProfile?) ->HomeFeed.Post.User {
        return HomeFeed.Post.User(profile_image: profile?.user.profileImage ?? "", following:profile?.user.following ?? false, username:profile?.user.userName ?? "",user_id:profile?.user.id ?? 0)
    }
    
    func createChatUser(user : OthersProfile.User) -> HSChatUsers {
        let currentuser : Int = UserStore.user?.id ?? 0
        var chatID = ""
        if currentuser > user.id {
            chatID = "\(currentuser)_\(user.id)"
        } else {
            chatID = "\(user.id)_\(currentuser)"
        }
        let chatUser = HSChatUsers()
        chatUser.name = user.userName
        chatUser.chatID = "\(chatID)"
        chatUser.lastMessage = ""
        chatUser.time = 0
        chatUser.id = user.id
        let image = environment.host + user.profileImage
        chatUser.image = image
        return chatUser
    }
}
