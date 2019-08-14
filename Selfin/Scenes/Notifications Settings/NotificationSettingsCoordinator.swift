//
//  NotificationSettingsCoordinator.swift
//  Selfin
//
//  Created by cis on 25/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit
protocol NotificationsSettingsCoordinatorDelegate {
    func popBack()
}

class NotificationsSettingsCoordinator: Coordinator<AppDeepLink> {
    var delegate: NotificationsSettingsCoordinatorDelegate?
    lazy var notificationSettingsViewController: NotificationsSettingsViewController = {
        let controller: NotificationsSettingsViewController = NotificationsSettingsViewController.from(from: .notification_settings, with: .notification_settings)
        return controller
    }()

    override init(router: Router) {
        super.init(router: router)
        // otpViewController.delegate = self
        router.push(notificationSettingsViewController, animated: true, completion: nil)
    }
}
