//
//  NewPasswordCoordinator.swift
//  Selfin
//
//  Created by cis on 17/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

class NewPasswordCoordinator: Coordinator<AppDeepLink> {
   // var email = String ()
    lazy var controller: NewPasswordViewController = {
        let controller: NewPasswordViewController = NewPasswordViewController.from(from: .newPassword, with: .newPassword)
        return controller
    }()
    
    override init(router: Router) {
        super.init(router: router)
    }
    
    func start(email : String) {
        controller.delegate = self
        controller.email = email
        router.push(controller, animated: true, completion: nil)
    }
}

extension NewPasswordCoordinator:NewPasswordDelegate {
    func moveBack() {
        remove(child: self)
        router.popModule(animated: true)
    }
}
