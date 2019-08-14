//
//  UsertaskParams.swift
//  Selfin
//
//  Created by Marlon Monroy on 11/22/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

struct UserTaskParams {
    struct EditScheduleTime:Codable {
        let scheduled_time:String
        enum CodingKeys: String, CodingKey {
            case scheduled_time
        }
    }
	struct AcceptDenyFollowRequest:Codable {
		let username:String
        let id:Int
        enum CodingKeys: String, CodingKey {
            case username
            case id = "notification_id"
        }
	}
    
    struct FollowUnfollowRequest:Codable {
        let username:String
    }
    
    struct EditScheduledPost: Codable {
        //        image
        //        multipart
       // let locationName:String
        //let longitude:Float
        //let latitude:Float
        let content:String
        let scheduleTime:String
        let taggedUsers:[Int]
        
        enum CodingKeys: String, CodingKey {
           // case locationName = "location_name"
           // case longitude = "longtitude"
           // case latitude
            case content = "post_content"
            case scheduleTime = "scheduled_time"
            case taggedUsers = "tag_user"
        }
    }
    
    struct  accountSettings:Codable {
        let isPrivate:Bool
        enum CodingKeys: String, CodingKey {
            case isPrivate = "is_private"
        }
    }
    
    struct  notificationSettings:Codable {
        let isPromotionalNotification:Bool
        let isPushNotification:Bool
        enum CodingKeys: String, CodingKey {
            case isPromotionalNotification = "promotional_notification"
            case isPushNotification = "push_notification"
        }
    }
    
}
