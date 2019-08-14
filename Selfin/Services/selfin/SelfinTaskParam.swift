//
//  SelfinTaskParam.swift
//  Selfin
//
//  Created by cis on 07/12/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation
struct SelfinTaskParam {
    struct referralCode:Codable {
        let contacts: [String]
        let code:String
    }
    
    struct cahtNotification: Codable {
        let message : String
        let receiver_username : String
    }
}


//{
//    "msg": "",
//    "status": true,
//    "account_list": [
//    {
//    "profile_image": "/media/avatars/26-min.jpg?w=300&h=300",
//    "username": "realracing",
//    "first_name": "Real",
//    "last_name": "Racing",
//    "following": false,
//    "user_id": 10187
//    }
//    ]
//}
struct SubSelfinAccounts : Codable {
    let message : String
    let status : Bool
    let accounts : [AccountList]
    
    enum CodingKeys: String, CodingKey {
        case message = "msg"
        case status
        case accounts = "account_list"
    }
    
    struct AccountList : Codable {
        let lastName : String
        let firstName : String
        let image : String
        let username : String
        let userid : Int
        var following : Bool
        
        enum CodingKeys: String, CodingKey {
            case lastName = "last_name"
            case firstName = "first_name"
            case image = "profile_image"
            case username
            case userid = "user_id"
            case following
        }
        
        var name : String {return firstName + " " + lastName}
        
        var profileImage : String {return environment.imageHost + image}
    }
}



