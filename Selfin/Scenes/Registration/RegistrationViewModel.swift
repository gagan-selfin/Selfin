//
//  RegistrationViewModel.swift
//  Selfin
//
//  Created by Marlon Monroy on 8/19/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation
import UIKit

protocol RegistrationControllDelegate : class {
     func didReceived(login:Login)
     func didReceived(registration:Registration)
     func didReceived(error msg : String)
}

final class RegistrationViewModel {
    private let auth = AuthTask()
    weak var delegate : RegistrationControllDelegate?
    var strValidationMsg = String()

    func validRegistrationDetails(txtUserName: UITextField, txtEmail: UITextField, txtPwd: UITextField) -> String {
        strValidationMsg = ""

        if (txtUserName.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            strValidationMsg = Validation.enter_fullname.rawValue
        } else if (txtEmail.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            strValidationMsg = Validation.enter_email.rawValue
        } else if !emailAddressValidation(emailAddress: txtEmail.text!) {
            strValidationMsg = Validation.enter_valid_email.rawValue
        } else if (txtPwd.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            strValidationMsg = Validation.enter_pwd.rawValue
        } else if !isValidPassword(pwd: txtPwd.text!) {
            strValidationMsg = Validation.enter_valid_pwd.rawValue
        }

        return strValidationMsg
    }

    func validLoginDetails(txtEmail: UITextField, txtPwd: UITextField) -> String {
        strValidationMsg = ""
        if (txtEmail.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            strValidationMsg = Validation.enter_email.rawValue
        } else if !emailAddressValidation(emailAddress: txtEmail.text!) {
            strValidationMsg = Validation.enter_valid_email.rawValue
        } else if (txtPwd.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            strValidationMsg = Validation.enter_pwd.rawValue
        }
        return strValidationMsg
    }

    func isValidPassword(pwd: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: pwd)
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
	
    func login(email:String, password:String, deviceToken: String, deviceType : String) {
        auth.login(params: AuthTaskParams.Login(email:email,  password:password, deviceToken:deviceToken, deviceType:deviceType))
            .done {self.delegate?.didReceived(login: $0)}
            .catch {
                 self.delegate?.didReceived(error: String(describing: $0))

        }
    }
    
    func registrationProcess(full_name : String, email:String, password:String, deviceToken: String, deviceType : String, referral_code: String){
        auth.registration(params: AuthTaskParams.Register(full_name:full_name, email:email, password:password, deviceToken:deviceToken, deviceType:deviceType, referral_code:referral_code))
            .done {self.delegate?.didReceived(registration: $0)}
            .catch {
                self.delegate?.didReceived(error: String(describing: $0))
        }
    }
    
}
