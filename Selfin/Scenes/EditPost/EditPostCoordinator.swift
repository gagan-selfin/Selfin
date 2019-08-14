//
//  EditPostCoordinator.swift
//  Selfin
//
//  Created by cis on 20/12/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation
import UIKit

class EditPostCoordinator: Coordinator<AppDeepLink> {
    let controller: EditPostViewController = EditPostViewController.from(from: .editPost, with: .editPost)
    
 
    weak var delegate : postSuccessfull?
    
    override init(router: Router) {
        super.init(router: router)
    }
    
    func start(post : scheduledPostResponse.Post) {
        controller.delegate = self
        controller.scheduledPost = post
    }
    
    override func toPresentable() -> UIViewController {
        return controller
    }
    
    func showTagList(user : [FollowingFollowersResponse.User]) {
        let tag = TagListCoordinator(router: router as! Router)
        tag.delegate = self
        tag.start(arraySelectedUsers: user)
        add(tag)
    }
}

extension EditPostCoordinator : CreatePostCoordinatorDelegate, TagListCoordinatorDelegate {
    
    func tagUsers(users: [FollowingFollowersResponse.User]) {
        showTagList(user: users)
    }
    
    func postSuccessfull() {
        remove(child: self)
        router.popModule(animated: false)
        delegate?.didFinishPosting()
    }
    
    
    func taggedUserMove(users: [FollowingFollowersResponse.User]) {
        controller.tagUsers(users: users)
    }
}
