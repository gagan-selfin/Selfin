//
//  NotificationViewModel.swift
//  Selfin
//
//  Created by Kenish on 2018-07-31.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

final class NotificationViewModel {
    weak var controller:NotificationController?
    weak var delegate:NotificationControllerDelegate?
    
    let notification = NotificationTask()
    let user = UserTask(username: "")
    
    func getNotification(notificationType: Type_Notification, page: Int) {
        notification.fetchUserNotifications(type: notificationType, page: page)
            .done {self.controller?.didReceived(data: $0, notificationType: notificationType)}
            .catch {self.controller?.didReceived(erorr: String(describing: $0.localizedDescription))}
    }
    
    func accept(username:String, id:Int)  {
        user.acceptFollowRequest(with: UserTaskParams.AcceptDenyFollowRequest(username:username,id:id))
            .done {self.delegate?.didReceived(status: $0)}
            .catch { self.delegate?.didFailed(error: String(describing: $0))}
    }
    
    func decline(username:String, id:Int)  {
        user.declineFollowRequest(with: UserTaskParams.AcceptDenyFollowRequest(username:username,id:id))
            .done {self.delegate?.didReceived(status: $0)}
            .catch { self.delegate?.didFailed(error: String(describing: $0))}
    }
}
