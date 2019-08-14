//
//  NotificationsSettingsViewController.swift
//  Selfin
//
//  Created by cis on 25/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit


class NotificationsSettingsViewController: UIViewController {
    @IBOutlet var tblNotificationsSettings: NotificationsSettingsTableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        backButton()
        let arrOptions = ["Push Notifications", "Promotional Notifications"]
        tblNotificationsSettings.display(options: arrOptions)
    }
}
