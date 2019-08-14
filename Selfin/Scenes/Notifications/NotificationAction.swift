//
//  NotificationAction.swift
//  Selfin
//
//  Created by cis on 28/11/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation
enum Type_Notification : String {
    case type_self = "self"
    case type_social = "social"
}

enum NotificationsTableViewCellIdentifier: String {
    case earnStar = "earnStar"
    case followRequest = "followRequest"
    case like = "like"
    case follow = "follow"
    case information = "information"
    case header = "header"
}

enum NotificationCellType: String {
    case earnStar = "Earn star"
    case followRequest = "Follow request"
    case like = "Like"
    case information = "Information"
    case post = "Post"
    case comment = "Comment"
}

protocol NotificationsTableDelegate: class
{func setData (page:Int, type:Type_Notification)}

protocol NotificationController : class {
    func didReceived(data:UserNotification, notificationType:Type_Notification)
    func didReceived(erorr msg:String)
}

protocol NotificationControllerDelegate : class {
    func didReceived(status:AcceptResquestResponse)
    func didReceived(status:ReusableResponse)
    func didFailed(error msg:String)
}

protocol NotificationDelegate: class {
    func showProfile(username:String)
    func showPostDetails(postId:Int)
}

protocol NotificationCoordinatorDelegate: class {
    func showProfile(username:String)
    func showPostDetails(postId:Int)
}

enum NotificationNavigations {
    case profile(username : String)
    case post(id : Int)
}

protocol navigationFromCells: class  {
    func  didMove(to action:NotificationNavigations)
}
