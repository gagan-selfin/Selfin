//
//  NotificationTaskResponseModel.swift
//  Selfin
//
//  Created by cis on 05/12/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

struct UserNotification: Codable {
    
    struct NotificationType: Codable {
        struct User: Codable {
            var following: Bool
            var profileImage: String
            var userId: Int
            var userName: String
            var isRequestedAcceptedFromThem: Bool
            var isRequestedAcceptedByYou: Bool
            enum CodingKeys: String, CodingKey {
                case following
                case profileImage = "profile_image"
                case userId = "user_id"
                case userName = "username"
                case isRequestedAcceptedFromThem = "request_status_from_them"
                case isRequestedAcceptedByYou = "request_status_from_you"
                
            }
            var profile_Image : String {
                return environment.imageHost + profileImage
            }
        }
        struct TargetUser: Codable {
            var following: Bool
            var profileImage: String
            var userId: Int
            var userName: String
            var isRequestedAcceptedFromThem: Bool
            var isRequestedAcceptedByYou: Bool
            
            enum CodingKeys: String, CodingKey {
                case following
                case profileImage = "profile_image"
                case userId = "user_id"
                case userName = "username"
                case isRequestedAcceptedFromThem = "request_status_from_them"
                case isRequestedAcceptedByYou = "request_status_from_you"
            }
            var profile_Image : String {
                return environment.imageHost + profileImage
            }
        }
        
        var notification_type: String
        var description: String
        let postId: Int
        var notificationContent: String
        var postImage: String
        var id: Int
        var time: String
        var user: User
        var targetUser : TargetUser
        
        enum CodingKeys: String, CodingKey {
            case notification_type
            case time = "created_at"
            case user = "user"
            case notificationContent = "content"
            case description = "msg"
            case postImage = "post_image"
            case id
            case postId = "post_id"
            case targetUser = "target_user"
        }
        
        var post_Image:String {
            return environment.imageHost + postImage
        }
        
        var timeAgo:String  {
            if time != "" {
                let dateOfEvent = time
                let dateFormatter1 = DateFormatter()
                dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                dateFormatter1.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone
                let date1 = dateFormatter1.date(from: dateOfEvent)
                if let dateToShow = date1{return timeAgoSince(dateToShow)}
                return ""
            }
            return ""
        }
    }
    
    var notification: [NotificationType]
    var message: String
    var status: Bool
    
    enum CodingKeys: String, CodingKey {
        case notification
        case message = "msg"
        case status
    }
}

struct AcceptResquestResponse: Codable {
    
    let message:String
    let status:Bool
    let notification:Notification

    enum CodingKeys: String, CodingKey {
        case message = "msg"
        case status
        case notification
    }
    
    struct Notification : Codable {
        let id:Int
        let notificationType:String
        let createdAt:String
        let content:String
        let message:String
        let postImage:String
        let user:User

        enum CodingKeys: String, CodingKey {
            case id
            case notificationType = "notification_type"
            case createdAt = "created_at"
            case content
            case message = "msg"
            case postImage = "post_image"
            case user

        }
    }

    struct User : Codable {
        let id:Int
        let username:String
        let profileImage:String
        let following:Bool
        
        enum CodingKeys: String, CodingKey {
            case id = "user_id"
            case username
            case profileImage = "profile_image"
            case following
        }
    }
    
    var image:String {
        return environment.imageHost + notification.postImage
    }
    
    var time:String  {
        if notification.createdAt != "" {
            let dateOfEvent = notification.createdAt
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            dateFormatter1.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone
            let date1 = dateFormatter1.date(from: dateOfEvent)
            if let dateToShow = date1{return timeAgoSince(dateToShow)}
            return ""
        }
        return ""
    }
}
