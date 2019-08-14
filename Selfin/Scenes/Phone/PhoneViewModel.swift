//
//  PhoneViewModel.swift
//  Selfin
//
//  Created by cis on 13/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation
import UIKit

protocol RegisterPhoneDelegate : class {
    func didReceived(phone:OTP)
    func didReceived(error msg : String)
}

final class PhoneViewModel {
    let auth = AuthTask()
    weak var delegate : RegisterPhoneDelegate?
    var strValidationMsg = String()

    func validatePhoneDetails(txtPhoneNumber: UITextField) -> String {
        strValidationMsg = ""

        if (txtPhoneNumber.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            strValidationMsg = Validation.enter_phone_number.rawValue
        }

        return strValidationMsg
    }
    
    func registerPhoneNumber(mobileNumber : String, id : String) {
        auth.addPhone(params:AuthTaskParams.AddPhone(number: mobileNumber, userId : id))
            .done {self.delegate?.didReceived(phone: $0)}
            .catch{ (err) in
                self.delegate?.didReceived(error: err.localizedDescription)
        }
    }
    
    func updatePhoneNumber(mobileNumber : String) {
        auth.updatePhone(params: AuthTaskParams.UpdatePhone(number:mobileNumber))
            .done{self.delegate?.didReceived(phone: $0)}
            .catch{ (err) in
                self.delegate?.didReceived(error: err as! String)
        }
    }
}
