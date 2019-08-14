//
//  CreateUsername.swift
//  Selfin
//
//  Created by cis on 13/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation
import UIKit

protocol CreateUsernameDelegate : class {
    func didCreateUser(username: Username)
    func didReceived(err:String)
}

final class CreateUsernameViewModel {
    private let auth = AuthTask()
    var strValidationMsg = String()
    weak var delegate:CreateUsernameDelegate?
 
    func createUsername(username: String?) {
      guard let username = username else {
         delegate?.didReceived(err: "Please enter a valid username")
         return
      }
      guard let id = UserDefaults.standard.object(forKey: Constants.new_user_id.rawValue) as? Int else {
          delegate?.didReceived(err: "Please enter a valid username")
         return
      }
      
      if (username.trimmingCharacters(in: .whitespaces)).rangeOfCharacter(from: NSCharacterSet.whitespaces) != nil {
        delegate?.didReceived(err: "Username Should not contain space in between.")
        return
      }

        auth.createUsername(params: AuthTaskParams.CreateUsername(username: username.trimmingCharacters(in: .whitespaces), new_user_id: String(id)))
        .done {self.saveUser(username:$0)}
        .catch {
         self.delegate?.didReceived(err: String(describing: $0))
      }
    }
   
   func saveUser(username: Username) {
      let authToken = AuthToken()
      authToken.token = "Token" + " " + username.token
      let data = username.user
      UserStore.save(token: authToken)
      UserDefaults.standard.removeObject(forKey: Constants.show_screen.rawValue)
      let createdUser = User()
      createdUser.bio  = data.bio
      createdUser.userName = data.userName
      createdUser.email = data.email
      createdUser.firstName = data.firstName
      createdUser.lastName = data.lastName
      createdUser.id = data.userId
      createdUser.isPrivate = data.private_account
      createdUser.isPromotional = data.promotional_notification
      createdUser.isPush = data.push_notification
      createdUser.profileImage = data.profileImage
      createdUser.fullname = data.firstName + " " + data.lastName
      UserStore.save(user: createdUser)
      self.delegate?.didCreateUser(username:username)
   }
}
