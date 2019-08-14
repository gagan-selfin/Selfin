//
//  OTPCoordinator.swift
//  Selfin
//
//  Created by cis on 13/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

protocol OTPCoordinatorDelegate {
    func moveToPhone()
}

class OTPCoordinator: Coordinator<AppDeepLink> {
    lazy var otpViewController: OTPViewController = {
        let controller: OTPViewController = OTPViewController.from(from: .otp, with: .otp)
        return controller
    }()

    var delegate: OTPCoordinatorDelegate?
    var isUpdate:Bool?
    
    override init(router: Router) {
        super.init(router: router)
        otpViewController.delegate = self
        router.push(otpViewController, animated: true, completion: nil)
    }
    
    override func start() {
        otpViewController.isUpdate = isUpdate ?? false
    }

    // MARK: - Custom Methods

    func showPinScreen() {
        let coordinator = OTPCoordinator(router: router as! Router)
        // coordinator.delegate = self
        _ = coordinator.toPresentable()
        add(coordinator)
    }

    func showOTPScreen() {
        let coordinator = CreateUsernameCoordinator(router: router as! Router)
        coordinator.delegate = self
        _ = coordinator.toPresentable()
        add(coordinator)
    }

    func goToPreviousController() {
        remove(child: self)
        router.popModule(animated: true)
    }
}

extension OTPCoordinator: OTPViewControllerDelegate, CreateUsernameCoordinatorDelegate {
    func moveBack() {
        showPinScreen()
    }

    func moveToVerifyPin() {
        remove(child: self)
        delegate?.moveToPhone()
    }

    func moveToCreateUsername() {
        showOTPScreen()
    }

    func goBackToEnterPhoneScreen() {
        goToPreviousController()
    }
}
