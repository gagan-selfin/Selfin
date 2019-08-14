//
//  SubAccountCoordinator.swift
//  Selfin
//
//  Created by cis on 21/02/2019.
//  Copyright © 2019 Selfin. All rights reserved.
//

import Foundation

class SubAccountCoordinator: Coordinator<AppDeepLink> {
    weak var navigator: Navigator?
    let controller: SubAccountsViewController = SubAccountsViewController.from(from: .subAccount, with: .subAccount)
    
    override init(router: Router) {
        super.init(router: router)
    }
    
    override func start() {
       self.router.push(controller, animated: true, completion: nil)
    }
}

extension SubAccountCoordinator : SubAccountsCoordinatorDelegate {
    func didMoveToProfleDetails(username : String) {
        showProfile(username: username)
    }
    
    func showProfile(username : String) {
        let profile = ProfileCoordinator(router: self.router as! Router)
        navigator?.hidesCamera(hides: true)
        profile.start(with: .profile, username: username, nav: navigator)
        add(profile)
    }
}

