//
//  FeedsCoordinator.swift
//  Selfin
//
//  Created by Marlon Monroy on 6/30/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

class FeedsCoodinator: Coordinator<AppDeepLink> {
    weak var navigator: Navigator?

    lazy var homeFeeds: HomeFeedViewController = {
        let controller: HomeFeedViewController = HomeFeedViewController.from(from: .feeds, with: .homefeed)
        return controller
    }()
    
    var chat : ChatCoordinator!

    override init(router: Router) {
        super.init(router: router)
        homeFeeds.delegate = self
    }
    
    func start(type:AppDeepLink, deeplink:deepLinkValues){
        if type == .root {
            router.setRootModule(homeFeeds, hideBar: false)
        }else {
            switch deeplink {
            case .post(id: let id):
                showPostDetail(id: id, isAnimate: false)
            case .profile(username: let username):
                showProfile(username: username)
            default:break
            }
        }
    }
}

extension FeedsCoodinator: HomeFeedViewControllerDelegate {
	func feedControllerActions(action: FeedControllerActions) {
		switch action {
        case .showChatRoom(user: let user):
            moveToChatScreen(user: user)
		case .showPostActionSheet: break
		case let .showPostDetail(id,isAnimate):
            showPostDetail(id: id, isAnimate: isAnimate)
		case .showProfile(let username):
			showProfile(username: username)
		case .showChat:
            //moveToSubSelfinAccount()
            chat = ChatCoordinator(router: router as! Router)
            navigator?.hidesCamera(hides:true)
            self.router.push(chat, animated: true, completion: {[weak self] in
                self?.navigator?.hidesCamera(hides:false)
            })
        case .showLocation(let location):
            showUsersPosts(string: location, type: .location)
		}
	}
    
    func moveToSubSelfinAccount(){
        let chat = testImageCoordinator(router: router as! Router)
        navigator?.hidesCamera(hides: true)
        chat.start()
    }
    
    func showUsersPosts(string : String, type : postType) {
        let post = UsersPostCoordinator(router: self.router as! Router)
        navigator?.hidesCamera(hides:true)
        //post.start(username: "", hashtag: hashtag, location: location)
        post.start(string: string, type: type)
        self.router.push(post, animated: true) {[weak self] in
            self?.navigator?.hidesCamera(hides:false)
            self?.remove(child: post)
        }
        add(post)
    }
	
    func moveToChatScreen(user: HSChatUsers) {
        chat = ChatCoordinator(router: router as! Router)
        chat.type = .room
        navigator?.hidesCamera(hides: true)
        chat.start(with: .room, user: user, nav:navigator)
    }

    func showPostDetail(id:Int, isAnimate:Bool) {
        let post = PostDetailsCoordinator(router: self.router as! Router)
        post.start(with: id)
        navigator?.hidesCamera(hides: true)
        add(post)
        self.router.push(post, animated: isAnimate, completion: {[weak self] in
            self?.navigator?.hidesCamera(hides:false)
        })
	}
    
    func showProfile(username : String) {
        let profile = ProfileCoordinator(router: self.router as! Router)
        navigator?.hidesCamera(hides: true)
        profile.start(with: .profile, username: username, nav: navigator)
        add(profile)
	}
}
