//
//  NotificationSettingsViewModel.swift
//  Selfin
//
//  Created by cis on 25/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation
protocol NotificationsSettingDelegate: class {
    func didReceived(data:NotificationSettings)
    func didReceived(error:String)

}
final class NotificationSettingsViewModel {
    private let task = UserTask(username: "")
    weak var delegate:NotificationsSettingDelegate?
    
    func notificationsettingsProcess(isPromotional: Bool, isPush:Bool) {
        task.updateNotificationSettings(param: UserTaskParams.notificationSettings(isPromotionalNotification:isPromotional ,isPushNotification:isPush))
        .done {self.delegate?.didReceived(data: $0)}
            .catch { self.delegate?.didReceived(error: String(describing: $0))}
    }
}
