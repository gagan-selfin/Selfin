//
//  OTPViewModel.swift
//  Selfin
//
//  Created by cis on 13/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

import PinCodeTextField


protocol verifyOTPDelegate: class {
    func didReceived(data:VerifyOTP)
    func didReceived(err:String)
    func didReceivedResendOtpData(data:VerifyOTP)
    func didReceivedUpdateNumber(data:ReusableResponse)
}
final class OTPViewModel {
	
	let authTask = AuthTask()
    var isValid = true
    var strValidationMsg = String()
    weak var delegate:verifyOTPDelegate?

    func validateOTP(txtOTP: UITextField) -> String {
        strValidationMsg = ""
        if txtOTP.text == nil {
            strValidationMsg = Validation.enter_Pin.rawValue
        } else if (txtOTP.text?.count)! < 5 {
            strValidationMsg = Validation.enter_FiveDigit_Pin.rawValue
        }
        return strValidationMsg
    }

    func resendOTPProcess() {
			authTask.resendOTP()
			.done{self.delegate?.didReceivedResendOtpData(data: $0)}
				
                .catch{self.delegate?.didReceived(err: String(describing: $0))}
    }

	func verifyOTPProcess(pin:Int) {
		authTask.verifyOTP(params: AuthTaskParams.OTP(otp:pin))
			.done{self.delegate?.didReceived(data: $0)}
			.catch{self.delegate?.didReceived(err: String(describing: $0))}
	}
    
    func verifyOTPToUpdatePhoneNumber(pin:Int) {
        authTask.verifyOTPToUpdateNumber(params: AuthTaskParams.OTP(otp:pin))
            .done{self.delegate?.didReceivedUpdateNumber(data: $0)}
            .catch{self.delegate?.didReceived(err: String(describing: $0))}
    }
    
    func resendOTPToUpdateNumber() {
        authTask.resendOTP()
            .done{self.delegate?.didReceivedResendOtpData(data: $0)}
            
            .catch{self.delegate?.didReceived(err: String(describing: $0))}
    }
}
