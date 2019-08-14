//
//  PostTaskParams.swift
//  Selfin
//
//  Created by Marlon Monroy on 11/24/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

struct PostTaskParams {
	struct Like:Codable {
		let action:String
	}
	
	struct Comment:Codable {
		let content:String
		enum CodingKeys:String, CodingKey {
			case content = "comment_content"
		}
	}
	
	struct Create:Codable {
		let location:String
		let long:Double
		let lat:Double
		let content:String
		let scheduledTime:String
		let taggedUsers:[Int]
		
		enum CodingKeys:String, CodingKey {
			case location = "location_name"
			case long =    "longtitude"
			case lat =     "latitude"
			case content = "post_content"
			case scheduledTime = "scheduled_time"
			case taggedUsers = "tag_user"
		}
	}
}

