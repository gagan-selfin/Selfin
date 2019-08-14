//
//  FollowersAndFollowingListViewModel.swift
//  Selfin
//
//  Created by cis on 28/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

enum userFollowerCategories : String {
    case follower
    case following 
}

protocol SearchFollowersDelegate :class {
    func didReceived(type :UserRequestURL.List, result:FollowingFollowersResponse)
    func didReceived(error msg : String)
}

final class FollowersAndFollowingListViewModel {
    var username = String()
    lazy var task = {
        return UserTask(username: self.username)
    }()
    weak var delegate:SearchFollowersDelegate?
    
    func performSearch(type : UserRequestURL.List, strSearch:String, page : Int)  {
        task.followersFollowing(listType: type, search: strSearch, page: page)
            .done  { self.delegate?.didReceived(type: type, result: $0)}
            .catch { self.delegate?.didReceived(error: String(describing: $0)) }
    }
}

