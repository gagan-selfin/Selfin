//
//  ReferFriendsViewModel.swift
//  Selfin
//
//  Created by cis on 31/10/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

protocol ReferFriendsDelegate : class {
    func didReceived(data:ReferralCode)
    func didReceived(error:String)

}
final class ReferFriendsViewModel {

    let task = SelfinTask ()
    var strValidationMsg = String()
    weak var delegate:ReferFriendsDelegate?

    func referFriendProcess(code:String, contacts:[String]) {
        
        task.referralCode(param: SelfinTaskParam.referralCode(contacts:contacts, code:code))
            .done{self.delegate?.didReceived(data: $0)}
            .catch{self.delegate?.didReceived(error: String(describing: $0))}
    }
}
