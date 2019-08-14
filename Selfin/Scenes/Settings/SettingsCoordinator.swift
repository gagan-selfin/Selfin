//
//  SettingsCoordinator.swift
//  Selfin
//
//  Created by cis on 20/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

class SettingsCoordinator: Coordinator<AppDeepLink> {
    var delegate: SettingsCoordinatorDelegate?
    var isImageAvatarChange = Bool()
    weak var navigator:Navigator?

    var changePassword: ChangePasswordCoordinator = {
        let nav = selfinNavigationController()
        let router = Router(navigationController: nav)
        let coordinator = ChangePasswordCoordinator(router: router)
        return coordinator
    }()

    var reg: RegistrationCoordinator = {
        let nav = selfinNavigationController()
        let router = Router(navigationController: nav)
        let coordinator = RegistrationCoordinator(router: router)
        return coordinator
    }()

    var editProfile: EditProfileCoordinator = {
        let nav = selfinNavigationController()
        let router = Router(navigationController: nav)
        let coordinator = EditProfileCoordinator(router: router)
        return coordinator
    }()

    var notificationSettings: NotificationsSettingsCoordinator = {
        let nav = selfinNavigationController()
        let router = Router(navigationController: nav)
        let coordinator = NotificationsSettingsCoordinator(router: router)
        return coordinator
    }()

    var staticPage: StaticPageCoordinator = {
        let nav = selfinNavigationController()
        let router = Router(navigationController: nav)
        let coordinator = StaticPageCoordinator(router: router)
        return coordinator
    }()

    lazy var settingsViewController: SettingsViewController = {
        let controller: SettingsViewController = SettingsViewController.from(from: .settings, with: .settings)
        controller.delegate = self
        return controller
    }()

    override init(router: Router) {
        super.init(router: router)
       
    }
	override func toPresentable() -> UIViewController {
		return settingsViewController
	}
    
    func showNotificationSettingsScreen() {
        let coordinator = NotificationsSettingsCoordinator(router: router as! Router)
        coordinator.delegate = self
        coordinator.start()
        add(coordinator)
    }

    func showEditProfileScreen() {
        let coordinator = EditProfileCoordinator(router: router as! Router)
        coordinator.delegate = self
        coordinator.start()
        navigator?.hidesCamera(hides: true)
        add(coordinator)
        self.router.push(coordinator, animated: false, completion: {[weak self, coordinator] in
            self?.navigator?.hidesCamera(hides:false)
            self?.remove(child: coordinator)
        })
    }

    func showStaticPageScreen(index: Int) {
        let coordinator = StaticPageCoordinator(router: router as! Router)
        switch index {
        case 1:
            coordinator.heading = StaticPageHeader.faq.rawValue
            break
        case 6:
            coordinator.heading = StaticPageHeader.privacyPolicy.rawValue
            break
        case 7:
            coordinator.heading = StaticPageHeader.terms.rawValue
            break
        case 10:
            coordinator.heading = StaticPageHeader.contactUs.rawValue
            break
        default:
            break
        }
        coordinator.start()
        add(coordinator)
    }

    func showUpdatePhoneScreen() {
        let coordinator = PhoneCoordinator(router: self.router as! Router)
        coordinator.isUpdate = true
        coordinator.start()
        add(coordinator)
    }

    func showChangePassword() {
        let router = Router()
        let coordinator = ChangePasswordCoordinator(router: router)
        coordinator.start()
        add(coordinator)
        self.router.push(coordinator, animated: false, completion: {[weak self, coordinator] in
            self?.remove(child: coordinator)
        })
    }

    func showEarnStars() {
        let coordinator = EarnStarsCoordinator(router: router as! Router)
        _ = coordinator.toPresentable()
        coordinator.screen = "Cancel"
        coordinator.start()
        add(coordinator)
    }
    
    func showBlockedUser() {
        let coordinator = BlockedUsersCoordinator(router: router as! Router)
        _ = coordinator.toPresentable()
        add(coordinator)
    }
}

extension SettingsCoordinator: SettingsViewControllerDelegate {
    func didSelect(index: Int) {
        switch index {
        case 0:
            showEditProfileScreen()
        case 1,6,7,10:
            showStaticPageScreen(index: index)
        case 2:
            showNotificationSettingsScreen()
        case 4:
            showBlockedUser()
        case 5:
            showEarnStars()
        case 8:
            showUpdatePhoneScreen()
        case 9:
            showChangePassword()
        default:
            break
        }
    }
}

extension SettingsCoordinator: NotificationsSettingsCoordinatorDelegate {
    func popBack() {
        router.popModule(animated: true)
        remove(child: notificationSettings)
    }
}

extension SettingsCoordinator: EditProfileCoordinatorDelegate {
    func openCameraForEditingAvatar() {}
    func openCamera() {}

    func callProfileApi(isAvatarImageChange: Bool) {
        if isAvatarImageChange {
            delegate?.moveToPreviousScreen(isAvatarImageChange: isAvatarImageChange)
        }
    }

    func popBackToPreviousScreen(isAvatarImageChange: Bool) {
        if isAvatarImageChange {
            router.popModule(animated: false)
        } else {
            router.popModule(animated: true)
        }
        remove(child: editProfile)
    }
}

extension SettingsCoordinator: ChangePasswordCoordinatorDelegate {
    func popBackToSettingsScreen() {
        router.popModule(animated: true)
        remove(child: changePassword)
    }
}
