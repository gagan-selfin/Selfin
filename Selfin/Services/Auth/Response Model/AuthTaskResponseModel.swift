//
//  AuthTaskResponseModel.swift
//  Selfin
//
//  Created by Marlon Monroy on 11/23/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

struct Registration: Codable {
	var username: String
	var status: Bool
	var email: String
	var msg: String
	var new_user_id: Int
	var user_active: Bool
}

struct Login: Codable {
	var user: UserDetails
	var mobileVerified: Bool
	var msg: String
	var isPrivate: Bool
	var status: Bool
	var token: String
	var userActive: Bool
	
	enum CodingKeys: String, CodingKey {
		case user
		case mobileVerified = "mobile_number_verified"
		case msg
		case isPrivate = "private_account"
		case status
		case token
		case userActive = "user_active"
	}
}

struct VerifyOTP: Codable {
    var new_user_id: Int
    var msg: String
    var status: Bool
}

struct OTP: Codable {
	var msg: String
	var status: Bool
	var otp: String
}

struct Username: Codable {
    var user_active: Bool
    var msg: String
    var status: Bool
    var token: String
    var user: UserDetails
}

struct OnboardingItem {
    let imageName: String
    let title: String
    let message: String
}

