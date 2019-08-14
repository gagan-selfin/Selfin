//
//  ProfileRequestURL.swift
//  Selfin
//
//  Created by cis on 06/12/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

struct ProfileRequestURL {
    static func editProfile() -> String {
        return "v1/user/profile/"
    }
    
    static func changePicture(username:String) -> String {
        return "v1/user/\(username)/profile/change-profile-picture/"
    }
    
    static func copyUserProfileLink(username:String) -> String{
        return "v1/profile/\(username)/copy-link/"
    }
}
