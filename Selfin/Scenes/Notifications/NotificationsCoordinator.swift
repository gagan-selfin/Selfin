//
//  NotificationsCoordinator.swift
//  Selfin
//
//  Created by Marlon Monroy on 6/30/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit
class NotificationsCooridinator: Coordinator<AppDeepLink> {
    weak var navigator: Navigator?

    lazy var notificationViewController: NotificationsViewController = {
        let controller: NotificationsViewController = NotificationsViewController.from(from: .notifications, with: .notifications)
        controller.delegate = self
        return controller
    }()

    override init(router: Router) {
        super.init(router: router)
        router.setRootModule(notificationViewController, hideBar: true)
    }
}

extension NotificationsCooridinator: NotificationCoordinatorDelegate {
    func showPostDetails(postId: Int) {
        let post = PostDetailsCoordinator(router: self.router as! Router)
        post.start(with: postId)
        navigator?.hidesCamera(hides: true)
        add(post)
        self.router.push(post, animated: true, completion: {[weak self] in
            self?.navigator?.hidesCamera(hides:false)
        })
    }
    
    func showProfile(username: String) {
        let profile = ProfileCoordinator(router: self.router as! Router)
        profile.start(with: .profile, username: username, nav : navigator)
        navigator?.hidesCamera(hides: true)
        add(profile)
    }
}
