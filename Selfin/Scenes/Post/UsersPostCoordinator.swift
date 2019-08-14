//
//  UsersPostCoordinator.swift
//  Selfin
//
//  Created by cis on 21/12/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation
import UIKit

protocol UsersPostCoordinatorDelegate : class {
    func didMoveToDetail(id:Int)
}

class UsersPostCoordinator: Coordinator<AppDeepLink> {
    let controller: UsersPostViewController = UsersPostViewController.from(from: .post, with: .post)
    
    override init(router: Router) {
        super.init(router: router)
    }
    
    func start(string : String, type : postType) {
        controller.delegate = self
        controller.typeText = string
        controller.type = type
    }
    
    override func toPresentable() -> UIViewController {
        return controller
    }
}

extension UsersPostCoordinator : UsersPostViewControllerDelegate {
    func didMoveToDetail(id: Int) {
        let post = PostDetailsCoordinator(router: self.router as! Router)
        post.start(with: id)
        add(post)
        self.router.push(post, animated: true, completion: {[weak self] in
            self?.remove(child: post)
        })
    }
}
