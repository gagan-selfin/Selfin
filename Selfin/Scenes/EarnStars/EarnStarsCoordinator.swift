//
//  EarnStarsCoordinator.swift
//  Selfin
//
//  Created by cis on 14/09/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

protocol EarnStarsCoordinatorDelegate {
    func moveToApplicationMainView()
}

class EarnStarsCoordinator: Coordinator<AppDeepLink> {
    var delegate: EarnStarsCoordinatorDelegate?
    var screen = String()

    lazy var earnStarsViewController: EarnStarsViewController = {
        let controller: EarnStarsViewController = EarnStarsViewController.from(from: .earnStars, with: .earnStars)
        controller.delegate = self
        return controller
    }()

    override init(router: Router) {
        super.init(router: router)
        // router.push(earnStarsViewController, animated: true, completion: nil)
    }

    override func start() {
        earnStarsViewController.screen = screen
        router.push(earnStarsViewController, animated: true, completion: nil)
    }

    func showReferFriendScreen(referal_code: String) {
        let coordinator = ReferFriendsCoordinator(router: router as! Router)
        _ = coordinator.toPresentable()
        coordinator.screen = "Cancel"
        coordinator.referal_code = referal_code
        coordinator.start()
        add(coordinator)
    }
}

extension EarnStarsCoordinator: EarnStarsViewControllerDelegate, ReferFriendsCoordinatorDelegate {
    func popToSettings() {
        router.popModule(animated: true)
        remove(child: self)
    }

    func moveBackToEarnStars() {
        remove(child: self)
        delegate?.moveToApplicationMainView()
    }

    func moveToMainScreen() {
        remove(child: self)
        delegate?.moveToApplicationMainView()
    }

    func moveToReferFriendScreen(referal_code: String) {
        showReferFriendScreen(referal_code: referal_code)
    }
}
