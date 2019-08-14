//
//  Adaptables.swift
//  Selfin
//
//  Created by Marlon Monroy on 6/30/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

enum Storyboard: String {
    case main = "Main"
    case feeds = "Feeds"
    case discover = "Discover"
    case camera = "Camera"
    case notifications = "Notifications"
    case profile = "Profile"
    case postDetails = "PostDetails"
    case onboarding = "Onboarding"
    case MainOnboarding
    case register = "Register"
    case phone = "Phone"
    case otp = "OTP"
    case createUsername = "CreateUsername"
    case earnStars = "EarnStars"
    case forgetPassword = "ForgotPassword"
    case newPassword = "NewPassword"
    case comments = "Comments"
    case tutorial = "Tutorial"
    case settings = "Settings"
    case static_page = "StaticPage"
    case refer_friends = "ReferFriends"
    case like = "Likes"
    case edit_profile = "EditProfile"
    case search = "DiscoverSearch"
    case notification_settings = "NotificationSettings"
    case actionOnPost = "ActionOnPost"
    case change_password = "ChangePassword"
    case createPost = "CreatePost"
    case chat = "Chat"
    case followerFollowing = "FollowersAndFollowingList"
    case schedule_post_list = "SchedulePostList"
    case tagList = "TagList"
    case userPosts = "UserPosts"
    case editPost = "EditPost"
    case post = "UsersPost"
    case filters = "Filters"
    case blockList = "BlockedUsers"
    case subAccount = "SubAccounts"
    case testImage = "testImage"
}

enum StoryboardIdentifier: String {
    case feeds = "Feeds"
    case homefeed = "HomeFeed"
    case discover = "Discover"
    case camera = "Camera"
    case notifications = "Notifications"
    case profile = "Profile"
    case postDetails = "PostDetails"
    case onboarding = "Onboarding"
    case onboardingPage = "OnboardingPage"
    case MainOnboarding
    case registration = "Registration"
    case phone = "Phone"
    case otp = "OTP"
    case createUsername = "CreateUsername"
    case earnStars = "EarnStars"
    case forgetPassword = "ForgotPassword"
    case newPassword = "NewPassword"
    case comments = "Comments"
    case tutorial = "Tutorial"
    case settings = "Settings"
    case static_page = "StaticPage"
    case refer_friends = "ReferFriends"
    case like = "Likes"
    case edit_profile = "EditProfile"
    case search = "Search"
    case notification_settings = "NotificationSettings"
    case actionOnPost = "ActionOnPost"
    case change_password = "ChangePassword"
    case createPost = "CreatePost"
    case chatList = "ChatList"
    case chatRoom = "ChatRoom"
    case followerFollowing = "FollowersAndFollowingList"
    case schedule_post_list = "SchedulePostList"
    case tagList = "TagList"
    case userPosts = "UserPosts"
    case editPost = "EditPost"
    case userProfile = "UserProfile"
    case post = "UsersPost"
    case filters = "Filters"
    case blockList = "BlockedUsers"
    case subAccount = "SubAccounts"
    case testImage = "testImage"
}

enum Constants: String {
    case alertTitle = "Selfin"
    case username
    case auth_token
    case show_screen
    case isFirstVisit = "isFirstTimeVisit"
    case fullname
    case email
    case bio
    case mob_no
    case private_account
    case push_notification
    case promotional_notification
    case userid
    case userimage
    case user
    case new_user_id
    case deviceToken
    case isCallProfileAPI
}

enum Validation: String {
    // EditProfile Module
    case enter_username = "Please enter your user name"
    case enter_status = "Please enter your status"

    // Change Pwd Module
    case pwd_match = "New password and confirm password must be same"

    // Login Module
    case enter_email = "Please enter your email id"
    case enter_valid_email = "Please enter valid email id"
    case enter_pwd = "Please enter your password"

    // Registration Module
    case enter_fullname = "Please enter your name"
    case enter_valid_pwd = "Your password must contain minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character"

    // Phone Module
    case enter_phone_number = "Please enter your mobile number"
    case enter_country_code = "Please enter your country code"

    // Create username
    case enter_user_name = "Please enter username"

    // OTP
    case enter_Pin = "Please enter pin"
    case enter_FiveDigit_Pin = "Please enter five digit pin"
}

// MARK: Use to handle ViewController Rotation

protocol HorizontalDisplayable {
    func handleRotation(orientation: UIDeviceOrientation)
}

protocol Reusable {
    static var reuseIndentifier: String { get }
    static var nib: UINib? { get }
    func configure<T>(with content: T)
}

extension Reusable {
    static var reuseIndentifier: String { return String(describing: self) }
    static var nib: UINib? { return nil }
}
