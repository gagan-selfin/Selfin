//
//  SettingsViewModel.swift
//  Selfin
//
//  Created by cis on 25/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

final class SettingsViewModel {
    
    let userTask = UserTask(username: "")
    weak var delegate:SettingsDelegate?

    func setAccountTypeProcess(isPrivate: Bool) {
        userTask.updateAccountSettings(param: UserTaskParams.accountSettings(isPrivate : isPrivate))
            .done {self.delegate?.didReceived(data: $0)}
            .catch {self.delegate?.didReceived(error: String(describing: $0))}
    }
    
    let auth = AuthTask()
    func performLogout() {
         auth.logout()
        .done {_ in self.delegate?.didReceived(success: true)}
        .catch {self.delegate?.didReceived(error: String(describing: $0.localizedDescription))}
    }
    
   
}
