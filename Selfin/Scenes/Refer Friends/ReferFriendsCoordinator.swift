//
//  ReferFriendsCoordinator.swift
//  Selfin
//
//  Created by cis on 21/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

protocol ReferFriendsCoordinatorDelegate {
    func moveBackToEarnStars()
}

class ReferFriendsCoordinator: Coordinator<AppDeepLink> {
    var screen = String()
    var referal_code = String()

    lazy var referFriendsViewController: ReferFriendsViewController = {
        let controller: ReferFriendsViewController = ReferFriendsViewController.from(from: .refer_friends, with: .refer_friends)
        controller.delegate = self
        return controller
    }()

    var delegate: ReferFriendsCoordinatorDelegate?

    override init(router: Router) {
        super.init(router: router)
        // router.push(referFriendsViewController, animated: true, completion: nil)
    }

    override func start() {
        referFriendsViewController.screen = screen
        referFriendsViewController.referal_code = referal_code
        router.push(referFriendsViewController, animated: true, completion: nil)
    }
}

extension ReferFriendsCoordinator: ReferFriendsViewControllerDelegate {
    func popToSettings() {
        router.popModule(animated: true)
        remove(child: self)
    }

    func skipEarnMoreStart() {
        remove(child: self)
        delegate?.moveBackToEarnStars()
    }
}
