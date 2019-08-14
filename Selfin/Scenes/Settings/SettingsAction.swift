//
//  SettingsAction.swift
//  Selfin
//
//  Created by cis on 06/12/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

enum SettingsTableViewOptions : String {
    case editProfile = "Edit profile"
    case faq = "FAQ"
    case notifications = "Notifications"
    case accountType = "Account type"
    case BlockedUser = "Blocked Users"
    case earnStars = "Earn Stars"
    case privacyPolicy = "Privacy policy"
    case terms = "Terms and conditions"
    case mobile = "Update phone number"
    case changePwd = "Change Password"
    case contactUs = "Contact us"
    case logout = "Logout"
}

protocol SettingsViewControllerDelegate {
    func didSelect(index: Int)
}

protocol SettingsCoordinatorDelegate {
    func moveToStaticPageScreen()
    func moveToPreviousScreen(isAvatarImageChange: Bool)
}

protocol SettingsDelegate : class {
    func didReceived(success:Bool)
    func didReceived(error msg:String)
    func didReceived(data:accountSettings)
}

extension SettingsDelegate {
    func didReceived(success:Bool) {}
    func didReceived(error msg:String) {}
    func didReceived(data:accountSettings) {}
}

enum StaticPageHeader : String {
    case faq = "Frequently Asked Questions"
    case privacyPolicy = "Privacy Policy"
    case terms = "Terms of Use"
    case contactUs = "Contact Us"
    case policies = "Policies"
    case policiesT = "Policies & Terms of Use"
}
