//
//  CommentsCoordinator.swift
//  Selfin
//
//  Created by cis on 18/09/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit


class CommentsCoordinator: Coordinator<AppDeepLink> {
    let controller: CommentsViewController = CommentsViewController.from(from: .comments, with: .comments)
    var postId = Int()
    weak var navigator: Navigator?

    override init(router: Router){
        super.init(router: router)
        controller.delegate = self
    }
    
    override func toPresentable() -> UIViewController
    {return controller}

    override func start()
    {controller.postId = postId}
}

extension CommentsCoordinator:CommentsCoordinatorDelegate {
    func showProfile(username: String) {
        let profile = ProfileCoordinator(router: self.router as! Router)
        profile.start(with: .profile, username: username,nav : navigator)
        navigator?.hidesCamera(hides: true)
        add(profile)
    }
}
