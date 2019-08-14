//
//  TagListAction.swift
//  Selfin
//
//  Created by cis on 15/12/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

protocol TagListCoordinatorDelegate : class {
    func taggedUserMove(users: [FollowingFollowersResponse.User])
}

protocol TagListViewControllerDelegate {
    func taggedUser(Users: [FollowingFollowersResponse.User])
}

protocol tagViewModelDelegate : class  {
    func didReceived(data:[FollowingFollowersResponse.User])
    func didReceived(error msg:String)
}

enum SearchHeaderSize : Float {
    case SearchViewHeight = 75.0
    case TaggedUserViewHeight = 60.0
    case headerSize = 135.0
    case initailCollectionHeight = 0.0
}

