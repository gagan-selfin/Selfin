//
//  NotificationTask.swift
//  Selfin
//
//  Created by cis on 05/12/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation
import PromiseKit

enum NotificationRequest:RequestRepresentable {
    case notification(page:Int)
    case publicNotification(page:Int)
}

extension NotificationRequest {
    var method: HTTPMethod {
         return .get
    }
    
    var endpoint: String {
        switch self {
        case .notification(let page):
            return NotificationRequestURL.notification(page: page)
        case .publicNotification(let page):
            return NotificationRequestURL.publicNotification(page: page)
        }
    }
}

final class NotificationTask {
    let dispatcher = SessionDispatcher()
    
    func fetchUserNotifications(type:Type_Notification ,page : Int) -> Promise<UserNotification> {
        if type == Type_Notification.type_self {
            return dispatcher.execute(requst: NotificationRequest.notification(page: page), modeling: UserNotification.self)
        }
        return dispatcher.execute(requst: NotificationRequest.publicNotification(page: page), modeling: UserNotification.self)
    }
    
}
