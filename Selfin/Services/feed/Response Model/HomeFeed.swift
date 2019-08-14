//
//  HomeFeedItem.swift
//  Selfin
//
//  Created by Marlon Monroy on 11/7/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

struct HomeFeed: Codable {
    
    let status: Bool
    let msg: String
    var post: [Post]
    
    struct Post: Codable {
        struct User: Codable {
            let profile_image: String
            let following: Bool
            let username: String
            let user_id: Int
            enum CodingKeys:String, CodingKey {
                case profile_image
                case following
                case username
                case user_id
            }
            var userImage: String {
                return environment.imageHost + profile_image
            }
        }
        
        var user: User
        var is_super_liked: Bool
        let scheduled_time: String?
        let post_images: String
        let id: Int
        let location_details: FeedLocationDetails
        var is_liked: Bool
        let created_at: String
        var is_notifying : Bool
        
        var time: String {
            if created_at != "" {
                let dateOfEvent = created_at
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
        
        var postImage: String {
            return environment.imageHost + post_images
        }
    }
}

struct FeedLocationDetails: Codable {
    let location_name: String
}


struct SelfFeed: Codable {
    let status: Bool
    let msg: String
    let post: [Post]
    
    struct Post: Codable {
        let is_super_liked: Bool
        let scheduled_time: String?
        let post_images: String
        let id: Int
        let location_details: FeedLocationDetails
        let is_liked: Bool
        let created_at: String
        
        var time: String {
            if created_at != "" {
                let dateOfEvent = created_at
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
        
        var postImage: String {
            return environment.imageHost + post_images
        }
    }
}

