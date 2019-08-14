//
//  AuthTask.swift
//  Selfin
//
//  Created by Marlon Monroy on 11/23/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation
import PromiseKit

enum AuthRequest:RequestRepresentable {
	case registration(params:AuthTaskParams.Register)
	case login(params:AuthTaskParams.Login)
	case createUsername(params:AuthTaskParams.CreateUsername)
	case logout
    case changePassword(params:AuthTaskParams.ChangePassword)
	case forgotPassword(params:AuthTaskParams.ForgotPassword)
    case resetPassword(params:AuthTaskParams.ResetPassword)
    case tokenValidity(params:AuthTaskParams.Validity)
	case addPhone(params:AuthTaskParams.AddPhone)
    case updatePhone(params:AuthTaskParams.UpdatePhone)
	case otp(params:AuthTaskParams.OTP)
	case resendOTP
    case otpToUpdateNumber(params:AuthTaskParams.OTP)
    case resendOTPToUpdateNumber
}

extension AuthRequest {
	var method: HTTPMethod {
		switch self {
		case .logout, .resendOTP, .resendOTPToUpdateNumber: return .get
		default: return .post
		}
	}
	
	var endpoint: String {
		switch self {
		case .registration:
			return AuthRequestURL.register
		case .login:
			return AuthRequestURL.login
		case .createUsername:
			return AuthRequestURL.username
		case .logout:
			return AuthRequestURL.logout
		case .changePassword:
			return AuthRequestURL.changePassword
		case .forgotPassword:
			return AuthRequestURL.forgotPassword
		case .addPhone:
			return AuthRequestURL.OTP
		case .resendOTP:
			return AuthRequestURL.OTP
		case .otp:
			return AuthRequestURL.verifyotp
        case .updatePhone:
            return AuthRequestURL.updatePhone
        case .otpToUpdateNumber:
            return AuthRequestURL.verifyotpToUpdateNumber
        case .resendOTPToUpdateNumber:
            return AuthRequestURL.updatePhone
        case .tokenValidity:
            return AuthRequestURL.checkTokenValidity
        case .resetPassword:
            return AuthRequestURL.resetPassword
        }
	}
	
	var parameters: Parameters {
		switch self {
        case let .createUsername(params):
            return .body(data: encodeBody(data: params))
            
		case let .registration(params):
			return .body(data: encodeBody(data: params))
			
		case let .login(params):
			return .body(data:encodeBody(data: params))
			
		case let .forgotPassword(params):
			return .body(data:encodeBody(data: params))
       
        case let .resetPassword(params):
            return .body(data:encodeBody(data: params))

        case let .tokenValidity(params):
            return .body(data:encodeBody(data: params))
			
		case let .addPhone(params):
			return .body(data:encodeBody(data: params))
			
		case let .otp(params):
			return .body(data:encodeBody(data: params))
            
        case let .changePassword(params):
            return .body(data:encodeBody(data: params))
            
        case let .updatePhone(params):
            return .body(data:encodeBody(data: params))

        case let .otpToUpdateNumber(params):
            return .body(data:encodeBody(data: params))

		default:
			return .none
		}
	}

}

final class AuthTask {
	let dispatcher = SessionDispatcher()
	
	func registration(params:AuthTaskParams.Register) -> Promise<Registration> {
		return dispatcher.execute(requst: AuthRequest.registration(params: params), modeling: Registration.self)
	}
	
	func login(params:AuthTaskParams.Login) ->Promise<Login> {
		return dispatcher.execute(requst: AuthRequest.login(params: params), modeling: Login.self)
	}
	
	func createUsername(params:AuthTaskParams.CreateUsername) ->Promise<Username> {
		return dispatcher.execute(requst:  AuthRequest.createUsername(params: params), modeling: Username.self)
	}
	
	func logout() ->Promise<ReusableResponse> {
		return dispatcher.execute(requst: AuthRequest.logout, modeling: ReusableResponse.self)
	}
	
    func changePassword(params:AuthTaskParams.ChangePassword)->Promise<ReusableResponse> {
        return dispatcher.execute(requst: AuthRequest.changePassword(params: params), modeling: ReusableResponse.self)
	}
	
    func tokenValidity(params:AuthTaskParams.Validity) ->Promise<TokenValidityResponse>
    {
        return dispatcher.execute(requst: AuthRequest.tokenValidity(params: params), modeling: TokenValidityResponse.self)
    }

    func resetPassword(params:AuthTaskParams.ResetPassword) ->Promise<ReusableResponse>  {
        return dispatcher.execute(requst: AuthRequest.resetPassword(params: params), modeling: ReusableResponse.self)
    }

	func forgotPassword(params:AuthTaskParams.ForgotPassword) ->Promise<ReusableResponse>  {
		return dispatcher.execute(requst: AuthRequest.forgotPassword(params: params), modeling: ReusableResponse.self)
	}
    
	func addPhone(params:AuthTaskParams.AddPhone) -> Promise<OTP>  {
		return dispatcher.execute(requst: AuthRequest.addPhone(params: params), modeling: OTP.self)
	}
    
    func updatePhone(params:AuthTaskParams.UpdatePhone) -> Promise<OTP>  {
        return dispatcher.execute(requst: AuthRequest.updatePhone(params: params), modeling: OTP.self)
    }

	
	func resendOTP() -> Promise<VerifyOTP> {
		return dispatcher.execute(requst: AuthRequest.resendOTP, modeling: VerifyOTP.self)
	}
    
    func resendOtpToUpdateNumber () -> Promise<OTP> {
        return dispatcher.execute(requst: AuthRequest.resendOTPToUpdateNumber, modeling: OTP.self)
    }
	
	func verifyOTP(params:AuthTaskParams.OTP) -> Promise<VerifyOTP>  {
		return dispatcher.execute(requst: AuthRequest.otp(params: params), modeling: VerifyOTP.self)
	}
    
    func verifyOTPToUpdateNumber(params:AuthTaskParams.OTP) -> Promise<ReusableResponse>
    {
        return dispatcher.execute(requst: AuthRequest.otpToUpdateNumber(params: params), modeling: ReusableResponse.self)
    }
}
