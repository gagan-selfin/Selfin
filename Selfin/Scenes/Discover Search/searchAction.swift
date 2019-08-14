//
//  searchAction.swift
//  Selfin
//
//  Created by cis on 28/12/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation
protocol DiscoverSearchCoordinatorDelegate {
    func moveToUserProfileFromDiscoverSearch(username: String)
    func showHashtagPosts(search: String)
    func showLocationPosts(search: String)

}

protocol SearchControllerDelegate :class {
    func didReceived(type:SearchRequestURL.searchStyle, result:FollowingFollowersResponse)
    func didReceivedTags(result:SearchTags)
    func didReceivedLocation(result:SearchLocation)
    func didReceived(error msg : String)
}

enum searchCollectionStyle : String {
    case most = "most"
    case people = "user"
    case tag = "hashtag"
    case location = "location"
}

protocol SearchCollectionDelegate : class {
    func fetchData(type : SearchRequestURL.searchStyle, strSearch : String , page :Int)
    func didViewUserProfile(username:String)
}

protocol FollowUnfollowUserDelegate: class {
    func didReceived(error msg: String)
    func didReceived(data: followUnfollowUser)
}



