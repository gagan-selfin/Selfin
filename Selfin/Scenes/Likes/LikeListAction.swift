//
//  LikeListAction.swift
//  Selfin
//
//  Created by cis on 29/11/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation
protocol LikeTableDelegate: class
{func setData (page:Int)}

protocol LikeViewDelegate : class {
    func didReceived(data:PostLikedUsersResponse)
    func didReceived(error msg:String)
}

protocol LikesViewControllerDelegate: class
{func moveToPreviousController()}

protocol LikesDelegate: class {
    func showProfile(username:String)
}

protocol LikesCoordinatorDelegate: class {
    func showProfile(username:String)
}
