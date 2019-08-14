//
//  ChangePasswordCoordinator.swift
//  Selfin
//
//  Created by cis on 27/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

protocol ChangePasswordCoordinatorDelegate {
    func popBackToSettingsScreen()
}

class ChangePasswordCoordinator: Coordinator<AppDeepLink> {
    var delegate: ChangePasswordCoordinatorDelegate?

    lazy var controller: ChangePasswordViewController = {
        let controller: ChangePasswordViewController = ChangePasswordViewController.from(from: .change_password, with: .change_password)
        return controller
    }()

    override init(router: Router) {
        super.init(router: router)
        //router.push(controller, animated: true, completion: nil)
    }
    
    override func toPresentable() -> UIViewController {
        return controller
    }
}
