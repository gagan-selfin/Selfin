//
//  UserRequestURL.swift
//  Selfin
//
//  Created by Marlon Monroy on 11/22/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation


struct UserRequestURL {
	enum List:String { case following; case follower}
	static let base = "v1/user/"
	
	static func othersProfile(username:String) -> String {
		return "\(base)\(username)/profile/"
	}
    
    static func profile() -> String {
        return "\(base)profile/"
    }

    static func posts(username:String,page:Int) -> String {
		return "\(base)\(username)/posts/?page=\(page)"
	}
    
    static func likedPost(username:String,page:Int) -> String {
		return "\(base)\(username)/liked-posts/?page=\(page)"
	}
    
    static func taggedPosts(username:String,page:Int) -> String {
		return "\(base)\(username)/tagged-posts/?page=\(page)"
	}
	
    static func followingFollowers(username:String,list:List, search:String,page:Int) -> String{
		return "\(base)\(username)/search/?\(list.rawValue)=\(search)&page=\(page)"
	}
    
    static func FollowUnfollow() -> String {
        return "\(base)follow-unfollow/"
    }
  
	static func accept()-> String {
		return "\(base)accept-request/"
	}
    
	static func deny() -> String {
		return "\(base)deny-request/"
	}
    
    static func shareNow(id:Int) -> String {
        return "\(base)scheduled-post/\(id)/share-now/"
    }

    static func scheduledPost(page:Int) -> String {
        return "\(base)scheduled-post/?page=\(page)"
    }
    
    static func deleteSchedulePost(id:Int) -> String {
        return "\(base)scheduled-post/\(id)/"
    }
    
    static func editSchedulePost(id:Int) -> String {
        return "\(base)scheduled-post/\(id)/"
    }
    
    static func retriveSchedulePost(id:Int) -> String {
        return "\(base)scheduled-post/\(id)/"
    }
    
    static func blockUnblock() -> String {
        return "\(base)blocked-users/"
    }
    
    static func blockedUserList(page : Int) -> String {
        return "\(base)blocked-users/?page=\(page)"
    }
    
    static func turnOnOffNotifications() -> String {
        return "\(base)turn-on-notifications/"
    }
    
    static func accoutSettings(username:String) -> String {
        return "user/\(username)/account-setting/"
    }
    
    static func notificationSettings(username:String) -> String {
        return "user/\(username)/notification-setting/"
    }

}
