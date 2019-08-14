//
//  ChatListCoordinator.swift
//  Selfin
//
//  Created by cis on 24/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

enum ChatLink {
	case list
	case room
}

class ChatCoordinator: Coordinator<AppDeepLink> {
    var chatList: ChatListViewController = ChatListViewController.from(from: .chat, with: .chatList)
	var type :ChatLink = .list
    weak var navigator: Navigator?
    
    override init(router: Router) {
        super.init(router: router)
        chatList.delegate = self
    }
    
    func start(with type:ChatLink, user : HSChatUsers, nav:Navigator?) {
        switch type {
        case .list:
            print("0")
        case .room:
            let chatRoom:ChatRoomViewController =  ChatRoomViewController.from(from: .chat, with: .chatRoom)
            chatRoom.user = user
            chatRoom.delegate = self
            router.push(chatRoom, animated: true) {[weak self] in
                self?.type = .list
                nav?.hidesCamera(hides: false)
            }
        }
    }
    
    override func toPresentable() -> UIViewController {
         chatList.delegate = self
        return chatList
    }
    
    func showProfile(username : String) {
        let profile = ProfileCoordinator(router: self.router as! Router)
        profile.start(with: .profile, username: username, nav :navigator)
        add(profile)
    }
}

extension ChatCoordinator: MoveToChatDelegate {
    func didMoveUsersChat(user : HSChatUsers) {
        type = .room
        start(with: .room, user :user, nav : nil)
    }
    
    func didMoveToUserProfile(username: String){showProfile(username: username)}
}

extension ChatCoordinator: openSelfInCamera {
    func openCamera() {
        camereSelected()
    }
    
    func camereSelected() {
        let nav = selfinNavigationController()
        let cameraRouter = Router(navigationController: nav)
        let coordinator = CameraCoordinator(router: cameraRouter)
        coordinator.start(screenType: .chat)
        router.present(coordinator, animated: true)
    }
    
    func didMoveToProfile(username : String){showProfile(username: username)}
}
