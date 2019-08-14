//
//  EditProfileAction.swift
//  Selfin
//
//  Created by cis on 20/12/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

protocol EditProfileViewControllerDelegate {
    func moveToPreviousScreen(isAvatarImageChange: Bool)
    func callProfileApi(isAvatarImageChange: Bool)
    func openCameraForEditingAvatar()
}

protocol EditProfileAPIDelegate : class {
    func didReceived(response:EditProfileResponse)
}

enum EditProfileResponse {
    case success(data:EditProfile)
    case error(err:String)
}

extension EditProfileViewControllerDelegate {
    func moveToPreviousScreen(isAvatarImageChange _: Bool) {}
    func callProfileApi(isAvatarImageChange _: Bool) {}
    func openCameraForEditingAvatar() {}
}
