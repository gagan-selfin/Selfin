//
//  userProfileActions.swift
//  Selfin
//
//  Created by Marlon Monroy on 11/17/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation
import UIKit


enum initialMassege : String {
    case noPost = "I don't have any post. I am going to click on the camera icon below to take my first photo"
    case noLikedPost = "I didn't like any posts. There must be something I can like."
    case noTaggedPost = "No one tagged me yet. The best way to get tagged is to tag."
}

enum likeTypes {
    case like
    case superlike
}

enum UserProfilePostItemAction {
    case postActionButtonPressed(post: HomeFeed.Post, index : IndexPath)
	case avatarButtonPressed(post: HomeFeed.Post)
	case userButtonPressed(post: HomeFeed.Post)
    case likeButtonPressed(post:HomeFeed.Post, like : likeTypes, gesture : UIGestureRecognizer)
    case postSelected(post:HomeFeed.Post)
    case locationButtonPressed(location:String)
}

protocol UserProfileFeedItemDelegate :class {
	func userFeedItemActions(action:UserProfilePostItemAction)
}

enum UserProfileCollectionAction {
	case postAction(action:UserProfilePostItemAction)
    case fetchMore(page:Int)
	case postSelected(post:HomeFeed.Post)
    case mentionLikesSelected(post: TaggedLikedPostResponse.Post)
	case switchLayout(style: UserProfileCollectionStyle)
    case profileAction(action :ProfileAction, username : String)
    case editImage()
    case location(location:String)
}

protocol UserFeedCollectionDelegate: class {
	func userProfileCollectionActions(action:UserProfileCollectionAction)
    func fetchUsersData(_ style : UserProfileCollectionStyle, page : Int)
}

extension UserFeedCollectionDelegate {
    func userProfileCollectionActions(action:UserProfileCollectionAction){}
    func fetchUsersData(_ style : UserProfileCollectionStyle, page : Int){}
}

enum ProfileAction {
	case showFollowers
	case showFollowing
	case showSettings
    case showPost
    case showShedulePostList
    case editProfile
    case blocked
}

enum UserProfileFeedAction {
    case showUserPostDetail(id:Int)
    case showLocation(string : String)
}

protocol UserProfileDelegate :class  {
    func profileActions(action:ProfileAction, user : String)
    func profileFeedAction(action:UserProfileFeedAction)
}

protocol UserProfileController: class {
    func didReceived(notificationstatus: ReusableResponse)
    func didReceived(profile: ReusableResponse)
    func didReceived(profile: Profile)
    func didReceived(profile: OthersProfile)
    func didReceived(posts: [HomeFeed.Post])
    func didReceived(data : [TaggedLikedPostResponse.Post], style : UserProfileCollectionStyle)
    func didReceived(error msg: String)
    func didReceiveSuccess(id : Int, index : IndexPath)
    func didReceived(link : StaticPage)
}

extension UserProfileController {
    func didReceived(profile: ReusableResponse) {}
    func didReceiveSuccess(id : Int, index : IndexPath) {}
    func didReceived(profile: OthersProfile){}
    func didReceived(profile: Profile){}
    func didReceived(link : StaticPage){}
}

protocol followUnfollowDelegate : class {
    func didReceived(data: followUnfollowUser)
    func didReceived(error msg: String)
}
