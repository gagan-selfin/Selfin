//
//  PostDetailsActions.swift
//  Selfin
//
//  Created by cis on 19/11/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

enum PosthandlerCases : String {
    case report = "Report/Hide"
    case sendMessage = "Send Message"
    case notificationOn = "Turn on Notifications"
    case notificationOff = "Turn off Notifications"
    case copyLink = "Copy Link"
    case delete = "Delete"
    case edit = "Edit"
}

enum PostDetailAction {
    case previous
    case comment
    case like
    case post
    case profile(username: String)
    case action(feedId: Int?, user: HSChatUsers)
    case report(data:ReusableResponse)
    case copyLink(data:StaticPage)
    case mention(string : String)
    case hashtags(string : String)
    case location(location :String)

}

protocol PostDetailsViewControllerDelegate: class {
	func postDetailActions(action:PostDetailAction)
}

enum PostViewModalAction {
    case notification(data:ReusableResponse)
    case report(data:ReusableResponse)
	case post(data:PostDetailResponse)
	case error(msg:String)
	case followUnFollow(data:followUnfollowUser)
	case like(data:PostLikeResponse)
    case copyLink(data:StaticPage)

}

protocol PostDetailController : class {
	func viewModalActions(action:PostViewModalAction)
}

enum NotificationResponse : String {
    case notificationOn = "Notification turned on."
    case notificationOff = "Notification turned off."
}
