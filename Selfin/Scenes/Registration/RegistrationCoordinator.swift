//
//  RegistrationCoordinator.swift
//  Selfin
//
//  Created by Marlon Monroy on 8/18/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

protocol RegistrationCoordinatorDelegate {
    func moveToApplicationMainView()
}

class RegistrationCoordinator: Coordinator<AppDeepLink> {
    var delegate: RegistrationCoordinatorDelegate?
    let controller: RegistrationViewController = RegistrationViewController.from(from: .register, with: .registration)

    override init(router: Router) {
        super.init(router: router)
        controller.delegate = self
    }
    
    func start(with link: AppDeepLink? , email:String){
        switch link {
        case .root?:
            router.setRootModule(controller, hideBar: false)
        case .details?:
            showNewPwdScreen(email: email)
        case .none:
            print("none")
        }
    }

    func showCreateUsernameScreen() {
        let coordinator = CreateUsernameCoordinator(router: router as! Router)
        coordinator.start()
        add(coordinator)
    }

    func showOTPScreen() {
        let coordinator = OTPCoordinator(router: router as! Router)
        coordinator.start()
        add(coordinator)
    }

    func showForgetPasswordScreen() {
        let coordinator = ForgetPasswordCoordinator(router: router as! Router)
        coordinator.start()
        add(coordinator)
    }

    func showPolicyScreen() {
        let coordinator = StaticPageCoordinator(router: router as! Router)
        coordinator.heading = StaticPageHeader.policiesT.rawValue
        coordinator.start()
        add(coordinator)
    }
    
    func showNewPwdScreen(email:String) {
        let coordinator = NewPasswordCoordinator(router: router as! Router)
//        coordinator.email = email
        coordinator.start(email : email)
        add(coordinator)
    }

    func showSettingsScreen() {
        let coordinator = SettingsCoordinator(router: router as! Router)
        coordinator.start()
        add(coordinator)
    }

    func showPhoneNumber() {
        let coordinator = PhoneCoordinator(router: router as! Router)
        coordinator.delegate = self
        coordinator.start()
        add(coordinator)
    }
}

extension RegistrationCoordinator: RegistrationViewControllerDelegate, PhoneCoordinatorDelegate {
    func moveToNewPwd(email: String) {
        showNewPwdScreen(email: email)
    }
    
    func moveToPolicyScreen() {
        showPolicyScreen()
    }

    func moveToRegistration() {
        delegate?.moveToApplicationMainView()
    }

    func moveToCreateUsernameScreen() {
        showCreateUsernameScreen()
    }

    func moveToOTPScreen() {
        showOTPScreen()
    }

    func moveToSettingsScreen() {
        showSettingsScreen()
    }

    func moveToForgetPasswordScreen() {
        showForgetPasswordScreen()
    }

    func moveToMainScreen() {
        delegate?.moveToApplicationMainView()
    }

    func moveToEnterPhoneScreen() {
        showPhoneNumber()
    }
}
