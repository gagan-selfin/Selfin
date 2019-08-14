//
//  ProfileTaskParam.swift
//  Selfin
//
//  Created by cis on 06/12/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

struct ProfileTaskParam {
    struct editProfile : Codable {
        let name:String
        let username:String
        let email:String
        let bio:String
        
        enum CodingKeys: String, CodingKey {
            case name = "full_name"
            case username
            case email
            case bio
        }
    }
    
    struct changeProfileImage : Codable {
        let avatar:String
    }
}

