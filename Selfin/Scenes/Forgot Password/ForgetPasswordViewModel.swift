//
//  ForgetPasswordViewModel.swift
//  Selfin
//
//  Created by cis on 17/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation
import UIKit

final class ForgotpasswordViewModel {
    private let auth = AuthTask()
    var strValidationMsg = String()

    var isSuccess: ((Bool, ReusableResponse?) -> Void)?

    func validEmailDetails(txtEmail: UITextField) -> String {
        strValidationMsg = ""
        if (txtEmail.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            strValidationMsg = Validation.enter_email.rawValue
        } else if !emailAddressValidation(emailAddress: txtEmail.text!) {
            strValidationMsg = Validation.enter_valid_email.rawValue
        }
        return strValidationMsg
    }

    func emailAddressValidation(emailAddress: String) -> Bool {
        let emailRegex = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" +
            "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
            "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        return emailTest.evaluate(with: emailAddress)
    }

    func forgotPasswordProcess(email : String) {
        auth.forgotPassword(params: AuthTaskParams.ForgotPassword(email : email))
        .done { data in
            self.isSuccess!(true, data)
        }.catch { data in
            print(data)
            self.isSuccess!(false, nil)
        }
    }
}
