//
//  AuthRequestURL.swift
//  Selfin
//
//  Created by Marlon Monroy on 11/23/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

struct AuthRequestURL {
	static let register = 		 "v1/auth/signup/"
	static let login =  			 "auth/login/"
	static let username = 		 "v1/auth/set-username/"
	static let logout = 			 "auth/logout/"
	static let changePassword =  "v1/user/change-password/"
	static let forgotPassword = "v1/auth/forgot-password/"
	static let verifyotp = 		 "v1/auth/verify-otp/"
	static let OTP    = 			 "v1/auth/generate-otp/"
    static let updatePhone =          "v1/user/profile/new-number/"
    static let verifyotpToUpdateNumber =    "v1/user/profile/verify-new-number/"
    static let checkTokenValidity =    "v1/auth/verify-hash-token/"
    static let resetPassword =    "v1/auth/reset-password/"

}
