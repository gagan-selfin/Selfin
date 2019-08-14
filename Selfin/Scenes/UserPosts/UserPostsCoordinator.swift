//
//  UserPostsCoordinator.swift
//  Selfin
//
//  Created by cis on 11/10/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

protocol UserPostsCoordinatorDelegate {
    func moveToPostDetailsScreen(id: Int)
}

class UserPostsCoordinator: Coordinator<AppDeepLink> {
    var username = String()
    var delegate: UserPostsCoordinatorDelegate?

    lazy var controller: UserPostsViewController = {
        let controller: UserPostsViewController = UserPostsViewController.from(from: .userPosts, with: .userPosts)
        controller.delegate = self
        return controller
    }()

    override init(router: Router) {
        super.init(router: router)
        // router.push(controller, animated: true, completion: nil)
    }

    override func start() {
        controller.username = username
        router.push(controller, animated: true, completion: nil)
    }

    func showPostDetails(id: Int) {
        let coordinator = PostDetailsCoordinator(router: router as! Router)
        coordinator.postId = id
        coordinator.isUserPosts = true
        coordinator.start()
        add(coordinator)
    }
}

extension UserPostsCoordinator: UserPostsViewControllerDelegate {
    func moveToPostDetailsFromUserPostScreen(id: Int) {
        showPostDetails(id: id)
    }

    func backToPreviousScreen() {
        router.popModule(animated: true)
        remove(child: self)
    }
}
