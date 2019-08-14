//
//  ChangePasswordViewModel.swift
//  Selfin
//
//  Created by cis on 27/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation
import UIKit

protocol ChangePasswordDelegate : class {
    func didReceived(data:ReusableResponse)
    func didReceived(error:String)
}

final class ChangepasswordViewModel {
    private let task = AuthTask()

    var strValidationMsg = String()
    weak var delegate:ChangePasswordDelegate?

    func validDetails(txtOldPwd: UITextField, txtNewPwd: UITextField, txtConfirmPwd: UITextField) -> String {
        strValidationMsg = ""
        if (txtOldPwd.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            strValidationMsg = Validation.enter_pwd.rawValue
        } else if !isValidPassword(pwd: txtOldPwd.text!) {
            strValidationMsg = Validation.enter_valid_pwd.rawValue
        } else if (txtNewPwd.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            strValidationMsg = Validation.enter_pwd.rawValue
        } else if !isValidPassword(pwd: txtNewPwd.text!) {
            strValidationMsg = Validation.enter_valid_pwd.rawValue
        } else if (txtConfirmPwd.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            strValidationMsg = Validation.enter_pwd.rawValue
        } else if (txtNewPwd.text?.elementsEqual(txtConfirmPwd.text!))! != true {
            strValidationMsg = Validation.pwd_match.rawValue
        }

        return strValidationMsg
    }

    func isValidPassword(pwd: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: pwd)
    }

    func changePasswordProcess(password : String , newPassword : String) {
        task.changePassword(params: AuthTaskParams.ChangePassword(password:password, newPassword:newPassword))
        .done {self.delegate?.didReceived(data: $0)}
            .catch {self.delegate?.didReceived(error: String(describing: $0))}
    }
}
