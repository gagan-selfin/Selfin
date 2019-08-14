//
//  FollowersAndFollowingListCoordinator.swift
//  Selfin
//
//  Created by cis on 28/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

class FollowersAndFollowingListCoordinator: Coordinator<AppDeepLink> {
    weak var navigator: Navigator?

    let controller: FollowersAndFollowingListViewController = FollowersAndFollowingListViewController.from(from: .followerFollowing, with: .followerFollowing)

    override init(router: Router) {
        super.init(router: router)
    }

    func start(type : UserRequestURL.List, username : String) {
        controller.controller = self
        controller.listType = type
        controller.username = username
    }
    
    override func toPresentable() -> UIViewController {
        return controller
    }
    
    func showProfile(username : String) {
        let profile = ProfileCoordinator(router: self.router as! Router)
        profile.start(with: .profile, username: username, nav : navigator)
        navigator?.hidesCamera(hides: true)
        add(profile)
    }
}

extension FollowersAndFollowingListCoordinator : FollowingListViewControllerDelegate {
    func didMoveToProfile(username:String) {
        showProfile(username: username)
    }
}

