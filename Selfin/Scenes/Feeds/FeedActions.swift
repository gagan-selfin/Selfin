//
//  FeedActions.swift
//  Selfin
//
//  Created by Marlon Monroy on 11/17/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

enum FeedControllerActions {
    case showProfile(username : String)
	case showPostActionSheet
    case showPostDetail(id:Int, isAnimate:Bool)
	case showChat
    case showChatRoom(user: HSChatUsers)
    case showLocation(location:String)
}

protocol HomeFeedViewControllerDelegate: class {
	func feedControllerActions(action:FeedControllerActions)
}

protocol HomeFeedController: class {
    func didReceived(responseType:FeedAPIResponse)
}

enum FeedAPIResponse {
    case feed(feed:[HomeFeed.Post], page : Int)
    case error(error: String)
    case report(data:ReusableResponse)
    case notification(data:ReusableResponse)
    case copyLink(data:StaticPage)
    case delete(id : Int)
}

enum CopyLinkSuccess: String {
    case copied = "Copied to clipboard"
}

enum ReportType : String {
    case inappropraite = "Inappropriate"
    case spam = "Spam"
}
