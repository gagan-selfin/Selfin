//
//  SubAccountsViewModel.swift
//  Selfin
//
//  Created by cis on 21/02/2019.
//  Copyright © 2019 Selfin. All rights reserved.
//

import Foundation

final class SubAccountsViewModel {
    weak var delegate:SubAccountsResponseDelegate?
    let task = SelfinTask()
    
    func listOfSubSelfinAccounts() {
        task.fetchListOfSubSelfinAccounts()
            .done{self.delegate?.didReceive(response: .accounts(data: $0))}
            .catch{self.delegate?.didReceive(response: .error(message: $0.localizedDescription))}
    }
    
    func followAllSubAccounts() {
        task.followAllSubSelfinAccount()
            .done{self.delegate?.didReceive(response: .followAll(data: $0))}
            .catch{self.delegate?.didReceive(response: .error(message: $0.localizedDescription))}
    }
    
    let user = UserTask(username: "")
    func followSubAccount(username: String) {
        user.followUnfollow(with: UserTaskParams.FollowUnfollowRequest(username:username))
            .done { self.delegate?.didReceive(response: .follow(data: $0, username: username))}
            .catch { self.delegate?.didReceive(response: .error(message: $0.localizedDescription))}
    }
}
