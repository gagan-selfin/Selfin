//
//  NotificationsTableView.swift
//  Selfin
//
//  Created by Marlon Monroy on 7/1/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

class NotificationsTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    var onSelection:((_ type:Type_Notification) ->())?
    weak var controller:NotificationsTableDelegate?
    var currentNotificationType:Type_Notification = .type_self
    weak var headerView: HeaderViewCell?
    weak var delegateAction:NotificationDelegate?

    var hasMore = true
    var page = 1
    var notificationList :[UserNotification.NotificationType] = []
    var socialList :[UserNotification.NotificationType] = []
    var page_social = 1

    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
        dataSource = self
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = 100
        registerToReceiveNotification()
    }

    //MARK:-
    //MARK:- TableView Datasource
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        switch currentNotificationType {
        case .type_self: return notificationList.count
        case .type_social: return socialList.count}
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{return cell(for: indexPath)}
    
    //MARK:-
    //MARK:- TableView Delegate
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        handlePagination(controller: controller, indexPath: indexPath, notificationType: currentNotificationType)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {return 60}
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = dequeueReusableCell(withIdentifier: NotificationsTableViewCellIdentifier.header.rawValue) as! HeaderViewCell
        headerView = cell
        headerView?.onSelection = onSelection
        headerView?.setType(type: currentNotificationType)
        return cell
    }

    //MARK:-
    //MARK:- Custom Methods
    func prepareToRefresh(type:Type_Notification) {
        if type == .type_self {
            page = 1
        }else {
            page_social = 1
        }
    }
    
    func switchNotificationType(type:Type_Notification){
        currentNotificationType = type
        reloadData()
    }

    func cell (for index:IndexPath) -> UITableViewCell {
        var notification: UserNotification.NotificationType
        switch currentNotificationType {
        case .type_self:
            notification = notificationList[index.row]
        case .type_social:
            notification = socialList[index.row]}
        
        if notification.notification_type == NotificationCellType.earnStar.rawValue {
            let cell = dequeueReusableCell(withIdentifier: NotificationsTableViewCellIdentifier.earnStar.rawValue, for: index) as! EarnStarTableViewCell
            cell.delegate = self
            cell.btnStars.tag = index.row
            cell.btnStars.addTarget(self, action: #selector(btnUserImagePressed(sender:)), for: .touchUpInside)

            cell.configureEarnStarCell(notification: notification, username: UserStore.user?.userName ?? "")
            return cell
        }
        else if notification.notification_type == NotificationCellType.followRequest.rawValue {
            let cell = dequeueReusableCell(withIdentifier: NotificationsTableViewCellIdentifier.followRequest.rawValue, for: index) as! FollowRequestTableViewCell
            cell.delegate = self
            cell.btnRequest.tag = index.row
            cell.btnRequest.addTarget(self, action: #selector(btnUserImagePressed(sender:)), for: .touchUpInside)

            cell.configureFollowRequestCell(notification: notification, username: UserStore.user?.userName ?? "", index: index.row, type: currentNotificationType)
            
            return cell
        }
        else if notification.notification_type == NotificationCellType.like.rawValue || notification.notification_type == NotificationCellType.comment.rawValue
        {
            let cell = dequeueReusableCell(withIdentifier: NotificationsTableViewCellIdentifier.like.rawValue, for: index) as! LikeTableViewCell
            cell.delegate = self
            cell.btnLikeUser.tag = index.row
            cell.btnLikeUser.addTarget(self, action: #selector(btnUserImagePressed(sender:)), for: .touchUpInside)
            
            cell.configureLikeCell(notification: notification, username: UserStore.user?.userName ?? "")
            return cell
        }else {
            let cell = dequeueReusableCell(withIdentifier: NotificationsTableViewCellIdentifier.information.rawValue, for: index) as! InformationTableViewCell
            cell.delegate = self
            cell.btnInfo.tag = index.row
            cell.btnInfo.addTarget(self, action: #selector(btnUserImagePressed(sender:)), for: .touchUpInside)
            
            cell.configureInformationCell(notification: notification, username: UserStore.user?.userName ?? "")
            return cell
        }
    }
    
    func display(list: [UserNotification.NotificationType],notificationType:Type_Notification) {
        hasMore = list.count > 0
        currentNotificationType = notificationType
        
        switch currentNotificationType {
        case .type_self:
            if page == 1 { notificationList.removeAll() }
            notificationList.append(contentsOf: list)
        case .type_social:
            if page_social == 1 { socialList.removeAll() }
            socialList.append(contentsOf: list)}
        reloadData()
    }
    
    func handlePagination(controller : NotificationsTableDelegate?, indexPath : IndexPath, notificationType:Type_Notification) {
        
        switch notificationType {
        case .type_self:
            if indexPath.row == notificationList.count - 1 && hasMore {
                page += 1
                controller?.setData(page: page, type: notificationType)}
        case .type_social:
            if indexPath.row == socialList.count - 1 && hasMore {
                page_social += 1
                controller?.setData(page: page_social, type: notificationType)}
        }
    }
    
    func showProfile(index:Int) {
        switch currentNotificationType {
        case .type_self:
            delegateAction?.showProfile(username: notificationList[index].user.userName)
        case .type_social:
            delegateAction?.showProfile(username: socialList[index].user.userName)
        }
    }
    
    @objc func btnUserImagePressed(sender: UIButton){showProfile(index: sender.tag)}
    
    func registerToReceiveNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(removeDeclinedRequestFromList(notification:)), name: NSNotification.Name(rawValue: "declineRequest"), object: nil)
    }
    
    @objc func removeDeclinedRequestFromList(notification:Notification)  {
        if notification.object != nil {
            let dict:[String:Int] = notification.object as! [String:Int]
            notificationList.remove(at: dict["index"]!)
            self.reloadData()
        }
    }
}

extension NotificationsTableView : navigationFromCells {
    func didMove(to action: NotificationNavigations) {
        switch action {
        case .profile(username: let name)://name.components(separatedBy: "'").first ?? ""
            delegateAction?.showProfile(username: name)
        case .post(id: let id):
            delegateAction?.showPostDetails(postId: id)
        }
    }
}
