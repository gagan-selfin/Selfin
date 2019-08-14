
//
//  BlockedUsers.swift
//  Selfin
//
//  Created by cis on 04/02/2019.
//  Copyright © 2019 Selfin. All rights reserved.
//

import Foundation

protocol BlockedUsersViewModelDelegate : class  {
    func didReceived(unblock: ReusableResponse, index :Int)
    func didReceived(data:[BlockList.User])
    func didReceived(error msg:String)
}

final class BlockedUsersViewModel {
    fileprivate let task = UserTask(username: "")
    weak var controller : BlockedUsersViewModelDelegate?
    
    func fetchBlockedUsersList(page : Int) {
        task.showBlockUsers(page : page)
            .done {self.controller?.didReceived(data: $0.users)}
            .catch { self.controller?.didReceived(error: String(describing: $0.localizedDescription)) }
    }
    
    func blockUnblock(username : String, index : Int)  {
        task.blockUnblockUser(param: UserTaskParams.FollowUnfollowRequest(username : username))
            .done {self.controller?.didReceived(unblock: $0, index: index)}
            .catch { self.controller?.didReceived(error: String(describing: $0)) }
    }
}
