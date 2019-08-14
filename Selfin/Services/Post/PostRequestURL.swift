//
//  PostRequestURL.swift
//  Selfin
//
//  Created by Marlon Monroy on 11/22/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

struct PostRequestURL {
	static let  base = "v1/post/"

    static func location(location:String, page:Int) ->String {
        return "\(base)?location=\(location)&page=\(page)"
    }

    static func hashtag(hashtag:String, page:Int) ->String {
        return "\(base)?hashtag=\(hashtag)&page=\(page)"
    }

	static func details(id:Int) ->String {
		return "\(base)\(id)/"
	}
	
	static func comments(id:Int, page:Int) ->String {
		return "\(base)\(id)/comment/?page=\(page)"
	}
	
	static func likedUsers(id:Int, page:Int) ->String {
		return "\(base)\(id)/liked-users/?page=\(page)"
	}
	
	static func taggedUsers(id:Int, page:Int) ->String {
		return "post/\(id)/tagged-users/?page=\(page)"
	}
	
	static func like(id:Int) -> String {
		return "\(base)\(id)/like/"
	}
	
	static func copyLink(id:Int) -> String {
		return "post/\(id)/copy-link/"
	}
	
    static func report(id:Int, type : String) ->String {
		return "\(base)\(id)/report/?report_type=\(type)"
	}
	
	static func comment(id:Int) ->String {
		return "\(base)\(id)/comment/"
	}
    
    static func likedComment(id:Int, commentId:Int) -> String {
        return "\(base)\(id)/comment/\(commentId)/like/"
    }
    
    static func handlePostNotification(id:Int) -> String {
        return "\(base)\(id)/turn-on-notification/"
    }
    
    // {{host}}v1/post/246/turn-on-notification/

}
