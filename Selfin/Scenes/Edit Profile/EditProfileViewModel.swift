//
//  EditProfileViewModel.swift
//  Selfin
//
//  Created by cis on 24/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation
import UIKit
final class EditProfileViewModel {
    private let task = ProfileTask()

    var strValidationMsg = String()
    weak var delegate:EditProfileAPIDelegate?

    func validDetails(txtName: UITextField, txtUserName: UITextField, txtStatus: UITextField, txtEmail: UITextField) -> String {
        strValidationMsg = ""
        if (txtName.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            strValidationMsg = Validation.enter_fullname.rawValue
        } else if (txtUserName.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            strValidationMsg = Validation.enter_username.rawValue
        } else if (txtStatus.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            strValidationMsg = Validation.enter_status.rawValue
        } else if (txtEmail.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
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
    
    func editProfileProcess(name:String, username:String, email:String, bio:String) {
        task.editUsersProfile(param: ProfileTaskParam.editProfile(name:name, username:username, email:email, bio:bio))
       .done {
        self.delegate?.didReceived(response: .success(data: $0))
        
            }
            .catch
            {self.delegate?.didReceived(response: .error(err: String(describing: $0)))
                
        }
    }

    func changeAvatarProcess(avatarImage: UIImage) {
        task.avatar(avatarImage: avatarImage)
            .done {_ in}
            .catch { _ in}
    }
}
