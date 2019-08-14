//
//  CreatePostCoordinator.swift
//  Selfin
//
//  Created by cis on 27/09/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation
import UIKit

protocol CreatePostCoordinatorDelegate : class {
    func tagUsers(users: [FollowingFollowersResponse.User])
    func postSuccessfull()
}

protocol postSuccessfull : class {
    func didFinishPosting()
}

class CreatePostCoordinator: Coordinator<AppDeepLink> {
    let controller: NewPostViewController = NewPostViewController.from(from: .createPost, with: .createPost)
    weak var delegate : postSuccessfull?
    
    override init(router: Router) {
        super.init(router: router)
    }

    func start(image : UIImage) {
        controller.image = image
        controller.delegate = self
        router.push(controller, animated: true, completion: nil)
    }
    
    func showTagList(user : [FollowingFollowersResponse.User]) {
        let tag = TagListCoordinator(router: router as! Router)
        tag.delegate = self
        tag.start(arraySelectedUsers: user)
        add(tag)
    }
}

extension CreatePostCoordinator : CreatePostCoordinatorDelegate, TagListCoordinatorDelegate {
    
    func tagUsers(users: [FollowingFollowersResponse.User]) {
        showTagList(user: users)
    }
    
    func postSuccessfull() {
        DispatchQueue.main.async {
            self.remove(child: self)
            self.router.popModule(animated: false)
            self.delegate?.didFinishPosting()
        }
    }

    func taggedUserMove(users: [FollowingFollowersResponse.User]) {
        controller.tagUsers(users: users)
    }
}



