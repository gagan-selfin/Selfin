//
//  CreateUsernameCoordinator.swift
//  Selfin
//
//  Created by cis on 13/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

protocol CreateUsernameCoordinatorDelegate {
    func moveToVerifyPin()
    func moveBack()
}

class CreateUsernameCoordinator: Coordinator<AppDeepLink> {
    
    lazy var createUsernameViewController: CreateUsernameViewController = {
        let controller: CreateUsernameViewController = CreateUsernameViewController.from(from: .createUsername, with: .createUsername)
        controller.delegate = self
        return controller
    }()

    var delegate: CreateUsernameCoordinatorDelegate?

    override init(router: Router) {
        super.init(router: router)
        createUsernameViewController.delegate = self
        router.push(createUsernameViewController, animated: true, completion: nil)
    }

//    func showEarnStars() {
//        let coordinator = EarnStarsCoordinator(router: router as! Router)
//        _ = coordinator.toPresentable()
//        coordinator.screen = "Skip"
//        coordinator.delegate = self
//        coordinator.start()
//        add(coordinator)
//    }
}

extension CreateUsernameCoordinator: CreateUsernameViewControllerDelegate, EarnStarsCoordinatorDelegate {
    func goBackToLogin() {
        remove(child: self)
        router.popModule(animated: false)
        delegate?.moveBack()
    }

    func moveToApplicationMainView() {
        remove(child: self)
        delegate?.moveToVerifyPin()
    }

    func moveToEarnStars() {
        remove(child: self)
        delegate?.moveToVerifyPin()
    //showEarnStars() //Bypass for now
    }
}
