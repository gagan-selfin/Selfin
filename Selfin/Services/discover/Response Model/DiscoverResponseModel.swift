//
//  DiscoverResponseModel.swift
//  Selfin
//
//  Created by Marlon Monroy on 11/28/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

struct DiscoverResponse: Codable {
	struct Post: Codable {
		let id: Int
		let post_images: String
	}
	
	let post: [Post]
	let status:Bool
	let msg:String
}

struct SearchUserResponse:Codable {
	let status:Bool
	let msg:String
	let users:[User]
	
	enum CodingKeys:String, CodingKey {
		case status
		case msg
		case users = "data"
	}
	struct User:Codable {
		let firstName:String
		let id:Int
		let username:String
		let lastName:String
		let profileImage:String
		let following:Bool
		enum CodingKeys:String, CodingKey {
			case firstName = "first_name"
			case id = "user_id"
			case username
			case lastName = "last_name"
			case profileImage = "profile_image"
			case following
		}
	}
}

struct SearchHashtagResponse:Codable {
	
	let status:Bool
	let msg:String
	let hashtags:[HashTag]
	enum CodingKeys:String, CodingKey {
		case status
		case msg
		case hashtags = "data"
	}
	struct HashTag:Codable {
	let name:String
	let postCount:Int
	enum CodingKeys:String, CodingKey {
		case name = "tag"
		case postCount = "post_count"
		}
	}
}
struct SearchLocationResponse:Codable {
	let status:Bool
	let msg:String
	let locations:[Location]
	
	enum CodingKeys:String, CodingKey {
		case status
		case msg
		case locations = "data"
	}
	struct Location:Codable {
		let name:String
		let postCount:Int
		enum CodingKeys:String, CodingKey {
			case name = "location_name"
			case postCount = "post_count"
		}
	}
}
