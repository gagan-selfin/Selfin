//
//  User.swift
//  Selfin
//
//  Created by Marlon Monroy on 6/30/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

struct UserDetails: Codable {
    let email: String
    let following: Bool
    let firstName: String
    let lastName: String
    let profileImage: String
    let userId: Int
    let userName: String
    let yourRequestAccepted: Bool
    let youAcceptedRequest: Bool
    let stars: String
    let bio: String
    let mobile: String
    let private_account: Bool
    let push_notification: Bool
    let promotional_notification: Bool
    let is_blocked: Bool

    enum CodingKeys: String, CodingKey {
        case email
        case following
        case firstName = "first_name"
        case lastName = "last_name"
        case profileImage = "profile_image"
        case userId = "user_id"
        case userName = "username"
        case yourRequestAccepted = "request_approved_from_them"
        case youAcceptedRequest = "request_approved_from_you"
        case stars
        case bio
        case mobile
        case private_account
        case push_notification
        case promotional_notification
        case is_blocked
    }
    
    var profile_Image : String {
        return environment.host + profileImage
    }
}

struct followUnfollowUser: Codable {
    let message: String
    let status: Bool
    let isFollowing: Bool
    let isRequestApproved: Bool

    enum CodingKeys: String, CodingKey {
        case message = "msg"
        case status
        case isFollowing = "is_following"
        case isRequestApproved = "request_approved_from_them"
    }
}

struct AllContacts: Codable {
    let message: String
    let status: Bool
    let allContacts: [UserDetails]

    enum CodingKeys: String, CodingKey {
        case message = "msg"
        case status
        case allContacts = "data"
    }
}

struct ProfileResponse : Codable {
	let profile :Profile
	let status:Bool
	let msg:String
}

struct Profile: Codable {
	let posts: Int
	let followingCount: Int
	var user: User
	let followingsImage: [String]
	let followersImage: [String]
	let followersCount: Int
	
	enum CodingKeys: String, CodingKey {
		case posts
		case followersCount = "followers_count"
		case followingCount = "following_count"
		case user
		case followingsImage = "followings_image"
		case followersImage = "followers_image"
	}
    
	struct User:Codable {
        var stars: String
        var profileImage: String
        var bio: String
		var firstName: String
		var lastName: String
        var userName: String
        let following:Bool
        let id : Int
		enum CodingKeys: String, CodingKey {
            case bio
            case lastName = "last_name"
            case firstName = "first_name"
            case userName = "username"
            case id = "user_id"
            case following
            case profileImage = "profile_image"
            case stars
		}
	}
}

struct OthersProfileResponse : Codable {
    let profile :OthersProfile
    let status:Bool
    let msg:String
}
struct OthersProfile: Codable {
    let posts: Int
    let followingCount: Int
    let user: User
    let followingsImage: [String]
    let followersImage: [String]
    let followersCount: Int
    
    enum CodingKeys: String, CodingKey {
        case posts
        case followersCount = "followers_count"
        case followingCount = "following_count"
        case user
        case followingsImage = "followings_image"
        case followersImage = "followers_image"
    }
    
    struct User:Codable {
        let stars: String
        let profileImage: String
        let bio: String
        let firstName: String
        let lastName: String
        let userName: String
        let following:Bool
        let id : Int
        var isBlocked:Bool
        let isRequestedAccepted: Bool
        let isPrivate:Bool
        enum CodingKeys: String, CodingKey {
            case bio
            case lastName = "last_name"
            case firstName = "first_name"
            case userName = "username"
            case id = "user_id"
            case following
            case isBlocked = "is_blocked"
            case profileImage = "profile_image"
            case stars
            case isRequestedAccepted = "request_status_from_them"
            case isPrivate = "is_private"
        }
    }
}


//  MARK: TaggedLikedPostResponse
/// Used to represent tag posts and liked post
/// on user profile screen

struct TaggedLikedPostResponse: Codable {
//    let status: Bool
//    let msg: String
    let post: [Post]
	struct Post: Codable {
		let id: Int
		let post_images: String
        var postImage: String {
            return environment.imageHost + post_images
        }
	}

}

struct FollowingFollowersResponse: Codable {
	let status: Bool
	let msg: String
    let data : [User]
	struct User: Codable {
		let id: Int
		let lastName: String
		let firstName: String
		var following: Bool
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
        var userImage: String {
           return environment.imageHost + profileImage
        }
	}
}

struct AcceptDenyRequest: Codable {
    var user: UserDetails
    var message: String
    var status: Bool
    
    enum CodingKeys: String, CodingKey {
        case user
        case message = "msg"
        case status
    }
}

struct scheduledPostResponse : Codable {
    let message:String
    let status:Bool
    let post : [Post]
    
    enum CodingKeys: String, CodingKey {
        case message = "msg"
        case status
        case post
    }
    
    struct Post : Codable {
        let content:String
        let taggedUser:[FollowingFollowersResponse.User]
        let scheduledTime:String
        let id:Int
        let createdAt:String
        let postImage:String
        var updatedAt:String
        let locationDetails:LocationDetail
        let isActive:Bool
        let user: User

        enum CodingKeys: String, CodingKey {
            case content = "post_content"//post_content
            case taggedUser = "tag_user"//tag_user
            case scheduledTime = "scheduled_time"//scheduled_time
            case id//id
            case createdAt = "created_at"//created_at
            case postImage = "post_images"//post_images
            case updatedAt = "updated_at"//updated_at
            case locationDetails = "location_details"//location_details
            case isActive = "is_active"//is_active
            case user//user
        }
        
        var Image: String {
            return environment.imageHost + postImage
        }
        
        var time: String {
            if updatedAt != "" {
                let dateOfEvent = updatedAt
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
        
        struct LocationDetail: Codable {
            var locationName: String
            enum CodingKeys: String, CodingKey {
                case locationName = "location_name"
            }
        }

        struct User: Codable {
            let username: String
            let userImage: String
            enum CodingKeys: String, CodingKey {
                case userImage = "profile_image"
                case username
            }
            var image : String {
                return environment.imageHost + userImage
            }
        }
    }
}

struct accountSettings :Codable {
    let message:String
    let status:Bool
    let isPrivate:Bool
    enum CodingKeys: String, CodingKey {
        case message = "msg"
        case status
        case isPrivate = "is_private"
    }
}

struct NotificationSettings :Codable {
    let message:String
    let status:Bool
    let pushNotification:Bool
    let promotionalNotification:Bool
    enum CodingKeys: String, CodingKey {
        case message = "msg"
        case status
        case pushNotification = "push_notification"
        case promotionalNotification = "promotional_notification"
    }
}

struct BlockList :Codable {
    let status : Bool
    let message: String
    let users : [User]
    enum CodingKeys: String, CodingKey {
        case message = "msg"
        case status
        case users = "user_list"
    }
    
    struct User : Codable {
        let id : Int
        let username : String
        let firstName: String
        let lastName : String
        let image : String
        enum CodingKeys: String, CodingKey {
            case firstName = "first_name"
            case lastName = "last_name"
            case image = "profile_image"
            case id
            case username
        }
        var name : String {return firstName + " " + lastName }
        var profileImage : String {return environment.imageHost + image}
    }
}














