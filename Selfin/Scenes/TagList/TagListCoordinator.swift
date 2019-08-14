//
//  TagListCoordinator.swift
//  Selfin
//
//  Created by cis on 04/10/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

class TagListCoordinator: Coordinator<AppDeepLink> {
    let controller: TagListViewController = TagListViewController.from(from: .tagList, with: .tagList)
    
    weak var delegate:TagListCoordinatorDelegate?

    override init(router: Router) {
        super.init(router: router)
    }

    func start(arraySelectedUsers : [FollowingFollowersResponse.User]) {
        controller.delegate = self
        if arraySelectedUsers.count > 0 {
            controller.arraySelectedUsers = arraySelectedUsers
            controller.isAlreadyPicked = true
        }
        router.push(controller, animated: true, completion: nil)
    }
}

extension TagListCoordinator: TagListViewControllerDelegate {
    func taggedUser(Users: [FollowingFollowersResponse.User]) {
        remove(child: self)
        router.popModule(animated: true)
        delegate?.taggedUserMove(users: Users)
    }
}
