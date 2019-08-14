//
//  ReusableResponse.swift
//  Selfin
//
//  Created by Marlon Monroy on 11/23/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

struct TokenValidityResponse:Codable {
    let status: Bool
    let message: String
    let email: String

    enum CodingKeys: String, CodingKey {
        case message = "msg"
        case status
        case email
    }
}

struct ReusableResponse:Codable {
	let status: Bool
	let message: String
	
	enum CodingKeys: String, CodingKey {
		case message = "msg"
		case status
	}
}

struct StaticPage: Codable {
	let HTMLPath: String
	let status: Bool
	
    enum CodingKeys: String, CodingKey {
        case HTMLPath = "html_path"
        case status
    }
}
