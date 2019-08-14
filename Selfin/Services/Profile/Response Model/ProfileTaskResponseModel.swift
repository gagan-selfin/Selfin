//
//  ProfileTaskResponseModel.swift
//  Selfin
//
//  Created by cis on 06/12/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

struct EditProfile: Codable {
    var msg: String
    var status: Bool
    var profile: editProfileData
    
    struct editProfileData: Codable {
        let bio:String
        let lastName:String
        let firstName:String
        let username:String
        let email: String
        let profileImage: String

        enum CodingKeys: String, CodingKey {
            case bio
            case lastName = "last_name"
            case firstName = "first_name"
            case username
            case email
            case profileImage = "profile_image"
        }
    }
}








