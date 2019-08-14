//
//  NewPasswordViewModel.swift
//  Selfin
//
//  Created by cis on 17/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation
import UIKit

final class NewPasswordViewModel {
    private let auth = AuthTask()
    var isSuccess: ((Bool, ReusableResponse?) -> Void)?
    var strValidationMsg = String()

    func resetPassword(email:String,password:String) {
        auth.resetPassword(params: AuthTaskParams.ResetPassword(email:email,new_password:password))
            .done { data in
                self.isSuccess!(true, data)
            }.catch { _ in
                self.isSuccess!(false, nil)
        }
    }
    
    func validDetails(txtNewPwd: UITextField, txtConfirmPwd: UITextField) -> String
    {
        strValidationMsg = ""
        if (txtNewPwd.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
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
}
