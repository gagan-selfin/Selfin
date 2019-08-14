//
//  LikesCoordinator.swift
//  Selfin
//
//  Created by cis on 21/09/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

class LikesCoordinator: Coordinator<AppDeepLink> {
    let controller: LikesViewController = LikesViewController.from(from: .like, with: .like)
    var postId = Int()
    weak var navigator: Navigator?

    override init(router: Router) {
        super.init(router: router)
        controller.delegateCoordinate = self
    }

    override func toPresentable() -> UIViewController {return controller}
    
    override func start() {controller.postId = postId}
}

extension LikesCoordinator:LikesCoordinatorDelegate {
    func showProfile(username: String) {
        let profile = ProfileCoordinator(router: self.router as! Router)
        profile.start(with: .profile, username: username, nav : navigator)
        navigator?.hidesCamera(hides: true)
        add(profile)
    }
}
