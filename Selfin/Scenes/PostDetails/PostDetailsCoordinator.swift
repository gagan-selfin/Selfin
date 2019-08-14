//
//  PostDetailsCoordinator.swift
//  Selfin
//
//  Created by cis on 18/09/2018. Reworked by Marlon Monroy on 11/22/18
//  Copyright © 2018 Selfin. All rights reserved.
//
import UIKit

protocol PostDetailsCoordinatorDelegate {
    func popToMainViewController()
}

class PostDetailsCoordinator: Coordinator<AppDeepLink> {
    let controller: PostDetailsViewController = PostDetailsViewController.from(from: .postDetails, with: .postDetails)
    weak var navigator: Navigator?
    
    var postId = Int()
    var isUserPosts = false
    var indexpath = IndexPath()
    var user:PostDetailResponse.User?
    var chat : ChatCoordinator!
    
    var profile: ProfileCoordinator = {
        let nav = selfinNavigationController()
        let router = Router(navigationController: nav)
        let coordinator = ProfileCoordinator(router: router)
        return coordinator
    }()

    override init(router: Router) {
        super.init(router: router)
        controller.delegate = self
    }
	
	func start(with id:Int) {
        controller.postId = id
	}
	
    override func toPresentable() -> UIViewController {
        return controller
    }

    func showAddCommentsScreen() {
		let comments = CommentsCoordinator(router: self.router as! Router)
		comments.postId = controller.postId
		comments.start()
        add(comments)
		self.router.push(comments, animated: true, completion: {[weak self, comments] in
			self?.remove(child: comments)
		})
    }

    func showProfile(username : String) {
        let profile = ProfileCoordinator(router: self.router as! Router)
        profile.start(with: .profile, username: username, nav :navigator)
        navigator?.hidesCamera(hides: true)
        add(profile)
    }
    
    func showLikeListScreen() {
		let likes = LikesCoordinator(router: self.router as! Router)
        likes.postId = controller.postId
        likes.start()
        add(likes)
        self.router.push(likes, animated: true, completion: {[weak self, likes] in
            self?.remove(child: likes)
        })
    }
    
    func moveToChatScreen(user: HSChatUsers) {
        chat = ChatCoordinator(router: router as! Router)
        chat.type = .room
        chat.start(with: .room, user: user, nav : nil)
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
}

extension PostDetailsCoordinator: PostDetailsViewControllerDelegate {
    func postDetailActions(action: PostDetailAction) {
        switch action {
        case .previous:
            break
        case .comment:
            showAddCommentsScreen()
        case .like:
            showLikeListScreen()
        case .post:
            router.popModule(animated: true)
            remove(child: self)
        case .profile(let username):
           showProfile(username: username)
            
        case .action(let feedId, let user):
            if (feedId == nil) {
                moveToChatScreen(user: user)
            }
        case .report( _):
            break
        case .copyLink( _):
            break
        case .mention(let string):
           showProfile(username: string)
        case .hashtags(let string):
            showUsersPosts(string: string, type: .hashtags)
        case .location(location: let location):
            showUsersPosts(string: location, type: .location)
        }
    }
    
    func moveBackToChatList() {
        // remove(child: chatRoom)
        router.popModule(animated: true)
    }
    
    func copyLink(path:StaticPage) {
        
        if path.status {
            UIPasteboard.general.string = path.HTMLPath
            controller.displayReportStatus(msg: CopyLinkSuccess.copied.rawValue)
        }
    }
}
