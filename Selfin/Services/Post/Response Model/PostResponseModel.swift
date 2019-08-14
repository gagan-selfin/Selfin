//
//  PostResponseModel.swift
//  Selfin
//
//  Created by Marlon Monroy on 11/22/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation


struct PostDetailResponse:Codable {
    let status:Bool
    let msg:String
    var post:Post
    struct Post:Codable {
        var isNoticationTurnOn:Bool
        let comments_count:Int
        let createdAt:String
        let updated_at:String
        let likedCount:Int
        let superLikeCount:Int
        let id:Int
        let postImage:String
        let scheduledTime:String
        let isActive:Bool
        let isLiked:Bool
        let isSuperLiked:Bool
        let content:String
        let locationDetail:Location
        let tag_user:[TagUser]
        let user:User
        
        enum CodingKeys:String, CodingKey {
            case isNoticationTurnOn = "is_notifying"
            case updated_at = "updated_at"
            case comments_count = "comments_count"
            case createdAt = "created_at"
            case likedCount = "likes_count"
            case superLikeCount = "super_likes_count"
            case id
            case postImage = "post_images"
            case scheduledTime = "scheduled_time"
            case isActive = "is_active"
            case isLiked = "is_liked"
            case isSuperLiked = "is_super_liked"
            case content = "post_content"
            case locationDetail = "location_details"
            case tag_user
            case user
        }
    }
    
    struct Location:Codable {
        let longitude:Double
        let latitude:Double
        let name:String
        enum CodingKeys:String, CodingKey {
            case longitude
            case latitude
            case name = "location_name"
        }
    }
    
    struct UserDetails: Codable {
        let id: Int
        let lastName: String
        let firstName: String
        let following: Bool?
        let profileImage: String
        let username: String
        let isNotificationOn: Bool
        enum CodingKeys: String, CodingKey {
            case id = "user_id"
            case lastName = "last_name"
            case firstName = "first_name"
            case following
            case profileImage = "profile_image"
            case username
            case isNotificationOn = "notification_turned_on"
        }
    }
    
    struct TagUser: Codable {
        let id: Int
        let lastName: String
        let firstName: String
        let following: Bool?
        let profileImage: String
        let username: String
        enum CodingKeys: String, CodingKey {
            case id = "user_id"
            case lastName = "last_name"
            case firstName = "first_name"
            case following
            case profileImage = "profile_image"
            case username
        }
    }
    struct User: Codable {
        let id: Int
        let lastName: String
        let firstName: String
        let following: Bool?
        let profileImage: String
        let username: String
        let isNotificationOn : Bool
        enum CodingKeys: String, CodingKey {
            case id = "user_id"
            case lastName = "last_name"
            case firstName = "first_name"
            case following
            case profileImage = "profile_image"
            case username
            case isNotificationOn = "notification_turned_on"
        }
    }
    
    var postImage: String {
        return environment.imageHost + post.postImage
    }
    
    var userImage: String {
        return environment.imageHost + post.user.profileImage
    }
    
    var time: String {
        if post.createdAt != "" {
            let dateOfEvent = post.createdAt
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            dateFormatter1.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone
            let date1 = dateFormatter1.date(from: dateOfEvent)
            if let dateToShow = date1{return timeAgoSince(dateToShow)}
            return ""
        } else {
            return ""
        }
    }
}
struct PostCommentsResponse:Codable {
    let status:Bool
    let msg:String
    let comment:[Comment]
    
    struct User: Codable {
        let id: Int
        let following: Bool?
        let profileImage: String
        let username: String
        enum CodingKeys: String, CodingKey {
            case id = "user_id"
            case following
            case profileImage = "profile_image"
            case username
        }
        var image: String {
            return environment.imageHost + profileImage
        }
    }
    
    struct Comment:Codable {
        let createdAt:String
        let content:String
        var isLiked:Bool
        var isSuperLiked:Bool
        let id:Int
        let user : User
        enum CodingKeys:String,CodingKey {
            case createdAt = "created_at"
            case content
            case isLiked    = "is_liked"
            case isSuperLiked = "is_super_liked"
            case id
            case user
        }
        
        var time: String {
            if createdAt != "" {
                let dateOfEvent = createdAt
                let dateFormatter1 = DateFormatter()
                dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                dateFormatter1.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone
                let date1 = dateFormatter1.date(from: dateOfEvent)
                if let dateToShow = date1{return timeAgoSince(dateToShow)}
                return ""
            } else {
                return ""
            }
        }
    }
}

struct PostCommentResponse:Codable {
    let status:Bool
    let msg:String
    let comment: PostCommentsResponse.Comment
}

struct PostLikedUsersResponse:Codable {
    let status:Bool
    let msg:String
    let superLikeCount:Int
    let likeCount:Int
    let user:[Liked]
    
    enum CodingKeys:String, CodingKey {
        case status
        case msg
        case superLikeCount = "super_likes_count"
        case likeCount = "likes_count"
        case user = "liked_user"
    }
    
    struct User:Codable {
        let id:Int
        let lastName:String
        let profileImage:String
        let username:String
        let firstName:String
        let following:Bool
        
        enum CodingKeys:String, CodingKey {
            case id = "user_id"
            case lastName = "last_name"
            case profileImage = "profile_image"
            case username
            case firstName = "first_name"
            case following
        }
        
        var userImage:String {
            return environment.imageHost + profileImage
        }
    }
    
    struct Liked:Codable {
        let isLiked:Bool
        let isSuperLiked:Bool
        let user:User
        enum CodingKeys:String, CodingKey {
            case isLiked = "is_liked"
            case isSuperLiked = "is_super_liked"
            case user
        }
    }
    
}

struct PostLikeResponse: Codable {
	var status: Bool
	var message: String
	var likeCount: Int
	
	enum CodingKeys: String, CodingKey {
		case status
		case message = "msg"
		case likeCount = "like_count"
	}
}


