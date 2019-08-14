////
////  Feeds.swift
////  Selfin
////
////  Created by Marlon Monroy on 6/30/18.
////  Copyright © 2018 Selfin. All rights reserved.
////
//
import Foundation

struct FeedResponse:Codable {
    let status:Bool
    let msg:String
    let post:[Post]

    struct Post:Codable {
        let id:Int
        let images:String
        let createdAt:String
        let isLiked:Bool
        let isSuperLiked:Bool
        let user:User
        let scheduledTime:String
        let location:Location

        enum CodingKeys:String, CodingKey {
            case id
            case images
            case createdAt
            case isLiked
            case isSuperLiked
            case user
            case scheduledTime
            case location
        }
    }

    struct Location:Codable {
        let name:String
        enum CodingKyes:String, CodingKey {
            case name  = "location_name"
        }
    }
    struct User:Codable {
        let image:String
        let following:Bool
        let id:Int
        let username:String

        enum CodingKeys:String, CodingKey {
            case image = "profile_image"
            case following
            case id
            case username
        }
    }
}

struct Feed: Codable {
    var commentsCount: Int
    var createdAt: String
    var scheduled_time: String
    var postId: Int
    var isActive: Bool
    var likeCount: Int
    var user: UserDetails
    var locationDetails: LocationDetails
    var postText: String
    var postImages: String
    var superLikesCount: Int
    var isLiked: Bool
    var isSuperLike: Bool
    // var tags:[tags]
    var tags: [String] = [String]()
    var tag_users = [UserDetails]()

    enum CodingKeys: String, CodingKey {
        case commentsCount = "comments_count"
        case createdAt = "created_at"
        case scheduled_time
        case postId = "id"
        case isActive = "is_active"
        case likeCount = "likes_count"
        case locationDetails = "location_details"
        case postText = "post_content"
        case postImages = "post_images"
        case user
        case superLikesCount = "super_likes_count"
        case isLiked = "is_liked"
        case isSuperLike = "is_super_liked"
        case tags
        // case tags
        case tag_users
    }

    struct LocationDetails: Codable {
        var latitude: Float
        var name: String
        var longitude: Float
        enum CodingKeys: String, CodingKey {
            case latitude
            case name = "location_name"
            case longitude = "longtitude"
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        commentsCount = try container.decode(Int.self, forKey: .commentsCount)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        scheduled_time = try container.decode(String.self, forKey: .scheduled_time)
        postId = try container.decode(Int.self, forKey: .postId)
        isActive = try container.decode(Bool.self, forKey: .isActive)
        likeCount = try container.decode(Int.self, forKey: .likeCount)
        user = try container.decode(UserDetails.self, forKey: .user)
        locationDetails = try container.decode(LocationDetails.self, forKey: .locationDetails)
        postText = try container.decode(String.self, forKey: .postText)
        postImages = try container.decode(String.self, forKey: .postImages)
        superLikesCount = try container.decode(Int.self, forKey: .superLikesCount)
        isLiked = try container.decode(Bool.self, forKey: .isLiked)
        isSuperLike = try container.decode(Bool.self, forKey: .isSuperLike)
    }

    init(commentsCount: Int, createdAt: String, scheduled_time: String, postId: Int, isActive: Bool, likeCount: Int, user: UserDetails, locationDetails: LocationDetails, postText: String, postImages: String, superLikesCount: Int, isLiked: Bool,
         isSuperLike: Bool) {
        self.commentsCount = commentsCount
        self.createdAt = createdAt
        self.scheduled_time = scheduled_time
        self.postId = postId
        self.isActive = isActive
        self.likeCount = likeCount
        self.user = user
        self.locationDetails = locationDetails
        self.postText = postText
        self.postImages = postImages
        self.superLikesCount = superLikesCount
        self.isLiked = isLiked
        self.isSuperLike = isSuperLike
    }
    var time:String  {
        if createdAt != "" {
            let dateOfEvent = createdAt
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            dateFormatter1.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone
            let date1 = dateFormatter1.date(from: dateOfEvent)
            return timeAgoSince(date1!)
        }
        return ""
    }
}
