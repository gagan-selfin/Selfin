//
//  ForgetPasswordCoordinator.swift
//  Selfin
//
//  Created by cis on 17/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit
class ForgetPasswordCoordinator: Coordinator<AppDeepLink> {
    lazy var forgetpasswordViewController: ForgotPasswordViewController = {
        let controller: ForgotPasswordViewController = ForgotPasswordViewController.from(from: .forgetPassword, with: .forgetPassword)
        controller.delegate = self
        return controller
    }()

    override init(router: Router) {
        super.init(router: router)
        // router.present(phoneViewController)
        // forgetpasswordViewController.delegate = self
        router.push(forgetpasswordViewController, animated: true, completion: nil)
    }
}

extension ForgetPasswordCoordinator: ForgotPasswordViewControllerDelegate {    
    func moveBackToLogin() {
        remove(child: self)
        router.popModule(animated: true)
    }
}
