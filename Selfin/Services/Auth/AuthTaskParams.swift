//
//  AuthTaskParams.swift
//  Selfin
//
//  Created by Marlon Monroy on 11/23/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

struct AuthTaskParams {
	struct Register:Codable {
		let full_name:String
		let email:String
		let password:String
        let deviceToken:String
        let deviceType:String
        let referral_code:String

        enum CodingKeys:String,CodingKey {
            case full_name
            case email
            case password
            case deviceToken = "device_token"
            case deviceType = "device_type"
            case referral_code = "referral_code"

        }
	}
	
	struct Login:Codable {
		let email:String
		let password:String
        let deviceToken:String
        let deviceType:String
        
        enum CodingKeys:String,CodingKey {
            case email
            case password
            case deviceToken = "device_token"
            case deviceType = "device_type"
        }
	}
	
	struct CreateUsername:Codable {
		let username:String
		let new_user_id:String
	}
	
    struct Validity:Codable {
        let hash_token:String
    }

    struct ResetPassword:Codable {
        let email:String
        let new_password:String
    }

	struct ForgotPassword:Codable {
		let email:String
	}
	
	struct OTP:Codable {
		let otp:Int
	}
	
	struct AddPhone:Codable {
		let number:String
		let userId:String
		enum CodingKeys:String,CodingKey {
			case userId = "new_user_id"
			case number = "mobile_number"
		}
	}
    
    struct UpdatePhone:Codable {
        let number:String
        enum CodingKeys:String,CodingKey {
            case number = "mobile_no"
        }
    }
    
    struct ChangePassword:Codable {
        let password:String
        let newPassword:String
        enum CodingKeys:String,CodingKey{
            case password
            case newPassword = "new_password"
        }
    }
}
