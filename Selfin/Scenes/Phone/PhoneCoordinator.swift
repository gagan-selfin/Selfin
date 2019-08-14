//
//  PhoneCoordinator.swift
//  Selfin
//
//  Created by cis on 13/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

protocol PhoneCoordinatorDelegate {
    func moveToRegistration()
}

class PhoneCoordinator: Coordinator<AppDeepLink> {
    lazy var phoneViewController: PhoneViewController = {
        let controller: PhoneViewController = PhoneViewController.from(from: .phone, with: .phone)
        return controller
    }()

    var delegate: PhoneCoordinatorDelegate?
    var isUpdate:Bool?

    override init(router: Router) {
        super.init(router: router)
        phoneViewController.delegate = self
        router.push(phoneViewController, animated: true, completion: nil)
    }
    
    override func start() {phoneViewController.isUpdate = isUpdate}

    // MARK: - custome Methods
    func showOTPScreen() {
        let coordinator = OTPCoordinator(router: router as! Router)
        coordinator.delegate = self
        coordinator.isUpdate = isUpdate
        coordinator.start()
        _ = coordinator.toPresentable()
        add(coordinator)
    }

    func goToPreviousController() {
        remove(child: self)
        router.popModule(animated: true)
    }
}

extension PhoneCoordinator: PhoneViewControllerDelegate, OTPCoordinatorDelegate {
    func moveToPhone() {
        remove(child: self)
        delegate?.moveToRegistration()
    }

    func moveToEnterOTP() {
        showOTPScreen()
    }

    func goBackToRegistration() {
        goToPreviousController()
    }
}
