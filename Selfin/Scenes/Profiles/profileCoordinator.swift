//
//  profileCoordinator.swift
//  Selfin
//
//  Created by Marlon Monroy on 6/30/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

class ProfileCoordinator: Coordinator<AppDeepLink> {
	enum ScreenType {
		case userProfile
		case profile
	}
    
	var currentScreenType:ScreenType = .userProfile
    
    let profileViewController: UserProfileViewController = UserProfileViewController.from(from: .profile, with: .userProfile)
    
    let publicProfileViewController: ProfileViewController = ProfileViewController.from(from: .profile, with: .profile)
   
    override init(router: Router) {
        super.init(router: router)
    }
    
    weak var navigator:Navigator?

    func start(with screenType:ScreenType, username : String, nav : Navigator?) {
        if screenType == .userProfile {
        profileViewController.delegate = self
        router.setRootModule(profileViewController, hideBar: false)
            return
        }
        publicProfileViewController.controller = self
        publicProfileViewController.delegate = self
        publicProfileViewController.username = username
        router.push(publicProfileViewController, animated: true) {
            nav?.hidesCamera(hides: false)
            self.remove(child: self)
        }
    }
}

extension ProfileCoordinator : UserProfileDelegate {
    func profileFeedAction(action: UserProfileFeedAction) {
        switch action {
        case .showUserPostDetail(let id):
             showPost(id: id)
        case .showLocation(let string):
            showUsersPosts(username: string)
        }
    }
    
    func profileActions(action: ProfileAction, user : String) {
		switch action {
		case .showSettings:
			showSettingsScreen()
        case .showFollowers:
            showFollowerFollowingList(type: .showFollowers, username: user)
        case .showFollowing:
            showFollowerFollowingList(type: .showFollowing, username: user)
        case .showPost:
            showUsersPosts(username: user)
        case .showShedulePostList:
            showScheduleScreen()
        case .editProfile:
            showEditProfileScreen()
        case .blocked:
            //nav?.hidesCamera(hides: false)
            remove(child: self)
            router.popModule(animated: true)
        }
	}
    
    func showUsersPosts(username : String) {
        let post = UsersPostCoordinator(router: self.router as! Router)
        navigator?.hidesCamera(hides:true)
        //post.start(username: username, hashtag: "", location: "")
        post.start(string: username, type: .post)
        self.router.push(post, animated: true) {[weak self] in
            self?.navigator?.hidesCamera(hides:false)
            self?.remove(child: post)
        }
         add(post)
    }
    
    func showFollowerFollowingList(type: ProfileAction , username : String) {
        let followers = FollowersAndFollowingListCoordinator(router: self.router as! Router)
        
        switch type {
        case .showFollowers:
            followers.start(type: .follower , username: username)
        case .showFollowing:
            followers.start(type: .following , username: username)
        default:
            break
        }
        
        navigator?.hidesCamera(hides:true)
        add(followers)
        self.router.push(followers, animated: true) {[weak self] in
            self?.navigator?.hidesCamera(hides:false)
            self?.remove(child: followers)
        }
    }
    
    
    func showScheduleScreen() {
        let coordinator = SchedulePostListCoordinator(router: self.router as! Router)
        coordinator.start()
        add(coordinator)
        navigator?.hidesCamera(hides: true)
        self.router.push(coordinator, animated: false, completion:{[weak self] in
            self?.navigator?.hidesCamera(hides: false)
            self?.remove(child: coordinator)
        })
    }
    
    func showSettingsScreen() {
        let coordinator = SettingsCoordinator(router: self.router as! Router)
        coordinator.start()
        navigator?.hidesCamera(hides: true)
        add(coordinator)
        self.router.push(coordinator, animated: false, completion: {[weak self] in
            self?.navigator?.hidesCamera(hides:false)
            self?.remove(child: coordinator)
        })
    }
    
    func showPost(id:Int) {
        let post = PostDetailsCoordinator(router: self.router as! Router)
        post.start(with: id)
        navigator?.hidesCamera(hides: true)
        add(post)
        self.router.push(post, animated: true, completion: {[weak self] in
            self?.navigator?.hidesCamera(hides:false)
            self?.remove(child: post)
        })
    }
    
    func showEditProfileScreen() {
        let coordinator = EditProfileCoordinator(router: router as! Router)
        coordinator.start()
        navigator?.hidesCamera(hides: true)
        add(coordinator)
        self.router.push(coordinator, animated: false, completion: {[weak self, coordinator] in
            self?.navigator?.hidesCamera(hides:false)
            self?.remove(child: coordinator)
        })
    }
}

extension ProfileCoordinator : showUserChatRoom {
    func didMoveToChatScreen(user: HSChatUsers) {
       let chat = ChatCoordinator(router: router as! Router)
        chat.type = .room
        navigator?.hidesCamera(hides: true)
        chat.start(with: .room, user: user,  nav : navigator)
    }
  
}
