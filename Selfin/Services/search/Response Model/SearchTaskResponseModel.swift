//
//  SearchTaskResponseModel.swift
//  Selfin
//
//  Created by cis on 06/12/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

//struct Search: Codable  {
//    let status: Bool
//    let msg: String
//    let data : [User]
//
//    struct User: Codable {
//        let image: String
//        let following: Bool
//        let username: String
//        let lastName : String
//        let firstName : String
//        let id : Int
//
//        enum CodingKeys: String, CodingKey {
//            case image = "profie_image"
//            case following
//            case username
//            case lastName = "last_name"
//            case firstName = "first_name"
//            case id = "user_id"
//        }
//        var userImage: String {
//            returnenvironment.imageHost + image
//        }
//    }
//}

struct SearchTags: Codable  {
    let status: Bool
    let msg: String
    let data : [Tags]
    struct Tags: Codable {
        let tag: String
        let postCount: Int
        enum CodingKeys: String, CodingKey {
            case postCount = "post_count"
            case tag
        }
    }
}

struct SearchLocation: Codable  {
    let status: Bool
    let msg: String
    let data : [Location]
    struct Location: Codable {
        let locationName: String
        let postCount: Int
        
        enum CodingKeys: String, CodingKey {
            case locationName = "location_name"
            case postCount = "post_count"
        }
    }
}

